defmodule Dashoe.Store do
  @moduledoc """
  The Store context.
  """

  import Ecto.Query, warn: false
  alias Dashoe.Repo

  alias Dashoe.Store.ProductInventoryLocation

  @doc """
  Returns the list of product_inventory_locations.

  ## Examples

      iex> list_product_inventory_locations()
      [%ProductInventoryLocation{}, ...]

  """
  def list_product_inventory_locations do
    Repo.all(ProductInventoryLocation)
  end

  def list_last_product_inventory_locations(limit) do
    from(pil in ProductInventoryLocation,
      order_by: [desc: pil.updated_at],
      limit: ^limit
    )
    |> Repo.all()
  end

  @doc """
  Gets a single product_inventory_location.

  Raises `Ecto.NoResultsError` if the Product inventory location does not exist.

  ## Examples

      iex> get_product_inventory_location!(123)
      %ProductInventoryLocation{}

      iex> get_product_inventory_location!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product_inventory_location!(id), do: Repo.get!(ProductInventoryLocation, id)

  @doc """
  Creates or updates a product_inventory_location and happends the passed current_inventory
  as history on the current time Stamp

  ## Examples

      iex> create_product_inventory_location(%{field: value})
      {:ok, %ProductInventoryLocation{}}

      iex> create_product_inventory_location(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product_inventory_location(attrs \\ %{}) do
    ts_data = %{ts: DateTime.utc_now(), inventory: attrs["current_inventory"]}

    attrs =
      attrs
      |> Map.put("history", [ts_data])
      |> Map.put("stats", %{avg: attrs["current_inventory"]})
      |> Map.put("amount_changed", attrs["current_inventory"])

    %ProductInventoryLocation{}
    |> ProductInventoryLocation.changeset(attrs)
    |> Repo.insert(
      on_conflict: update_inventory_query(ts_data),
      conflict_target: [:location_name, :product_code]
    )
  end

  def update_inventory_query(ts_data) do
    ProductInventoryLocation
    |> update([pil],
      set: [
        current_inventory: ^ts_data.inventory,
        history: fragment("array_append(p0.history, ?)", ^ts_data),
        amount_changed: fragment("p0.current_inventory - ?", ^ts_data.inventory),
        last_inventory: fragment("p0.current_inventory"),
        updated_at: ^DateTime.utc_now()
      ]
    )
  end

  @doc """
  Updates a product_inventory_location.

  ## Examples

      iex> update_product_inventory_location(product_inventory_location, %{field: new_value})
      {:ok, %ProductInventoryLocation{}}

      iex> update_product_inventory_location(product_inventory_location, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product_inventory_location(
        %ProductInventoryLocation{} = product_inventory_location,
        attrs
      ) do
    product_inventory_location
    |> ProductInventoryLocation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product_inventory_location.

  ## Examples

      iex> delete_product_inventory_location(product_inventory_location)
      {:ok, %ProductInventoryLocation{}}

      iex> delete_product_inventory_location(product_inventory_location)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product_inventory_location(%ProductInventoryLocation{} = product_inventory_location) do
    Repo.delete(product_inventory_location)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product_inventory_location changes.

  ## Examples

      iex> change_product_inventory_location(product_inventory_location)
      %Ecto.Changeset{data: %ProductInventoryLocation{}}

  """
  def change_product_inventory_location(
        %ProductInventoryLocation{} = product_inventory_location,
        attrs \\ %{}
      ) do
    ProductInventoryLocation.changeset(product_inventory_location, attrs)
  end

  def models_full_inventories() do
    from(pil in ProductInventoryLocation,
      select: {pil.product_code, sum(pil.current_inventory)},
      group_by: pil.product_code
    )
    |> Repo.all()
  end

  defp under_stock_query(under_stock_threashould) do
    from(pil in ProductInventoryLocation, where: pil.current_inventory < ^under_stock_threashould)
  end

  def inventory_transfer_posibilities() do
    from(pil in ProductInventoryLocation,
      left_join: pil2 in ^under_stock_query(10),
      on: pil2.product_code == pil.product_code,
      where: pil.current_inventory > 70,
      order_by: pil.product_code,
      select:
        {pil.product_code, pil2.location_name, pil2.current_inventory, pil.location_name,
         pil.current_inventory}
    )
    |> Repo.all()
  end

  def get_store_status(store) do
    from(pil in ProductInventoryLocation,
      where: pil.location_name == ^store
    )
    |> Repo.all()
  end

  def get_model_status(product_code) do
    from(pil in ProductInventoryLocation,
      where: pil.product_code == ^product_code,
      group_by: [pil.location_name, pil.product_code],
      select: {pil.product_code, fragment("json_agg(?)", pil.history), pil.location_name}
    )
    |> Repo.all()
  end
end
