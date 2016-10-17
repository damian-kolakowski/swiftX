![alt](https://dl.dropboxusercontent.com/u/858551/logo_swift_x.png)
<br>
**swiftx** is a web framework written in Swift (𝟯.x) aiming for simplicity and performance.
<br><br>
* It runs on `Ubuntu`, `macOS` and `iOS`.
* Zero dependencies equals `fast compilation` time.
<br><br>

Hello World

```shell
> git clone git@gitlab.com:glock45/swiftX.git
> cd swiftX
>
> echo '🚀🦄(port: 8080) { 👞($0, "hello") }' > ./Source/main.swift
>
> swift build
> .build/debug/swiftX
...visit http://127.0.0.1:8080/
```
Deploy
```
> ./deploy_to_amazon_ec2 ubuntu@amazon.com 8080 my_key.pem
> ./deploy_to_digital_ocean root@1.2.3.4 8080
```
🕊 Roadmap: Tests. Docker.
