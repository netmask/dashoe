defmodule DashoeWeb.Helpers do
  alias DashoeWeb.Router.Helpers, as: Routes
  use Phoenix.HTML

  def store_link(socket, store) do
    store && link(store, to: Routes.store_path(socket, :show, store), class: "underline")
  end

  def product_link(socket, product) do
    product && link(product, to: Routes.product_path(socket, :show, product), class: "underline")
  end

  def product_level_bg(inventory_level) when is_list(inventory_level) do
    inventory = String.to_integer(inventory_level)
    product_level_bg(inventory)
  end

  def product_level_bg(inventory_level) do
    case inventory_level do
      i when i == 0 ->
        "bg-red-600"

      i when i in 1..10 ->
        "bg-red-400"

      i when i in 10..20 ->
        "bg-yellow-400"

      i when i in 20..50 ->
        "bg-zinc-50"

      i when i in 50..70 ->
        "bg-green-400"

      i when i > 70 ->
        "bg-indigo-700 text-white"
    end
  end
end
