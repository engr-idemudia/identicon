defmodule Identicon do

  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({_code, index}) ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end
    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image)  do
    grid = Enum.filter grid, fn({code, _index}) ->  # Enum.filter(grid, fn(square) -> end)
      rem(code, 2) == 0 #remender operator or
    end

    %Identicon.Image{image | grid: grid}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid = hex
      |> Enum.chunk(3)
      |> Enum.map(&mirror_rowHelper/1)
      |> List.flatten
      |> Enum.with_index

      %Identicon.Image{image | grid: grid}
  end

  def mirror_rowHelper(row) do
    [first, second | _tail ] = row  # [145, 46, 200]

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
