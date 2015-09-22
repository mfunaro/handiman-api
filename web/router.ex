defmodule HandimanApi.Router do
  use HandimanApi.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug HandimanApi.Plugs.Auth
  end

  scope "/api", HandimanApi do
    pipe_through :api
    pipe_through :auth

    resources "/users", UserController, except: [:new, :edit]
  end

  scope "/api", HandimanApi do
    pipe_through :api

    resources "/registration", RegistrationController, only: [:create]
    resources "/login", SessionController, only: [:create]
    delete "/logout", SessionController, :delete
  end
end
