defmodule Sweetums.Server do

  def start_link(socket) do
    GenServer.start_link(__MODULE__, socket)
  end

  def init(socket) do
    Process.send_after(self(), :recv, 0)
    {:ok, socket}
  end

  @timeout 1000


  @resp """
  HTTP/1.1 200 OK
  Content-Type: text/plain; charset=ISO-8859-1


  """

  def handle_info(:recv, socket) do
    :gen_tcp.recv(socket, 0, @timeout)

    :gen_tcp.send(socket, @resp)
    :gen_tcp.close(socket)
    {:stop, :normal, socket}
    #Process.send_after(self(), :recv, 0)
    #{:noreply, socket}
  end

end
