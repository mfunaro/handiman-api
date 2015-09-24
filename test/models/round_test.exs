defmodule HandimanApi.RoundTest do
  use HandimanApi.ModelCase

  alias HandimanApi.Round

  @valid_attrs %{differential: "120.5", holes: 42, score: 42, tee_id: 42, user_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Round.changeset(%Round{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Round.changeset(%Round{}, @invalid_attrs)
    refute changeset.valid?
  end
end
