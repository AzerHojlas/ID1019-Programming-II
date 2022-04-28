defmodule Mandel do


  # Create a picture with various depths
  # Width is width of picture
  # Height is height of picture
  # k is distance between two points
  def mandelbrot(width, height, x, y, k, depth) do
    trans = fn(w, h) ->
      Cmplx.new(x + k * (w - 1), y - k * (h - 1))
    end
    rows(width, height, trans, depth, [])
  end

  def rows(w, h, trans, depth, rows) do
    case h == 0 do
      true -> rows
      false ->
        row = row(w, h, trans, depth, [])
        rows(w, h - 1, trans, depth, [row | rows])
    end
  end

  def row(w, h, trans, depth, row) do
    case w == 0 do
      true -> row
      false ->
        c = trans.(w, h)
        res = Brot.mandelbrot(c, depth)
        color = Color.convert(res, depth)
        row(w - 1, h, trans, depth, [color | row])
    end
  end

end
