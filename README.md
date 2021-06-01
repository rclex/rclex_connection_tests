# rclex_connection_tests

This repository provides test scripts for [Rclex](https://github.com/rclex/rclex), that is a ROS 2 client library for Elixir.
We can check whether communication with the node implemented by Rclcpp normally.

Since it is assumed to be used for testing during the development of Rclex and operating [CI on GitHub Actions](https://github.com/rclex/rclex/actions), the repository of Rclex needs to be cloned to the local and and placed in parallel with this repository.

Place the directories of the two repositories as shown below.

```
$ cd /path/to/yours
$ git clone https://github.com/rclex/rclex
$ git clone https://github.com/rclex/rclex_connection_tests
$ ls
rclex  rclex_connection_tests
```

# Usage

## on the native environment

In an environment with ROS 2 and Elixir/Erlang installed, just execute `run-all.sh`.

```
$ cd /path/to/yours/rclex_connection_tests
$ ./run-all.sh
```

`./run-rebuild.sh` only performs clean build of nodes for the communication test. You can also specify a separate build for each with the `rclcpp` or `rclex` options.

`./run-test.sh` only runs the communication test. You can also specify the target test scripts with any number of arguments.

## when using Docker

In an environment where Docker can be used, the test can also be operated with the image published on [Docker Hub](https://hub.docker.com/r/rclex/rclex_docker) as the follow.

```
$ cd /path/to/yours/rclex_connection_tests
$ ./test_in_docker.sh
```

You can also specify the target tags of Docker image with any number of arguments (e.g., `latest`, `dashing-ex1.9.1-otp22.0.7`).

# Details

Our policy for the communication test is published on [this](https://docs.google.com/presentation/d/1JKKWJh-f0EvkdYsMfv1cXwphZdbnasCLiJnGNy0E4Z8/edit?usp=sharing)
(but only in Japanese,,, :_(
