defmodule Day1 do

  def compare(lst) do compare(lst, 0) end   # Constructor

  def compare([_ | []], acc) do acc end # Base case, once the list has been processed, return the accumulator
  def compare([current, next | tail], acc) do
    case current < next do
      true -> compare([next | tail], acc + 1)
      false -> compare([next | tail], acc)
    end
  end

  def second_compare(lst) do compare(sumsOfThree(lst)) end

  def sumsOfThree(lst) do sumsOfThree(lst, []) end
  def sumsOfThree([_, _| []], acc) do acc end
  def sumsOfThree([first, second, third | tail], acc) do sumsOfThree([second, third | tail], acc ++ [first + second + third]) end

  def test() do
    myInput = Lst.myinput()
    IO.write("My input first part: #{compare(myInput)}\n")
    IO.write("My input second part: #{second_compare(myInput)}\n")

    johansInput = Lst.input()
    IO.write("Johans input first part: #{compare(johansInput)}\n")
    IO.write("Johans input second part: #{second_compare(johansInput)}\n")
    :done
  end
end
