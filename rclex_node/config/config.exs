import Config

config :rclex, ros2_message_types: ["std_msgs/msg/String"]

config :logger,
  backends: [:console],
  compile_time_purge_matching: [
    [level_lower_than: :warning]
  ]
