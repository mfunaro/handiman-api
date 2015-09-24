defmodule HandimanApi.CourseView do
  use HandimanApi.Web, :view

  def render("index.json", %{courses: courses}) do
    %{data: render_many(courses, HandimanApi.CourseView, "course.json")}
  end

  def render("show.json", %{course: course}) do
    %{data: render_one(course, HandimanApi.CourseView, "course.json")}
  end

  def render("course.json", %{course: course}) do
    %{id: course.id,
      name: course.name,
      city: course.city,
      state: course.state}
  end
end
