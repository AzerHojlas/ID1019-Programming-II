defmodule Shunt do

  def few([head|tail1], [head|tail2]) do few(tail1, tail2) end
  def few(xs, ys) do
      case ys do
          [] -> []
          [y|t] ->
              {hs, ts} = split(xs, y)
              step = Moves.single({:one, length(ts)+1}, {xs, [], []})
              step = Moves.single({:two, length(hs)}, step)
              step = Moves.single({:one, -(length(ts)+1)}, step)
              {[_|t2], [], []} = Moves.single({:two, -(length(hs))}, step)
              [{:one, length(ts)+1}, {:two, length(hs)}, {:one, -(length(ts)+1)}, {:two, -(length(hs))}| few(t2, t)]
      end
  end

  def split(list, atom) do
      case Train.member(list, atom) do
          false -> :WrongListStupid
          true -> {Train.take(list, Train.position(list, atom)-1), Train.drop(list, Train.position(list, atom))}
      end
  end

  def find(_, []) do [] end
  def find(xs, [y | t]) do
    {hs, ts} = split(xs, y)
    headLength = length(ts)+1
    rest = length(hs)
    step2 = Moves.single({:one, headLength}, {xs, [], []})
    step3 = Moves.single({:two, rest}, step2)
    step4 = Moves.single({:one, -headLength}, step3)
    {[_|t2], [], []} = Moves.single({:two, -rest}, step4)
    [{:one, headLength}, {:two, rest}, {:one, -headLength}, {:two, -rest} | find(t2, t)]
  end

  def rules([]) do [] end
  def rules([{_, 0} | tail]) do rules(tail) end
  def rules([{track, n1}, {track, n2}| tail]) do rules([{track, n1 + n2} | tail]) end
  def rules([head | tail]) do [head | rules(tail)] end

  def compress(ms) do
    ns = rules(ms)
    if ns == ms do
      ms
    else compress(ns)
    end
  end

end
