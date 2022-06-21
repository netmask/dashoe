defmodule Dashoe.Repo.Migrations.CreateProductInventoryLocations do
  use Ecto.Migration

  def change do
    create table(:product_inventory_locations) do
      add :product_code, :string
      add :location_name, :string
      add :last_inventory, :integer
      add :amount_changed, :integer
      add :current_inventory, :integer
      add :history, {:array, :map}
      add :stats, :map

      timestamps()
    end

    create index(:product_inventory_locations, [:location_name, :product_code], unique: true)
  end
end
