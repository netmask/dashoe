defmodule DashoeWeb.ProductPlot do
  alias Contex.{LinePlot, BarChart, Plot, Dataset}

  def map_data(data) do
    data
    |> Enum.map(fn pil ->
      serie = Enum.map(pil.history, & &1["inventory"])
      [pil.product_code | serie]
    end)
    |> Dataset.new()
  end

  def plot(dataset, type \\ BarChart) do
    options = [
      colour_palette: ["ff9838", "fdae53", "fbc26f", "fad48e", "fbe5af", "fff5d1"]
    ]

    plot =
      Plot.new(dataset, type, 600, 200, options)
      |> Plot.plot_options(%{})
  end

  def line_plot(data) do
    options = [
      stroke_width: 1,
      smoothed: false
    ]

    margins = %{left: 40, right: 15, top: 10, bottom: 20}

    data
    |> Dataset.new()
    |> Plot.new(LinePlot, 500, 150, options)
    |> Map.put(:margins, margins)
    |> Plot.to_svg()
  end

  def product_graph(%{history: history, product_code: code}) do
    history
    |> product_dataset()
  end

  def product_dataset(history) do
    history
    |> Enum.map(fn %{"ts" => ts, "inventory" => inventory} ->
      {:ok, time} = NaiveDateTime.from_iso8601(ts)

      {time, inventory}
    end)
  end
end
