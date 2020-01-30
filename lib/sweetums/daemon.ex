defmodule Sweetums.Daemon do
  use GenServer

  defstruct [:socket, :data]

  def start_link(data, opts \\ []) do
    gen_opts = Keyword.take(opts, [:name])
    GenServer.start_link(__MODULE__, struct(__MODULE__, data: data), gen_opts)
  end

  @impl true
  def init(state) do
    # set up the listenin' socket
    with {:ok, socket} <- :gen_tcp.listen(0, [:binary, active: false]) do

      Process.send_after(self(), :accept, 0)
      {:ok, %{state | socket: socket}}
    end
  end

  ##############################################################################
  ## API

  def port(srv) do
    GenServer.call(srv, :port)
  end
  def port_impl(state), do: {:reply, :inet.port(state.socket), state}


  @impl true
  def handle_info(:accept, state) do
    with {:ok, accept_socket} <- :gen_tcp.accept(state.socket, 100),
         {:ok, srv} <- Sweetums.Server.start_link(accept_socket) do
      # move the accept socket to the child
      :gen_tcp.controlling_process(accept_socket, srv)
    else
      {:error, :timeout} ->
        :ok
      err -> raise "unknown error #{inspect err}"
    end
    Process.send_after(self(), :accept, 0)
    {:noreply, state}
  end

  @impl true
  def handle_call(:port, _from, state), do: port_impl(state)

end
