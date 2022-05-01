defmodule KorgiWeb.PageController do
  use KorgiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
