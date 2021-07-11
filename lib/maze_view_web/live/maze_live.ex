defmodule MazeViewWeb.MazeLive do
  use MazeViewWeb, :live_view
  alias MazeView, as: MV
  use StructAccess

  @grid_width 50
  @grid_height 30
  @block_size 12
  @board_width @block_size * @grid_width + 10
  @board_height @block_size * @grid_height + 10
  @board_padding 5

  @impl true
  def mount(_params, _session, socket) do
    case connected?(socket) do
      false ->
        {:ok,
         assign(socket,
           grid_width: @grid_width,
           grid_height: @grid_height,
           board_width: @board_width,
           board_height: @board_height,
           block_size: @block_size,
           board_padding: @board_padding
         )}

      true ->
        {:ok, grid} = MV.new(@grid_width, @grid_height)

        {:ok,
         assign(socket,
           grid: grid,
           grid_width: @grid_width,
           grid_height: @grid_height,
           board_width: @board_width,
           board_height: @board_height,
           block_size: @block_size,
           board_padding: @board_padding
         )}
    end
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div>
      <%= case Map.has_key?(assigns, :grid) do %>
        <%= true -> %>
          <div><span>Algorithm: </span><span><%= @grid.meta.generated.algorithm %></span></div>
          <div><span>Generated: </span><span><%= @grid.meta.generated.timestamp %></span></div>
        <% _ -> %>
          <span></span>
        <% end %>
    </div>

    <div>
      <svg version="1.1" baseProfile="full" width="<%= @board_width %>" height="<%= @board_height %>" xmlns="http://www.w3.org/2000/svg">
        <rect width="100%" height="100%" fill="white"/>
        <%= case Map.has_key?(assigns, :grid) do %>
          <%= true -> %>
            <%= for x <- 0..@grid_width - 1, y <- 0..@grid_height do %>
              <%= case get_in(@grid, [:borders, :h, {x, y}]) do %>
                <% :wall -> %>
                  <line 
                  x1="<%= @board_padding + x * @block_size %>" 
                  y1="<%= @board_padding + y * @block_size %>" 
                  x2="<%= @board_padding + (x * @block_size) + @block_size %>" 
                  y2="<%= @board_padding + y * @block_size %>" 
                  stroke="black" />
                <% _ -> %>
              <% end %>
            <% end %>
            <%= for x <- 0..@grid_width, y <- 0..@grid_height - 1 do %>
              <%= case get_in(@grid, [:borders, :v, {x, y}]) do %>
                <% :wall -> %>
                  <line 
                  x1="<%= @board_padding + x * @block_size %>" 
                  y1="<%= @board_padding + y * @block_size %>" 
                  x2="<%= @board_padding + x * @block_size %>" 
                  y2="<%= @board_padding + (y * @block_size) + @block_size %>" 
                  stroke="black" />
                <% _ -> %>
              <% end %>
            <% end %>
          <% _ -> %>
            <text x="50", y="50">Loading ...</text>
        <% end %>
      </svg>
    </div>
    """
  end
end
