defmodule Test.App.SimplePubSub do
  @moduledoc """
    The sample which makes any number of publishers.
  """
  def pub_main(num_node) do
    # Create data to be published
    data = Test.Helper.String.random_string(10)
    IO.puts("[rclex] publishing message: #{data}")
    File.write("pub_msg.txt", data, [:sync])

    context = Rclex.rclexinit()
    {:ok, nodes} = Rclex.ResourceServer.create_nodes(context, 'test_pub_node', num_node)
    {:ok, publishers} = Rclex.Node.create_publishers(nodes, 'StdMsgs.Msg.String', 'testtopic', :single)

    {:ok, timer} =
      Rclex.ResourceServer.create_timer(&pub_callback/1, publishers, 1000, "test_timer")

    # In timer_start/2,3, the number of times that the timer process is executed can be set.
    # If it is not set, the timer process loops forever.

    wait_until_subscription()

    Process.sleep(3000)
    Rclex.ResourceServer.stop_timer(timer)
    Rclex.Node.finish_jobs(publishers)
    Rclex.ResourceServer.finish_nodes(nodes)
    Rclex.shutdown(context)
  end

  @doc """
    Timer event callback function defined by user.
  """
  def pub_callback(publishers) do
    # Create messages according to the number of publishers.
    n = length(publishers)
    msg_list = Rclex.Msg.initialize_msgs(n, 'StdMsgs.Msg.String')
    # Set data.
    {:ok, data} = File.read("pub_msg.txt")
    message= %Rclex.StdMsgs.Msg.String{data: String.to_charlist(data)}

    Enum.map(0..(n - 1), fn index ->
      Rclex.Msg.set(Enum.at(msg_list, index), message, 'StdMsgs.Msg.String')
    end)

    # Publish topics.
    # IO.puts("pub time:#{:os.system_time(:microsecond)}")
    Rclex.Publisher.publish(publishers, msg_list)
  end

  def sub_main(num_node) do
    # Create as many nodes as you specify in num_node
    context = Rclex.rclexinit()
    {:ok, nodes} = Rclex.ResourceServer.create_nodes(context, 'test_sub_node', num_node)
    {:ok, subscribers} = Rclex.Node.create_subscribers(nodes, 'StdMsgs.Msg.String', 'testtopic', :single)
    Rclex.Subscriber.start_subscribing(subscribers, context, &sub_callback/1)

    Process.sleep(3000)
    File.write("sub_ready.txt", "", [:sync])

    wait_until_subscription()
    IO.puts("[rclex] subscription has completed")

    Rclex.Subscriber.stop_subscribing(subscribers)
    Rclex.Node.finish_jobs(subscribers)
    Rclex.ResourceServer.finish_nodes(nodes)
    Rclex.shutdown(context)
  end

  # Describe callback function.
  def sub_callback(msg) do
    # IO.puts("sub time:#{:os.system_time(:microsecond)}")
    recv_msg = Rclex.Msg.read(msg, 'StdMsgs.Msg.String')
    msg_data = List.to_string(recv_msg.data)
    IO.puts("[rclex] received msg: #{msg_data}")
    File.write("sub_msg.txt", msg_data, [:sync])
  end

  defp wait_until_subscription() do
    if !File.exists?("sub_msg.txt") do
      Process.sleep(100)
      wait_until_subscription()
    end
  end
end
