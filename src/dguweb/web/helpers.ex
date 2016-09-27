defmodule DGUWeb.TemplateHelpers do


  # Truncates text to 140 characters either at the first ., the first \n or at 137
  # chars <> "..."
  def truncate_text(text), do: DGUWeb.Util.Truncation.truncate(text)

  def strip_url_name(url) do
    url
      |> String.split("/")
      |> Enum.reverse
      |> hd
      |> URI.decode
      |> String.replace("-", " ")
      |> String.replace("_", " ")
  end

end
