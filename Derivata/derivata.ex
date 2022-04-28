defmodule Deriv do

  @type literal() :: {:num, number()} | {:var, atom()}
  @type expr() :: literal()
  | {:add, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:exp, expr(), literal()}


  def test1() do
    e = {:add,
        {:mul, {:num, 2}, {:var, :x}},
        {:num, 4}}
    d = deriv(e, :x)
    c = calc(d, :x, 5)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    IO.write("calculated: #{pprint(simplify(c))}\n")
    #pprint(d)
    :ok
  end

  def test2() do
    e = {:add,
        {:exp, {:var, :x}, {:num, 3}},
        {:num, 4}}
    d = deriv(e, :x)
    c = calc(d, :x, 4)
    new = {:ln, {:var, :t}}
    newDerived = deriv(new, :t)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    IO.write("calculated: #{pprint(simplify(c))}\n")
    #pprint(d)
    IO.write("expressionNew: #{pprint(new)}\n")
    IO.write("derivativeNew: #{pprint(newDerived)}\n")
    #IO.write("simplifiedNew: #{pprint(simplify(newDerived))}\n")
    :ok
  end

  def testLN() do
    e = {:ln, {:exp, {:var, :b}, {:num, 2}}}
    d = deriv(e, :b)
    IO.write("expression: \n")
    #IO.write("derivative: #{pprint(d)}\n")
    #IO.write("simplified: #{pprint(simplify(d))}\n")
    :ok
  end

  def deriv({:num, _}, _) do {:num, 0} end
  def deriv({:var, v}, v) do {:num, 1} end
  def deriv({:var, _}, _) do 0 end
  def deriv({:add, e1, e2}, v) do {:add, deriv(e1, v), deriv(e2, v)} end
  def deriv({:mul, e1, e2}, v) do
    {:add,
    {:mul, deriv(e1, v), e2},
    {:mul, e1, deriv(e2, v)}}
  end

  def deriv({:exp, e, {:num, n}}, v) do
    {:mul,
    {:mul, {:num, n}, {:exp, e, {:num, n - 1}}},
    deriv(e, v)}
  end

  # ln(x) -> 1/x
  def deriv({:ln, {:var, v}}, v) do {:div, {:num, 1}, {:var, v}} end
  def deriv({:ln, expression}, v) do {:div, deriv(expression, v), expression} end

  #def calc({:ln, e}, v, n) do {:ln, calc(e, v, n)} end

  #sin(x) -> cos(x)
  def deriv({:sin, {:var, x}}, x) do {:cos, {:var, x}} end

  def calc({:num, n}, _, _) do {:num, n} end
  def calc({:var, v}, v, n) do {:num, n} end
  def calc({:var, v}, _, _) do {:var, v} end
  def calc({:add, e1, e2}, v, n) do {:add, calc(e1, v, n), calc(e2, v, n)} end
  def calc({:mul, e1, e2}, v, n) do {:mul, calc(e1, v, n), calc(e2, v, n)} end
  def calc({:exp, e1, e2}, v, n) do {:exp, calc(e1, v, n), calc(e2, v, n)} end

  def simplify({:add, e1, e2}) do simplify_add(simplify(e1), simplify(e2)) end
  def simplify({:mul, e1, e2}) do simplify_mul(simplify(e1), simplify(e2)) end
  def simplify({:exp, e1, e2}) do simplify_exp(simplify(e1), simplify(e2)) end
  def simplify({:div, e1, e2}) do simplify_div(simplify(e1), simplify(e2)) end
  def simplify(e) do e end

  def simplify_div(e, {:num, 1}) do e end
  def simplify_div({:num, n1}, {:num, n2}) do {:num, n1/n2} end
  def simplify_div(e,e) do {:num, 1} end
  def simplify_div(e1,e2) do {:div, e1, e2} end

  def simplify_add({:num, 0}, e2) do e2 end
  def simplify_add(e1, {:num, 0}) do e1 end
  def simplify_add({:num, n1}, {:num, n2}) do {:num, n1 + n2} end
  def simplify_add(e1, e2) do {:add, e1, e2} end

  def simplify_mul({:num, 0}, _) do {:num, 0} end
  def simplify_mul(_, {:num, 0}) do {:num, 0} end
  def simplify_mul({:num, 1}, e2) do e2 end
  def simplify_mul(e1, {:num, 1}) do e1 end
  def simplify_mul({:num, n1}, {:num, n2}) do {:num, n1 * n2} end
  def simplify_mul(e1, e2) do {:mul, e1, e2} end

  def simplify_exp(_, {:num, 0}) do {:num, 1} end
  def simplify_exp(e1, {:num, 1}) do e1 end
  def simplify_exp({:num, n1}, {:num, n2}) do {:num, :math.pow(n1, n2)} end
  def simplify_exp(e1, e2) do {:exp, e1, e2} end

  def pprint({:num, n}) do "#{n}" end
  def pprint({:var, v}) do "#{v}" end

  def pprint({:add, e1, e2}) do "(#{pprint(e1)} + #{pprint(e2)})" end
  def pprint({:mul, e1, e2}) do "#{pprint(e1)}#{pprint(e2)}" end
  def pprint({:exp, e1, e2}) do "#{pprint(e1)}^(#{pprint(e2)})" end
  def pprint({:ln, e}) do "ln(#{e})" end
  def pprint({:div,e1, e2}) do "#{pprint(e1)}/#{pprint(e2)}" end


  def pprint({:sin, e}) do
    IO.write("sin(")
    pprint(e)
    IO.write(')')
  end


  #def pprint({:cos, e}) do "#{cos(e)}" end

end
