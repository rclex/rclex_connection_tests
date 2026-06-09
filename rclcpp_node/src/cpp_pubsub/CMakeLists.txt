cmake_minimum_required(VERSION 3.5...3.20)
project(cpp_pubsub)

set(ros_distro_lyrical FALSE)
if(DEFINED ENV{ROS_DISTRO} AND NOT "$ENV{ROS_DISTRO}" STREQUAL "")
  if("$ENV{ROS_DISTRO}" STREQUAL "lyrical" OR "$ENV{ROS_DISTRO}" STREQUAL
                                              "rolling")
    set(ros_distro_lyrical TRUE)
  endif()
endif()

# Default to C99
if(NOT CMAKE_C_STANDARD)
  set(CMAKE_C_STANDARD 99)
endif()

# Default to the C++ standard for each distro family.
if(NOT CMAKE_CXX_STANDARD)
  if(ros_distro_lyrical)
    set(CMAKE_CXX_STANDARD 20)
  else()
    set(CMAKE_CXX_STANDARD 14)
  endif()
endif()

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# find dependencies
find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(std_msgs REQUIRED)

add_executable(talker src/talker.cpp)
add_executable(listener src/listener.cpp)
if(ros_distro_lyrical OR NOT COMMAND ament_target_dependencies)
  target_link_libraries(talker PUBLIC rclcpp::rclcpp ${std_msgs_TARGETS})
  target_link_libraries(listener PUBLIC rclcpp::rclcpp ${std_msgs_TARGETS})
else()
  ament_target_dependencies(listener rclcpp std_msgs)
  ament_target_dependencies(talker rclcpp std_msgs)
endif()
install(TARGETS talker listener DESTINATION lib/${PROJECT_NAME})

if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  ament_lint_auto_find_test_dependencies()
endif()

ament_package()
