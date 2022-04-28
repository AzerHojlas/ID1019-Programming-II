defmodule Test do

  # Coordinates for image
  def demo() do small(-2.6, 1.2, 1.2) end

  #def demo() do small(-1, -0.5, 1.2) end


  # Define width, height and maximum depth iterations
  def small(x0, y0, xn) do
    #width = 960
    width = 40000
    #height = 540
    height = 6000
    depth = 64
    k = (xn - x0) / width
    #k = 0.002
    image = Mandel.mandelbrot(width, height, x0, y0, k, depth)
    PPM.write("small2.ppm", image)
  end

  '
  def small(x0, y0, xn) do
    width = 960
    height = 540
    depth = 64
    k = (xn - x0) / width
    image = Mandel.mandelbrot(width, height, x0, y0, k, depth)
    PPM.write("small.ppm", image)
  end
  '

end
