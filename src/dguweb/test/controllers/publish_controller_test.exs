defmodule DGUWeb.PublishControllerTest do
  use DGUWeb.ConnCase

  
  @valid_attrs_upload %{file: %Plug.Upload{content_type: "text/csv", filename: "test-file.csv", path: File.cwd! <> "/test/data/small-data.csv"}, url: ""}
  @valid_attrs_url %{url: "http://servercode.co.uk/gold.csv"}  

  @invalid_attrs_missing %{file: :nil, url: :nil}
  @invalid_attrs_both %{file: :nil, url: :nil}  
  @invalid_attrs_bad_url %{file: :nil, url: "Not a valid URL"}

  test "renders form for upload", %{conn: conn} do
    conn = get conn, publish_path(conn, :index)
    assert html_response(conn, 200) =~ "Upload data"
  end

  test "creates resource and redirects when upload data is valid", %{conn: conn} do
    conn = post conn, publish_path(conn, :add_file), @valid_attrs_upload
    assert redirected_to(conn) == publish_path(conn, :find)
  end

  test "creates resource and redirects when url data is valid", %{conn: conn} do
    conn = post conn, publish_path(conn, :add_file), @valid_attrs_url
    assert redirected_to(conn) == publish_path(conn, :find)
  end

  # TODO: Fix error handling in these steps by using a changeset in the controller
  # once we're happy with the approach

  test "fails when no data provided", %{conn: conn} do
    conn = post conn, publish_path(conn, :add_file), @invalid_attrs_missing
    assert html_response(conn, 200) =~ "Please supply a URL or a file upload"
  end

  test "fails when too much data provided", %{conn: conn} do
    conn = post conn, publish_path(conn, :add_file), @invalid_attrs_both
    assert html_response(conn, 200) =~ "Please supply a URL or a file upload"
  end

  test "fails when badly formatted url provided", %{conn: conn} do
    conn = post conn, publish_path(conn, :add_file), @invalid_attrs_bad_url
    assert html_response(conn, 200) =~ "URL does not appear to be valid"
  end

end
