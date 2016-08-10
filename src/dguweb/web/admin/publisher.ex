defmodule DGUWeb.ExAdmin.Publisher do
  use ExAdmin.Register

  register_resource DGUWeb.Publisher do
    index do
      selectable_column

      column :id
      column :name
      column :title
      column :category
      actions       # display the default actions column
    end
  end
end
