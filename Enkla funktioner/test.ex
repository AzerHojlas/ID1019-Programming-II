defmodule Test do

  def double(n) do n*2 end

  def celsius(f) do ((f-32)/1.8) end

  def rectangle(a, b) do a*b end

  def square(a) do rectangle(a,a) end

  def circle(r) do square(r)*:math.pi end

  def product(0, _) do 0 end
  def product(_,0) do 0 end
  def product(m, n) do product(m-1, n) + n end


  def exp(x, n) do
    case n do
    0 -> 1
    1 -> x
    _ -> product(x, exp(x, n-1))
    end
  end

  #def expFaster(x, 1) do x end #this base case isnt needed, is performed in the "1"-case
  def expFaster(_, 0) do 1 end
  def expFaster(x, n) do
    case rem(n, 2) do
      0 ->
        computation = expFaster(x, div(n, 2))
        computation * computation
        #expFaster(x, div(n, 2)) * expFaster(x, div(n, 2)) we dont need to make the same computation twice, takes too much time
      1 -> expFaster(x, n-1) * x
    end
  end

  def nth(index, list) do nth(index, list, 0) end
  def nth(index, [head | tail], increment) do
    cond do
      index != increment -> nth(index, tail, increment + 1)
      true -> head
    end
  end

  def nth_improved(n, l) do nth_improved(n, l, 0) end
  def nth_improved(_,[],_) do IO.puts("an error occured") end
  def nth_improved(n, [h | _], n) do h end
  def nth_improved(n, [_ | t], x) do nth_improved(n, t, x + 1) end



  def len(l) do len(l, 0) end

  def len(l, n) do
    case l do
      [] -> n
      [_| t ] -> len(t, n + 1)
    end
  end

  def len_improved(l) do len_improved(l, 0) end
  def len_improved([], n) do n end
  def len_improved([_ | t], n) do len_improved(t, n + 1) end

  def sum(l) do sum(l, 0) end
  def sum([h | []], total) do h + total end
  def sum([h | t], total) do sum(t, total + h) end

  def duplicate(l) do l ++ l end

  def add(x, list) do add(x, list, list) end
  def add(x, l, full) do
    case l do
      [] -> [x | full]
      [^x| _] -> full
      [_| tail ]  -> add(x, tail, full)
    end
  end

  def add_improved(x, l) do add_improved(x, l, l) end

  def add_improved(x, [], full) do [x | full] end
  def add_improved(x, [x | _], full) do full end
  def add_improved(x, [_ | t], full) do add_improved(x, t, full) end

  def add2(x, []) do [x] end
  def add2(x, list = [x | _]) do list end
  def add2(x, [head | tail]) do [h | add2(x, tail)]


  def remove_improved(x, l) do remove_improved(x, l, l) end

  def remove_improved(x, [x | _], modified) do remove_improved(x, modified -- [x], modified -- [x]) end
  def remove_improved(x, [_ | t], modified) do remove_improved(x, t, modified) end
  def remove_improved(_, [], modified) do modified end

  def unique(l) do unique(l, []) end

  def unique([], list) do list end
  def unique([head | tail], list) do unique(tail, add_improved(head,list)) end


  def reverse(list) do reverse(list, []) end
  def reverse([], reversed) do reversed end
  def reverse([h | t], r) do reverse(t, [h | r]) end


  def pack([]) do [] end
  def pack([h|t]) do
    packed = pack(t)
    insert(h,packed)
  end

  #Base case for insert
  def insert(h,[]) do [[h]] end
  def insert(h,[[h|t]|rest]) do [[h, h|t] | rest] end
  def insert(h,[first|rest]) do [first|insert(h,rest)] end

end
