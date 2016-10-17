![alt](https://dl.dropboxusercontent.com/u/858551/logo_swift_x.png)
<br>
**swiftx** is a web framework written in Swift 3 aiming for simplicity and performance.
<br><br>
* It runs on `Ubuntu`, `macOS` and `iOS`.
* Zero external dependencies.
<br><br>

### Getting started

```shell
$ git clone git@gitlab.com:glock45/swiftX.git
$ cd swiftX
$ echo 'hello_world(port: 8080) { 👞($0, "hello") }' > ./src/main.swift
$ swift build
$ .build/debug/swiftX
...visit http://127.0.0.1:8080/
```

Deploy
```shell
# ./deploy_to_amazon_ec2 <address> <port> <private key>
$ ./deploy_to_amazon_ec2 ubuntu@amazon.com 8080 my_key.pem
```
🕊 Roadmap: Tests. Docker.
