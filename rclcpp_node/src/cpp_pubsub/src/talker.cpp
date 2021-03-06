#include <chrono>
#include <functional>
#include <memory>
#include <string>
#include <fstream>
#include <random>

#include "rclcpp/rclcpp.hpp"
#include "std_msgs/msg/string.hpp"

using namespace std::chrono_literals;

class Test_String 
{
public:
  static std::string get_random_string(const int len){
    static const char alphanum[] =
          "0123456789"
          "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
          "abcdefghijklmnopqrstuvwxyz";
    srand (time(NULL));    
    std::string random_string;
    for (int i = 0; i < len; ++i) {
      random_string += alphanum[rand() % (sizeof(alphanum) - 1)];
    }
    return random_string;
  }
};

int main(int argc, char *argv[]) {

  rclcpp::init(argc, argv);
  auto node = rclcpp::Node::make_shared("talker");

  auto publisher = node->create_publisher<std_msgs::msg::String>("testtopic", 10);

  std_msgs::msg::String message;
  message.data = Test_String::get_random_string(10);
  RCLCPP_INFO(rclcpp::get_logger("rclcpp"), "publishing msg: %s", message.data.c_str());

  rclcpp::WallRate rate(1s);
  while (true) {
    publisher->publish(message);
    std::ofstream ofs("pub_msg.txt");
    ofs << message.data << std::endl;
    rclcpp::spin_some(node);
    rate.sleep();
    std::ifstream ifs("sub_msg.txt");
    if (ifs.is_open())
      break;
  }
  rclcpp::shutdown();
  return 0;
}
