# 概要
ROS2クライアントライブラリ[rclex](https://github.com/rclex/rclex)のテストディレクトリです。  
rclexのCIで使われることを想定しています。
# 使い方
## dockerを使用する場合
[rclex](https://github.com/rclex/rclex)ディレクトリと並列にこのレポジトリを配置してください。
rclex_dockerイメージが使用できる状態で`rclex_connection_tests`ディレクトリ直下で`test_in_docker.sh`を実行してください。
## dockerを使用しない場合
rclexディレクトリ直下にrclex_connection_testsを配置してください。  
その後、rclex_connection_testsディレクトリで`entrypoint.sh`を実行してください。  
```
$ cd /path/to/rclex_connection_tests
$ ./entrypoint.sh
```
# 方針
テスト方針は[こちら](https://docs.google.com/presentation/d/1JKKWJh-f0EvkdYsMfv1cXwphZdbnasCLiJnGNy0E4Z8/edit?usp=sharing)に書いています。
