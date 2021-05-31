# 概要

ROS2クライアントライブラリ[Rclex](https://github.com/rclex/rclex)のテストディレクトリです。  

Rclex自体の開発途中のテストやGitHub ActionsによるCIで使われることを想定しているため、Rclexのリポジトリがローカルにあり、本リポジトリと並列にディレクトリが配置されている必要があります。
以下のように、2つのリポジトリのディレクトリを配置してください。

```
$ cd /path/to/yours
$ git clone https://github.com/rclex/rclex
$ git clone https://github.com/rclex/rclex_connection_tests
$ ls
rclex  rclex_connection_tests
```

# 使い方

## ネイティブ環境での使い方 

ROS 2およびElixir/Erlangの導入済みの環境では、`run-all.sh`を実行してください。

```
$ cd /path/to/yours/rclex_connection_tests
$ ./run-all.sh
```

`./run-rebuild.sh`は通信テスト用ノードのクリーンビルドのみを実行します。`rclcpp` または `rclex` のオプションでそれぞれ個別のビルドを指定することもできます。

`./run-test.sh`は通信テストのみを実行します。任意個数の引数で対象とするテストスクリプトを指定することもできます。

## Dockerを使用する場合

Dockerが使用できる環境では、[Docker Hub](https://hub.docker.com/r/rclex/rclex_docker)で公開しているimageを使用して、次のように実行することもできます。

```
$ cd /path/to/yours/rclex_connection_tests
$ ./test_in_docker.sh
```

# 方針

テスト方針は[こちら](https://docs.google.com/presentation/d/1JKKWJh-f0EvkdYsMfv1cXwphZdbnasCLiJnGNy0E4Z8/edit?usp=sharing)に書いています。
