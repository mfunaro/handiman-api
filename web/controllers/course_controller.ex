defmodule HandimanApi.CourseController do
  use HandimanApi.Web, :controller

  alias HandimanApi.Course

  plug :scrub_params, "course" when action in [:create, :update]

  def index(conn, _params) do
    courses = Repo.all(Course)
    render(conn, "index.json", %{data: courses, conn: conn})
  end

  def create(conn, %{"course" => course_params}) do
    changeset = Course.changeset(%Course{}, course_params)

    case Repo.insert(changeset) do
      {:ok, course} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", course_path(conn, :show, course))
        |> render("show.json", %{data: course, conn: conn})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(HandimanApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    course = Repo.get!(Course, id)
    render conn, "show.json", %{data: course, conn: conn}
  end

  def update(conn, %{"id" => id, "course" => course_params}) do
    course = Repo.get!(Course, id)
    changeset = Course.changeset(course, course_params)

    case Repo.update(changeset) do
      {:ok, course} ->
        render(conn, "show.json", %{data: course, conn: conn})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(HandimanApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    course = Repo.get!(Course, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(course)

    send_resp(conn, :no_content, "")
  end
end
