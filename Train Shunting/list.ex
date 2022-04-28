defmodule Train do

    '''
    A train is represented as a list of atoms [:a, :b, :c]
    A wagon is represented as an atom, :atom
    A state is represented as a tuple of three trains {[:a, :b], [:c, :d], [:e, :f]}
    '''

    # Takes the first n elements out of the list
    def take(_, 0) do [] end
    def take([h|t], n) do
        [h | take(t, n-1)]
    end

    def drop(xs, 0) do xs end
    def drop([_|t], n) do
        drop(t, n-1)
    end

    def append(xs, ys) do
        xs ++ ys
    end

    def member([], _) do false end
    def member([h|t], y) do
        cond do
            h == y -> true
            true -> member(t, y)
        end
    end

    def position([], _) do :knas end
    def position([h|t], y) do
        cond do
            h == y -> 1
            true -> 1 + position(t, y)
        end
    end
end
