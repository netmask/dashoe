defmodule DashoeWeb.ProductLive do
  use DashoeWeb, :live_view
  alias Phoenix.PubSub
  alias Dashoe.Store

  import DashoeWeb.ProductPlot

  @impl true
  def mount(%{"id" => product}, session, socket) do
    PubSub.subscribe(Dashoe.PubSub, "model:#{product}")

    product_status = Store.get_model_status(product)

    {:ok,
     assign(socket,
       product_code: product,
       product_status: product_status
     )}
  end

  def handle_info(%{product_code: pc}, socket) do
    product_status = Store.get_model_status(pc)

    {:noreply,
     socket
     |> assign(:product_status, product_status)}
  end
end
