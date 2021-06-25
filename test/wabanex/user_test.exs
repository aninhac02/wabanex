defmodule Wabanex.UserTest do
  use Wabanex.DataCase, async: true

  alias Wabanex.User

  describe "changset/1" do
    test "when all params are valid, returns a valid changeset" do
      params = %{name: "Ana", email: "ana@ana.com", password: "123456"}

      response = User.changeset(params)

      assert %Ecto.Changeset{
        valid?: true,
        changes: %{email: "ana@ana.com", name: "Ana", password: "123456"},
        errors: []
      } = response
    end

    test "when there are invalid params, returns a invalid changeset" do
      params = %{name: "A", email: "ana@ana.com"}

      response = User.changeset(params)

      expected_response = %{
        name: ["should be at least 2 character(s)"],
        password: ["can't be blank"]
      }

      assert errors_on(response) == expected_response
    end
  end

end
