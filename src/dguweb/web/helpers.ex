defmodule DGUWeb.TemplateHelpers do


  # Truncates text to 140 characters either at the first ., the first \n or at 137
  # chars <> "..."
  def truncate_text(text), do: DGUWeb.Util.Truncation.truncate(text)

end
