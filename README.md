<img src="https://dl.dropboxusercontent.com/u/858551/logo_swift_2x.png" height="119"/>
<br>
**swiftx** is a web framework written in Swift 3 aiming for simplicity and performance.
<br><br>
* It runs on `Ubuntu`, `macOS` and `iOS`.
* It has zero external dependencies (fast compilation).
* It uses `poll & kqueue` sys calls (asynchronous io).
<br><br>
(don't worry about [swifter](https://github.com/httpswift/swifter). it's all good. swiftx will be merged with swifter).

### Getting started
```swift
let server = try Server()
while true {
    try server.serve { request, responder in 
        responder(TextResponse(200, "hello"))
    }
}
```
Demo [Guest Book](http://138.68.93.146:8080)

Emoji DSL
```swift
🦄(port: 8080) { 
    🚀($0, "hello") 
}
```

Amazon Deploy
```shell
# ./deploy_to_amazon_ec2 <address> <port> <private key>
$ ./deploy_to_amazon_ec2 ubuntu@amazon.com 8080 my_key.pem
```

Digital Ocean Deploy
```shell
# ./deploy_to_digital_ocean <address> <port>
$ ./deploy_to_digital_ocean root@1.2.3.4 8080
```

🕊 Roadmap: Tests. Docker.
