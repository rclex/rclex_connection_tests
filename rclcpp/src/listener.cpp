#include <string>
#include <iostream>
#include <fstream>

#include "rclcpp/rclcpp.hpp"
#include "std_msgs/msg/string.hpp"

using std::placeholders::_1;

class Listener : public rclcpp::Node
{
public:
  Listener()
  : Node("listener")
  {
    subscription_ = this->create_subscription<std_msgs::msg::String>(
      "testtopic", 10, std::bind(&Listener::topic_callback, this, _1));
  }

private:
  void topic_callback(const std_msgs::msg::String::SharedPtr msg) const
  {
    std::ofstream ofs("cpp_sub.txt");
    ofs << msg->data.c_str() << std::endl;
    std::cout << msg->data.c_str() << std::endl;
    rclcpp::shutdown();
  }
  rclcpp::Subscription<std_msgs::msg::String>::SharedPtr subscription_;
};

int main(int argc, char * argv[])
{
  rclcpp::init(argc, argv);
  rclcpp::spin(std::make_shared<Listener>());
  return 0;
}
