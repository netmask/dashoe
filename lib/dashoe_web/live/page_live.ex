defmodule DashoeWeb.PageLive do
  use DashoeWeb, :live_view
  alias Phoenix.PubSub
  alias Dashoe.Store.ProductInventoryLocation
  alias Dashoe.Store

  @impl true
  def mount(_params, session, socket) do
    PubSub.subscribe(Dashoe.PubSub, "inventory_events")

    {:ok,
     assign(socket,
       latest_transactions: [],
       total_inventories: [],
       inventory_transfers: [],
       out_of_stock: []
     )}
  end

  def handle_info(transaction_samples, socket) do
    total_inventories = Store.models_full_inventories()

    inventory_transfers = Store.inventory_transfer_posibilities()

    {:noreply,
     socket
     |> assign(:latest_transactions, transaction_samples)
     |> assign(:total_inventories, total_inventories)
     |> assign(:inventory_transfers, inventory_transfers)}
  end
end
