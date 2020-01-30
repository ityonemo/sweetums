defmodule SweetumsTest do
  use ExUnit.Case

  describe "when you send a post request" do
    test "it works" do

      {:ok, d} = Sweetums.Daemon.start_link(nil)
      {:ok, port} = Sweetums.Daemon.port(d)

      assert {:ok, conn} = Mint.HTTP1.connect(:http, "localhost", port)
      {:ok, conn, _ref} = Mint.HTTP.request(conn, "GET", "/", [], nil)

      message = receive do msg -> msg end

      {:ok, conn, _} = Mint.HTTP.stream(conn, message)

      assert conn.request.status == 200
    end
  end
end
