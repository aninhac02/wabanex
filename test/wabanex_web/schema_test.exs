defmodule WabanexWeb.SchemaTest do
  use WabanexWeb.ConnCase, async: true

  alias Wabanex.User
  alias Wabanex.Users.Create

  describe "users queries" do
    test "when a valid id is given, returns the user", %{conn: conn} do
      params = %{email: "amy@amy.com", name: "Amy", password: "123456"}

      {:ok, %User{id: user_id}} = Create.call(params)

      query = """
        {
          getUser(id: "#{user_id}"){
            name
            email
          }
        }
      """

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(:ok)

        expected_response =  %{
          "data" => %{
            "getUser" => %{
              "email" => "amy@amy.com",
              "name" => "Amy"
            }
          }
        }

        assert response == expected_response

    end

    test "when an invalid id is given, returns an error", %{conn: conn} do
      params = %{email: "amy@amy.com", name: "Amy", password: "123456"}

      {:ok, %User{id: user_id}} = Create.call(params)

      query = """
        {
          getUser(id: "#{123}"){
            name
            email
          }
        }
      """

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(:ok)

        expected_response =   %{
          "errors" => [%{
            "locations" => [%{"column" => 13, "line" => 2}],
            "message" => "Argument \"id\" has invalid value \"123\"."}]}

        assert response == expected_response

    end
  end

  describe "users mutations" do
    test "when all params are valid, creates the user", %{conn: conn} do
      mutation = """
        mutation{
          createUser(input: {name: "rafa", email: "rafa@rafa.com", password: "123456"
          }){
           id
            name
          }
        }
      """

      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)



      assert  %{"data" => %{"createUser" => %{"id" => _id, "name" => "rafa"}}} = response
    end
  end


end
