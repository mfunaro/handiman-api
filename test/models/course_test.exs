defmodule HandimanApi.CourseTest do
  use HandimanApi.ModelCase

  alias HandimanApi.Course

  @valid_attrs %{city: "some content", name: "some content", state: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Course.changeset(%Course{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Course.changeset(%Course{}, @invalid_attrs)
    refute changeset.valid?
  end
end
