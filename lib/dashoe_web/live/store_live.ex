defmodule DashoeWeb.StoreLive do
  use DashoeWeb, :live_view
  alias Phoenix.PubSub
  alias Dashoe.Store
  alias Contex.{BarChart, Plot, Dataset}

  @impl true
  def mount(%{"id" => store}, session, socket) do
    PubSub.subscribe(Dashoe.PubSub, "store:#{store}")

    store_status = Store.get_store_status(store)

    {:ok,
     assign(socket,
       store_data: store_status,
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

  def map_data(data) do
    data
    |> Enum.map(fn pil ->
      serie = Enum.map(pil.history, & &1["inventory"])
      [pil.product_code | serie]
    end)
    |> Dataset.new()
  end

  def plot(dataset) do
    options = [
      colour_palette: ["ff9838", "fdae53", "fbc26f", "fad48e", "fbe5af", "fff5d1"]
    ]

    plot =
      Plot.new(dataset, BarChart, 300, 200, options)
      |> Plot.plot_options(%{})
  end
end
