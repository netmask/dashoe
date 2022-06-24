defmodule Dashoe.InventorySocketClient do
  use WebSockex

  alias Dashoe.Store
  alias Phoenix.PubSub

  require Logger

  def start_link(_) do
    WebSockex.start_link("ws://localhost:8080", __MODULE__,
      async: true,
      handle_initial_conn_failure: true
    )
  end

  def terminate(reason, _state) do
    Logger.error(reason)
  end

  def handle_frame({type, msg}, state) do
    case Jason.decode(msg) do
      {:ok, %{"store" => store, "model" => model, "inventory" => inventory}} ->
        create_adn_broadcast(inventory, store, model)

      _ ->
        Logger.warn("Invalid data")
    end

    {:ok, state}
  end

  defp create_adn_broadcast(inventory, store, model) do
    {:ok, inventory_record} =
      Store.create_product_inventory_location(%{
        "current_inventory" => inventory,
        "location_name" => store,
        "product_code" => model
      })

    inventory_strancations_sample = Store.list_last_product_inventory_locations(10)

    PubSub.broadcast!(Dashoe.PubSub, "inventory_events", inventory_strancations_sample)
    PubSub.broadcast!(Dashoe.PubSub, "store:#{store}", store_event(store))
    PubSub.broadcast!(Dashoe.PubSub, "model:#{model}", model_event(model))
  end

  def store_event(store) do
    Store.get_store_status(store)
  end

  def model_event(model) do
    Store.get_model_status(model)
  end
end
