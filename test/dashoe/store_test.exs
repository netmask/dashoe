defmodule Dashoe.StoreTest do
  use Dashoe.DataCase

  alias Dashoe.Store

  describe "product_inventory_locations" do
    alias Dashoe.Store.ProductInventoryLocation

    import Dashoe.StoreFixtures

    @invalid_attrs %{current_inventory: nil, history: nil, location_name: nil, product_code: nil, stats: nil}

    test "list_product_inventory_locations/0 returns all product_inventory_locations" do
      product_inventory_location = product_inventory_location_fixture()
      assert Store.list_product_inventory_locations() == [product_inventory_location]
    end

    test "get_product_inventory_location!/1 returns the product_inventory_location with given id" do
      product_inventory_location = product_inventory_location_fixture()
      assert Store.get_product_inventory_location!(product_inventory_location.id) == product_inventory_location
    end

    test "create_product_inventory_location/1 with valid data creates a product_inventory_location" do
      valid_attrs = %{current_inventory: 42, history: [], location_name: "some location_name", product_code: "some product_code", stats: %{}}

      assert {:ok, %ProductInventoryLocation{} = product_inventory_location} = Store.create_product_inventory_location(valid_attrs)
      assert product_inventory_location.current_inventory == 42
      assert product_inventory_location.history == []
      assert product_inventory_location.location_name == "some location_name"
      assert product_inventory_location.product_code == "some product_code"
      assert product_inventory_location.stats == %{}
    end

    test "create_product_inventory_location/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Store.create_product_inventory_location(@invalid_attrs)
    end

    test "update_product_inventory_location/2 with valid data updates the product_inventory_location" do
      product_inventory_location = product_inventory_location_fixture()
      update_attrs = %{current_inventory: 43, history: [], location_name: "some updated location_name", product_code: "some updated product_code", stats: %{}}

      assert {:ok, %ProductInventoryLocation{} = product_inventory_location} = Store.update_product_inventory_location(product_inventory_location, update_attrs)
      assert product_inventory_location.current_inventory == 43
      assert product_inventory_location.history == []
      assert product_inventory_location.location_name == "some updated location_name"
      assert product_inventory_location.product_code == "some updated product_code"
      assert product_inventory_location.stats == %{}
    end

    test "update_product_inventory_location/2 with invalid data returns error changeset" do
      product_inventory_location = product_inventory_location_fixture()
      assert {:error, %Ecto.Changeset{}} = Store.update_product_inventory_location(product_inventory_location, @invalid_attrs)
      assert product_inventory_location == Store.get_product_inventory_location!(product_inventory_location.id)
    end

    test "delete_product_inventory_location/1 deletes the product_inventory_location" do
      product_inventory_location = product_inventory_location_fixture()
      assert {:ok, %ProductInventoryLocation{}} = Store.delete_product_inventory_location(product_inventory_location)
      assert_raise Ecto.NoResultsError, fn -> Store.get_product_inventory_location!(product_inventory_location.id) end
    end

    test "change_product_inventory_location/1 returns a product_inventory_location changeset" do
      product_inventory_location = product_inventory_location_fixture()
      assert %Ecto.Changeset{} = Store.change_product_inventory_location(product_inventory_location)
    end
  end
end
