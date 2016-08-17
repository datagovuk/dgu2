defmodule DGUWeb.Util.Truncation do

  @length 140


  def truncate(text) when byte_size(text) < @length, do: text

  def truncate(text) do
    text
    |> String.strip
    |> truncate_at(".")
    |> truncate_at("\n")
    |> truncate_at(@length)
  end

  def truncate_at(text, pos) when is_integer(pos) and byte_size(text) < @length, do: text

  def truncate_at(text, pos) when is_integer(pos) and byte_size(text) >= @length do
   String.slice(text, 0..(pos-4)) <> "..."
 end

  def truncate_at(text, sep) when byte_size(text) < @length, do: text

  def truncate_at(text, sep) do
    [start|_] = String.split(text, sep)
    start
  end

end