defmodule AsciiWeb.PageController do
  use AsciiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
