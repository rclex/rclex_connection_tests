defmodule Test.App.SimplePubSub do
  alias Rclex.Pkgs.StdMsgs

  def pub_main() do
    node_name = "test_pub_node"
    topic_name = "/testtopic"

    Rclex.start_node(node_name)
    Rclex.start_publisher(StdMsgs.Msg.String, topic_name, node_name)

    # Create data to be published
    data = Test.Helper.String.random_string(10)
    File.write("pub_msg.txt", data, [:sync])

    message = struct(StdMsgs.Msg.String, %{data: "#{data}"})

    IO.puts("[rclex] pub time:#{:os.system_time(:microsecond)}")
    IO.puts("[rclex] publishing msg: #{data}")
    Rclex.publish(message, topic_name, node_name)

    wait_until_subscription()

    Rclex.stop_node(node_name)
  end

  def sub_main() do
    node_name = "test_sub_node"
    topic_name = "/testtopic"

    Rclex.start_node(node_name)
    Rclex.start_subscription(&sub_callback/1, StdMsgs.Msg.String, topic_name, node_name)

    File.write("sub_ready.txt", "", [:sync])

    wait_until_subscription()
    IO.puts("[rclex] subscription has completed")

    Rclex.stop_node(node_name)
  end

  # Describe callback function.
  def sub_callback(msg) do
    IO.puts("[rclex] sub time:#{:os.system_time(:microsecond)}")
    IO.puts("[rclex] subscribed msg: #{msg.data}")
    File.write("sub_msg.txt", msg.data, [:sync])
  end

  defp wait_until_subscription() do
    if !File.exists?("sub_msg.txt") do
      Process.sleep(100)
      wait_until_subscription()
    end
  end
end
