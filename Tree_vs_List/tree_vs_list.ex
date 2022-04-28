defmodule TreeVsList do

  def bench() do bench(100) end

  def bench(l) do

    ls = [16,32,64,128,256,512,1024,2*1024,4*1024,8*1024]

    time = fn (i, f) ->
      seq = Enum.map(1..i, fn(_) -> :rand.uniform(100000) end)
      elem(:timer.tc(fn () -> loop(l, fn -> f.(seq) end) end),0)
    end

    bench = fn (i) ->

      list = fn (seq) ->
        List.foldr(seq, list_new(), fn (e, acc) -> list_insert(e, acc) end)
      end

      tree = fn (seq) ->
        List.foldr(seq, tree_new(), fn (e, acc) -> tree_insert(e, acc) end)
      end

      tree_BST = fn (seq) ->
        List.foldr(seq, tree_new(), fn (e, acc) -> tree_insert_BST(e, acc) end)
      end

      dummy = fn (seq) ->
        List.foldr(seq, tree_new(), fn (e, acc) -> tree_insert_BST(e, acc) end)
      end


      tl = time.(i, list)
      tt = time.(i, tree)
      tBST = time.(i, tree_BST)

      IO.write("  #{tl}\t\t\t#{tt}\t\t\t#{tBST}\n")
    end

    IO.write("# benchmark of list, balanced tree and BST (loop: #{l}) \n")
    Enum.map(ls, bench)

    :ok
  end

  def loop(0,_) do :ok end
  def loop(n, f) do
    f.()
    loop(n-1, f)
  end

  def list_new() do [] end #Create an empty list

  def list_insert(e, []) do [e] end #If list is empty, insert
  def list_insert(e, [h|t]) when e <= h do [e,h|t] end
  def list_insert(e, [h|t]) do [h|list_insert(e, t)] end

  def tree_new() do :nil end

  # Balanced Search Tree
  def tree_insert(e, :nil) do {:leaf, e} end

  def tree_insert(e, {:leaf, head} = right) when e < head do {:node, e, :nil, right} end
  def tree_insert(e, {:leaf, _} = left) do {:node, e, left, :nil} end

  def tree_insert(e, {:node, head, left, right}) when e < head do {:node, head, tree_insert(e, left), right} end
  def tree_insert(e, {:node, head, left, right}) do {:node, head, left, tree_insert(e, right)} end


  # Binary Search Tree
  def tree_insert_BST(e, :nil) do {:leaf, e} end

  def tree_insert_BST(e, {:leaf, head}) do
    case e <= head do
      true -> {:node, head, {:leaf, e}, :nil}
      false -> {:node, head, :nil, {:leaf, e}}
    end
  end

  def tree_insert_BST(e, {:node, head, left, right}) do
    case e <= head do
      true -> {:node, head, tree_insert_BST(e, left), right}
      false -> {:node, head, left, tree_insert_BST(e, right)}
    end
  end

end
