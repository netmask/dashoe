defmodule DashoeWeb.OutStockLive do
  use DashoeWeb, :live_view
  alias Phoenix.PubSub

  @impl true
  def mount(_params, session, socket) do
    PubSub.subscribe(Dashoe.PubSub, "out_of_stock")

    {:ok,
     assign(socket,
       out_stock_items: []
     )}
  end

  def handle_info({:out_of_stock, out_stock}, socket) do
    {:noreply, assign(socket, out_stock_items: out_stock)}
  end
end
