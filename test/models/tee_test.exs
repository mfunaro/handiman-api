defmodule HandimanApi.TeeTest do
  use HandimanApi.ModelCase

  alias HandimanApi.Tee

  @valid_attrs %{back_nine_course_rating: "120.5", back_nine_slope_rating: 42, bogey_rating: "120.5", course_id: 42, course_rating: 42, front_nine_course_rating: "120.5", front_nine_slope_rating: 42, gender: "some content", name: "some content", slope_rating: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Tee.changeset(%Tee{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Tee.changeset(%Tee{}, @invalid_attrs)
    refute changeset.valid?
  end
end
