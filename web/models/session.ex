defmodule HandimanApi.Session do
    alias HandimanApi.User

    def login(params, conn) do
      user = HandimanApi.Repo.get_by(User, email: String.downcase(params["email"]))
      case authenticate(user, params["password"]) do
        true ->
          setup_and_create_token(conn, user)
        _ -> {:error, %{message: "Invalid email or password"}}
      end
    end

    defp authenticate(user, password) do
      case user do
        nil -> false
        _ -> Comeonin.Bcrypt.checkpw(password, user.encrypted_password)
      end
    end

    defp setup_and_create_token(conn, resource) do
      conn = Guardian.Plug.set_current_resource(conn, resource)
      {Guardian.encode_and_sign(resource, :api), conn}
    end
end
