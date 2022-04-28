defmodule Moves do


    def move([], state) do [state] end

    def move([head | tail], state) do [state | move(tail, single(head, state))] end


    def single({:one, n}, {main, one, two}) do
        cond do
            n < 0 ->  {Train.append(main, Train.take(one, n*-1)), Train.drop(one, n * -1), two}
            n > 0 ->  {Train.take(main, length(main)-n), Train.append(Train.drop(main, length(main)-n), one), two}
            true ->   {main, one, two}
        end
    end


    def single({:two, n}, {main, one, two}) do
        cond do
            n < 0 ->    {Train.append(main, Train.take(two, n*-1)), one, Train.drop(two, n*-1)}
            n > 0 ->    {Train.take(main, length(main)-n), one, Train.append(Train.drop(main, length(main)-n), two)}
            true ->     {main, one, two}
        end
    end

end
