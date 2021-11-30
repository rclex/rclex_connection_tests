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
    {:ok, node_list} = Rclex.Executor.create_nodes(context, 'test_pub_node', num_node)
    {:ok, publisher_list} = Rclex.Node.create_publishers(node_list, 'testtopic', :single)
    {:ok, pid} = Rclex.Executor.create_timer(&pub_callback/1, publisher_list, 1000)

    # In timer_start/2,3, the number of times that the timer process is executed can be set.
    # If it is not set, the timer process loops forever.

    wait_until_subscription()

    Process.sleep(3000)
    Rclex.Executor.stop_timer(pid)
    Rclex.Node.finish_jobs(publisher_list)
    Rclex.Executor.finish_nodes(node_list)
    Rclex.shutdown(context)
  end

  @doc """
    Timer event callback function defined by user.
  """
  def pub_callback(publisher_list) do
    # Create messages according to the number of publishers.
    n = length(publisher_list)
    msg_list = Rclex.initialize_msgs(n, :string)
    # Set data.
    {:ok, data} = File.read("pub_msg.txt")

    Enum.map(0..(n - 1), fn index ->
      Rclex.setdata(Enum.at(msg_list, index), data, :string)
    end)

    # Publish topics.
    # IO.puts("pub time:#{:os.system_time(:microsecond)}")
    Rclex.Publisher.publish(publisher_list, msg_list)
  end

  def sub_main(num_node) do
    # Create as many nodes as you specify in num_node
    context = Rclex.rclexinit()
    {:ok, node_list} = Rclex.Executor.create_nodes(context, 'test_sub_node', num_node)
    {:ok, subscriber_list} = Rclex.Node.create_subscribers(node_list, 'testtopic', :single)
    Rclex.Subscriber.start_subscribing(subscriber_list, context, &sub_callback/1)

    Process.sleep(3000)
    File.write("sub_ready.txt", "", [:sync])

    wait_until_subscription()
    IO.puts("[rclex] subscription has completed")

    Rclex.Subscriber.stop_subscribing(subscriber_list)
    Rclex.Node.finish_jobs(subscriber_list)
    Rclex.Executor.finish_nodes(node_list)
    Rclex.shutdown(context)
  end

  # Describe callback function.
  def sub_callback(msg) do
    # IO.puts("sub time:#{:os.system_time(:microsecond)}")
    received_msg = Rclex.readdata_string(msg)
    IO.puts("[rclex] received msg: #{received_msg}")
    File.write("sub_msg.txt", received_msg, [:sync])
  end

  defp wait_until_subscription() do
    if !File.exists?("sub_msg.txt") do
      Process.sleep(100)
      wait_until_subscription()
    end
  end
end
