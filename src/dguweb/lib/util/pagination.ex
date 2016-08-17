defmodule DGUWeb.Util.Pagination do

  @default_size 10

  defstruct total: 0, page: 1, page_count: 1, size: @default_size

  def create(total, page \\ 1, size \\ @default_size) do
    %__MODULE__{
      total: total,
      page: page,
      size: size,
      page_count: calc_page_count(total, size)
    }
  end

  def has_previous(_pagination, page) do
    page != 1
  end

  def has_next(pagination, page) do
    page < pagination.page_count
  end

  def offset_for_page(pagination, p) when p < 0, do: offset_for_page(pagination, 1)

  def offset_for_page(pagination, page) when is_integer(page) do
    case page > pagination.page_count do
      true ->
        0
      _ ->
        (page * pagination.size) - pagination.size
    end
  end

  def offset_for_page(pagination, page), do: offset_for_page(pagination, String.to_integer(page))

  def calc_page_count(total, size) do
    Float.ceil(total / size) |> round
  end
end
