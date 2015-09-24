defmodule HandimanApi.TeeView do
  use HandimanApi.Web, :view

  def render("index.json", %{tees: tees}) do
    %{data: render_many(tees, HandimanApi.TeeView, "tee.json")}
  end

  def render("show.json", %{tee: tee}) do
    %{data: render_one(tee, HandimanApi.TeeView, "tee.json")}
  end

  def render("tee.json", %{tee: tee}) do
    %{id: tee.id,
      name: tee.name,
      course_rating: tee.course_rating,
      slope_rating: tee.slope_rating,
      front_nine_course_rating: tee.front_nine_course_rating,
      front_nine_slope_rating: tee.front_nine_slope_rating,
      back_nine_course_rating: tee.back_nine_course_rating,
      back_nine_slope_rating: tee.back_nine_slope_rating,
      bogey_rating: tee.bogey_rating,
      gender: tee.gender,
      course_id: tee.course_id}
  end
end
