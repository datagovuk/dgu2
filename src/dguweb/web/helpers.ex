defmodule DGUWeb.TemplateHelpers do


  # Truncates text to 140 characters either at the first ., the first \n or at 137
  # chars <> "..."
  def truncate_text(text), do: DGUWeb.Util.Truncation.truncate(text)

  def is_number_string(val) do
    IO.puts "hello world"
    IO.puts val
    case Float.parse(val) do
      :error -> false
      {_, ""} -> true
      {_, _} -> false
    end
  end

  def to_currency(val) do
    if is_number_string(val) do
      Regex.replace(~r/(\d)(?=(\d{3})+$)/, val, "\\1,")
    else
      ""
    end
  end

end
