defmodule DGUWeb.UserControllerTest do
  use DGUWeb.ConnCase

  alias DGUWeb.{User, Publisher, PublisherUser}


  @valid_attrs %{username: "bob", email: "bob@localhost.local", password: "Password"}

  test "valid user can be in ", %{conn: conn} do 
    # Create a user using registration
    conn = post conn, session_path(conn, :create), user: @valid_attrs
    assert redirected_to(conn) == "/"

    # Get a reference so we can fake add them to a publisher 
    user = Repo.get_by!(User, username: "bob")
    assert user

    {:ok, publisher} = Repo.insert(%Publisher{
        name: "cabinet-office", title: "Cabinet Office", url: "http://..."
    })

    {:ok, pu} = Repo.insert(%PublisherUser{user_id: user.id, publisher_id: publisher.id, role: "admin"})
    
    # Login and then check that our newly added org is on the page
    conn = post conn, session_path(conn, :login), session: @valid_attrs
    assert redirected_to(conn) == "/user"

    conn = get conn, user_path(conn, :index)
    assert html_response(conn, 200) =~ "Cabinet Office" 
    assert html_response(conn, 200) =~ "admin" 
  end 

end 
