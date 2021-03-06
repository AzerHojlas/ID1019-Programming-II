defmodule Last do

  def morse() do
    {:node, :na,
    {:node, 116,
    {:node, 109,
    {:node, 111,
    {:node, :na, {:node, 48, nil, nil}, {:node, 57, nil, nil}},
    {:node, :na, nil, {:node, 56, nil, {:node, 58, nil, nil}}}},
    {:node, 103,
    {:node, 113, nil, nil},
    {:node, 122,
    {:node, :na, {:node, 44, nil, nil}, nil},
    {:node, 55, nil, nil}}}},
    {:node, 110,
    {:node, 107, {:node, 121, nil, nil}, {:node, 99, nil, nil}},
    {:node, 100,
    {:node, 120, nil, nil},
    {:node, 98, nil, {:node, 54, {:node, 45, nil, nil}, nil}}}}},
    {:node, 101,
    {:node, 97,
    {:node, 119,
    {:node, 106,
    {:node, 49, {:node, 47, nil, nil}, {:node, 61, nil, nil}},
    nil},
    {:node, 112,
    {:node, :na, {:node, 37, nil, nil}, {:node, 64, nil, nil}},
    nil}},
    {:node, 114,
    {:node, :na, nil, {:node, :na, {:node, 46, nil, nil}, nil}},
    {:node, 108, nil, nil}}},
    {:node, 105,
    {:node, 117,
    {:node, 32,
    {:node, 50, nil, nil},
    {:node, :na, nil, {:node, 63, nil, nil}}},
    {:node, 102, nil, nil}},
    {:node, 115,
    {:node, 118, {:node, 51, nil, nil}, nil},
    {:node, 104, {:node, 52, nil, nil}, {:node, 53, nil, nil}}}}}}
  end

  def decode([]), do: []
  def decode(text = [char | rest]) do
    map = Map.new(encode_table(), fn {key, val} -> {val, key} end)
    {translated, tail} = iterate(text, text, [])
    [Map.get(map, translated) | decode2(tail)]
  end

  def iterate([h | t], text, acc) when h != 32 do
    iterate(t, text, [h | acc])
  end

  def iterate(_, text, acc) do {acc, text -- [32 | acc]} end

  def encode(text), do: encode(text, encode_table(), [])
  def encode([], _, reversed), do: Enum.reverse(reversed)

  def encode([char|text], table, accumulator) when accumulator == [] do
    encode(text, table, Map.get(table,char))
  end

  def encode([char|text], table, accumulator) do
    encode(text, table, Map.get(table,char) ++ [32] ++ accumulator)
  end

  def encode_table() do
    traverse = traverse(morse(), [])
    Enum.reduce(traverse, %{}, fn({char, code}, acc) ->
      Map.put(acc,char,code) end)
  end

  defp traverse(:nil, _), do: []

  defp traverse({:node, :na, dash, dot}, tree) do
    traverse(dash, [?-|tree]) ++ traverse(dot, [?.|tree])
  end

  defp traverse({:node, char, dash, dot}, tree) do
    [{char,tree}] ++ traverse(dash, [?-|tree]) ++ traverse(dot, [?.|tree])
  end

  def secretmsg() do
    msg =
    '.- .-.. .-.. ..-- -.-- --- ..- .-. ..-- -... .- ... . ..-- .- .-. . ..-- -... . .-.. --- -. --. ..-- - --- ..-- ..- ... .... - - .--. ... ---... .----- .----- .-- .-- .-- .-.-.- -.-- --- ..- - ..- -... . .-.-.- -.-. --- -- .----- .-- .- - -.-. .... ..--.. ...- .----. -.. .--.-- ..... .---- .-- ....- .-- ----. .--.-- ..... --... --. .--.-- ..... ---.. -.-. .--.-- ..... .----'
    decode(msg)
  end

end
