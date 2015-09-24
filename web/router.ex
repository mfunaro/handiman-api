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
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/api", HandimanApi do
    pipe_through :api
    pipe_through :auth

    resources "/users", UserController, except: [:new, :edit]
    resources "/tees", TeeController, except: [:new, :edit]
    resources "/rounds", RoundController

    delete "/logout", SessionController, :delete
    resources "/courses", CourseController
  end

  scope "/api", HandimanApi do
    pipe_through :api

    post "/registration", RegistrationController, :create
    post "/login", SessionController, :create
  end
end
