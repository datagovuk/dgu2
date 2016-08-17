defmodule DGUWeb.PaginationTest do
  use ExUnit.Case

  alias DGUWeb.Util.Pagination, as: P

  test "can create a pagination with all details" do
    p = P.create(100, 1, 10)
    assert p.size == 10
    assert p.total == 100
    assert p.page == 1
  end

  test "can create a pagination with total and page" do
    p = P.create(100, 1)
    assert p.size == 10
    assert p.total == 100
    assert p.page == 1
  end

  test "can create a pagination with just a total" do
    p = P.create(100)
    assert p.size == 10
    assert p.total == 100
    assert p.page == 1
  end

  test "can get page count" do
    assert P.calc_page_count(0, 10) == 0
    assert P.calc_page_count(1, 10) == 1
    assert P.calc_page_count(10, 10) == 1
    assert P.calc_page_count(100, 10) == 10
    assert P.calc_page_count(100, 20) == 5

    assert P.calc_page_count(102, 10) == 11
  end

  test "can get offset for a given page" do
    p = P.create(105, 1, 10) # 11 pages
    assert P.offset_for_page(p, 1) == 0
    assert P.offset_for_page(p, 11) == 100
    assert P.offset_for_page(p, 200) == 0
  end

  test "whether we can tell if there is a previous page" do
    p = P.create(105, 1, 10) # 11 pages
    assert P.has_previous(p, 1) == false
    assert P.has_previous(p, 2) == true
    assert P.has_previous(p, p.page_count + 1) == true
  end

  test "whether we can tell if there is a next page" do
    p = P.create(105, 1, 10) # 11 pages
    assert P.has_next(p, 1) == true
    assert P.has_next(p, 2) == true
    assert P.has_next(p, p.page_count) == false
  end

end
