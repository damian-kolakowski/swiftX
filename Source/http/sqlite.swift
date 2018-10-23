//
//  sqlite.swift
//  swiftx
//
//  Copyright © 2016 kolakowski. All rights reserved.
//

import Foundation
import csqlite

public enum SQLiteError: Error {
    case error(String)
}

public class SQLite {
    
    private var mutx = pthread_mutex_t()
    private var cond = pthread_cond_t()
    
    private var jobs = Array<(() -> Void)>()
    
    private let databaseConnection: OpaquePointer
    
    public static func open(_ path: String) throws -> SQLite {
        
        var databaseConnectionPointer: OpaquePointer? = nil
        
        let result = path.withCString { sqlite3_open($0, &databaseConnectionPointer) }
        
        guard let databaseConnection = databaseConnectionPointer else {
            throw SQLiteError.error("Invalid pointer.")
        }
        
        guard result == SQLITE_OK else {
            throw SQLiteError.error(String(cString: sqlite3_errmsg(databaseConnection)))
        }
        
        return try SQLite(databaseConnection)
    }
    
    private init(_ databaseConnection: OpaquePointer) throws {
        
        self.databaseConnection = databaseConnection
        
        pthread_mutex_init(&self.mutx, nil)
        pthread_cond_init(&self.cond, nil)
        
        let pointer = UnsafeMutableRawPointer(Unmanaged.passRetained(self).toOpaque())
        
        #if os(Linux)
        var thread: pthread_t = 0
        #else
        var thread: pthread_t? = nil
        #endif

        guard pthread_create(&thread, nil, {
            #if os(Linux)
            let unmanaged = Unmanaged<SQLite>.fromOpaque($0!)
            #else
            let unmanaged = Unmanaged<SQLite>.fromOpaque($0)
            #endif
            let worker = unmanaged.takeUnretainedValue()
            while true {
                pthread_mutex_lock(&worker.mutx)
                while worker.jobs.count <= 0 {
                    pthread_cond_wait(&worker.cond, &worker.mutx)
                }
                if let closure = worker.jobs.last {
                    let _ = worker.jobs.removeLast()
                    pthread_mutex_unlock(&worker.mutx)
                    closure()
                } else {
                    pthread_mutex_unlock(&worker.mutx)
                }
            }
            unmanaged.release()
            return nil
        }, pointer) == 0 else {
            throw SQLiteError.error(Process.error)
        }
    }
    
    deinit {
        pthread_cond_destroy(&self.cond)
        pthread_mutex_destroy(&self.mutx)
        sqlite3_close(self.databaseConnection)
    }
    
    public func schedule(_ closuer: @escaping (() -> Void)) {
        pthread_mutex_lock(&self.mutx)
        self.jobs.append(closuer)
        pthread_mutex_unlock(&self.mutx)
        pthread_cond_signal(&self.cond)
    }
    
    public func execute(_ sql: String, _ params: [String?]? = nil, _ closure: (([String: String?]) -> Void)) throws {
        
        var statementPointer: OpaquePointer? = nil
        
        let result = sql.withCString {
            sqlite3_prepare_v2(databaseConnection, $0, Int32(sql.utf8.count), &statementPointer, nil)
        }
        
        guard result == SQLITE_OK else {
            throw SQLiteError.error(String(cString: sqlite3_errmsg(databaseConnection)))
        }
        
        guard let statement = statementPointer else {
            throw SQLiteError.error("Invalid pointer.")
        }
        
        for (index, value) in (params ?? [String?]()).enumerated() {
            
//            let bindResult = value?
//                .withCString({ sqlite3_bind_text(statement, index + 1, $0, -1 /* take zero terminator. */) { _ in } })
//                    ?? sqlite3_bind_null(statement, index + 1)
//            
//            guard bindResult == SQLITE_OK else {
//                throw SQLiteError.error(String(cString: sqlite3_errmsg(databaseConnection)))
//            }
        }
        
        var content = [String: String?]()
        
        while true {
            let stepResult = sqlite3_step(statement)
            switch stepResult {
            case SQLITE_ROW:
                content.removeAll()
                for i in 0..<sqlite3_column_count(statement) {
                    let name = String(cString: UnsafePointer<CChar>(sqlite3_column_name(statement, i)))
                    if let pointer = sqlite3_column_text(statement, i) {
                        content[name] = String(cString: UnsafePointer<CChar>(OpaquePointer(pointer)))
                    } else {
                        content[name] = nil
                    }
                }
                closure(content)
            case SQLITE_DONE:
                return
            case SQLITE_ERROR:
                throw SQLiteError.error("sqlite3_step() returned SQLITE_ERROR.")
            default:
                throw SQLiteError.error("Unknown result for sqlite3_step(): \(stepResult)")
            }
        }
    }
}
