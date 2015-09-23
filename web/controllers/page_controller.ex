defmodule HandimanApi.PageController do
  use HandimanApi.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def unauthenticated_api(conn, _params) do
    the_conn = put_status(conn, 401)
    case Guardian.Plug.claims(conn) do
      { :error, reason } -> json(the_conn, %{ error: reason })
      _ -> json(the_conn, %{ error: "Login required" })
    end
  end
end
