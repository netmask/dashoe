defmodule Dashoe.StoreFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Dashoe.Store` context.
  """

  @doc """
  Generate a product_inventory_location.
  """
  def product_inventory_location_fixture(attrs \\ %{}) do
    {:ok, product_inventory_location} =
      attrs
      |> Enum.into(%{
        current_inventory: 42,
        history: [],
        location_name: "some location_name",
        product_code: "some product_code",
        stats: %{}
      })
      |> Dashoe.Store.create_product_inventory_location()

    product_inventory_location
  end
end
