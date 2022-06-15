defmodule DashoeWeb.PageController do
  use DashoeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
