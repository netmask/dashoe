defmodule Dashoe.Store.ProductInventoryLocation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "product_inventory_locations" do
    field :current_inventory, :integer
    field :last_inventory, :integer

    field :history, {:array, :map}
    field :location_name, :string
    field :product_code, :string
    field :stats, :map
    field :amount_changed, :integer

    timestamps()
  end

  @doc false
  def changeset(product_inventory_location, attrs) do
    product_inventory_location
    |> cast(attrs, [
      :product_code,
      :last_inventory,
      :location_name,
      :amount_changed,
      :current_inventory,
      :history,
      :stats
    ])
    |> validate_required([:product_code, :location_name, :current_inventory, :history, :stats])
  end
end
