defmodule MazeView do
  @moduledoc """
  MazeView keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias MazeGenerator, as: MG

  def new(width, height), do: MG.new(width, height)

end
