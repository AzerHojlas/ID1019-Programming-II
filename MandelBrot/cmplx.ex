defmodule Cmplx do

  # Create a new complex number as a tuple, where x is the real part and y the imaginary
  def new(x, y), do: {:cmplx, x, y}

  # Add two complex numbers by adding their real and imaginary part
  def add({:cmplx, x1, y1}, {:cmplx, x2, y2}) do
    {:cmplx, x1 + x2, y1 + y2}
  end

  # square a complex number
  def sqr({:cmplx, x, y}) do
    {:cmplx, x * x - y * y, 2 * x * y}
  end

  # Take the absolute value of a complex number
  def abs({:cmplx, x, y}) do
    :math.sqrt(x * x + y * y)
  end

end
