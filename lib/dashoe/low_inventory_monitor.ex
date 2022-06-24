defmodule Dashoe.LowInventoryMonitor do
  use GenServer

  alias Phoenix.PubSub
  alias Dashoe.Store

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    PubSub.subscribe(Dashoe.PubSub, "inventory_events")

    {:ok, nil}
  end

  def handle_info(event, state) do
    out_of_stock = Store.out_of_stock_products()

    PubSub.broadcast!(Dashoe.PubSub, "out_of_stock", {:out_of_stock, out_of_stock})

    {:noreply, state}
  end
end
