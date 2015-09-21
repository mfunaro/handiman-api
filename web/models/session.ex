defmodule HandimanApi.Session do
    alias HandimanApi.User

    def login(params, conn) do
      user = HandimanApi.Repo.get_by(User, email: String.downcase(params["email"]))
      token = Phoenix.Token.sign(conn, "user", user.id)
      case authenticate(user, params["password"]) do
        true -> User.update_token(user, conn)
        _ -> {:error, %{message: "Invalid email or password"}}
      end
    end

    defp authenticate(user, password) do
      case user do
        nil -> false
        _ -> Comeonin.Bcrypt.checkpw(password, user.encrypted_password)
      end
    end
end
