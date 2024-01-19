defmodule Identicon do

  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    hex
    |> Enum.chunk_every(3)
  end

  def mirror_rowHelper(row) do
    [first, second | _tail] = row  # [145, 46, 200]

    row ++ [second, first]   # [145,46,200,46,145]
  end

  # #pattern matching a struct
  # def pick_color(image) do
  #   %Identicon.Image{hex: hex_list} = image
  #   [r, g, b | _tail] = hex_list
  #   %Identicon.Image{image | color: {r, g, b}}
  # end

  # # #better and shorter
  def pick_color( %Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}  # add color to the struct
  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end
end
