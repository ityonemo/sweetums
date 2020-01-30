defmodule SweetumsTest do
  use ExUnit.Case

  describe "when you send a post request" do
    test "it works" do
      assert {:ok, conn} = Mint.HTTP1.connect(:http, "localhost", 9000)
    end
  end
end
