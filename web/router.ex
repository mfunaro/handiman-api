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
    plug PlugCors, [origins: ["localhost:4200"]]
  end

  pipeline :auth do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/api", HandimanApi do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit] do
        resources "/rounds", RoundController
    end

    resources "/courses", CourseController do
      resources "/tees", TeeController, except: [:new, :edit]
    end

    delete "/logout", SessionController, :delete
  end

  scope "/api", HandimanApi do
    pipe_through :api

    post "/registration", RegistrationController, :create
    post "/login", SessionController, :create
  end
end
