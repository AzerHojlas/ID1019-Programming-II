defmodule Color do

  def convert(depth, max), do: green(depth,max)


  # Find the color of a depth
  def red(depth, max) do
    f = depth / max #
    a = f * 4
    x = Kernel.trunc(a)
    y = Kernel.trunc(255 * (a - x))
    case x do
        0 -> {:rgb, y, 0, 0}
        1 -> {:rgb, 255, y, 0}
        2 -> {:rgb, 255 - y, 255, 0}
        3 -> {:rgb, 0, 255, y}
        4 -> {:rgb, 0, 255 - y, 255}
    end
  end

  def green(depth, max) do
    f = depth / max #
    a = f * 4
    x = Kernel.trunc(a)
    y = Kernel.trunc(255 * (a - x))
    case x do
        0 -> {:rgb, 0, y, 0}
        1 -> {:rgb, 255, y, 0}
        2 -> {:rgb, 255, 255 - y, 0}
        3 -> {:rgb, 0, y, 255}
        4 -> {:rgb, 255, 255, 255}
    end
  end


  def blue(d, max) do
    f = d / max

    # a is [0 - 4.0]
    a = f * 4

    # x is [0,1,2,3,4]
    x = trunc(a)

    # y is [0 - 255]
    y = trunc(255 * (a - x))

    case x do
      0 ->
        # black -> blue
        {:rgb, 0, 0, y}

      1 ->
        # blue -> cyan
        {:rgb, 0, y, 255}

      2 ->
        # cyan -> green
        {:rgb, 0, 255, 255 - y}

      3 ->
        # green -> yellow
        {:rgb, y, 255, 0}

      4 ->
        # yellow-> red
        {:rgb, 255, 255 - y, 0}
    end
  end

end
