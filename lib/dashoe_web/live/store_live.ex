defmodule DashoeWeb.StoreLive do
  use DashoeWeb, :live_view
  alias Phoenix.PubSub
  alias Dashoe.Store
  alias Contex.Plot

  import DashoeWeb.ProductPlot

  @impl true
  def mount(%{"id" => store}, session, socket) do
    PubSub.subscribe(Dashoe.PubSub, "store:#{store}")

    store_status = Store.get_store_status(store)

    {:ok,
     assign(socket,
       store_data: store_status,
       store_name: store,
       plot: map_data(store_status) |> plot()
     )}
  end

  def handle_info(store_data, socket) do
    {:noreply,
     socket
     |> assign(:store_data, store_data)
     |> assign(
       :plot,
       map_data(store_data) |> plot()
     )}
  end
end
