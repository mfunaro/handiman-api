defmodule HandimanApi.PageController do
  use HandimanApi.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
