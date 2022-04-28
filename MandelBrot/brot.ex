defmodule Brot do

  # Find the depth of a set starting from the complex number c, and test this set for a maximum of m iterations
  def mandelbrot(c, m) do
    z0 = Cmplx.new(0, 0)  # Starting number is always zero
    i = 0                 # Start with zero iterations
    test(i, z0, c, m)     # Test the depth of the set
  end

  # Base case, if the set is still stable after m iterations, return zero instead of continuing computing as it might take forever
  #def test(m, _, _, m), do: 0

  # Check if the current value is bigger than 2. If it is, return the current iteration, otherwise continue iterating
  def test(i, z, c, m) when i < m do
    case Cmplx.abs(z) > 2 do
      false ->
        next = Cmplx.add(Cmplx.sqr(z), c)
        test(i + 1, next, c, m)
      true -> i
    end
  end

  def test(_, _, _, _), do: 0

  '
  def azerPrviMrvi() do
    a = mandelbrot(Cmplx.new(0.8, 0), 30)
    b = mandelbrot(Cmplx.new(0.5, 0), 30)
    c = mandelbrot(Cmplx.new(0.3, 0), 30)
    d = mandelbrot(Cmplx.new(0.27, 0), 30)
    e = mandelbrot(Cmplx.new(0.26, 0), 30)
    f = mandelbrot(Cmplx.new(0.255, 0), 30)
    [a, b, c, d, e, f]
  end
  '

end
