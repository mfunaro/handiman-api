defmodule HandimanApi.TeeView do
  use HandimanApi.Web, :view
  use JSONAPI.PhoenixView

  def type, do: "tee"

  def attributes(model) do
    Map.take(model, [:id, :name, :course_rating, :slope_rating, :front_nine_course_rating, :front_nine_slope_rating,
                    :back_nine_course_rating, :back_nine_slope_rating, :bogey_rating, :gender])
  end

  def relationships() do
    %{
      course: %{
        view: HandimanApi.CourseView
      },
      rounds: %{
        view: HandimanApi.RoundView
      }
    }
  end

  def url_func() do
    &user_url/3
  end
end
