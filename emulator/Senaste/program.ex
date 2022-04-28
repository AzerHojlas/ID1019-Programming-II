defmodule Program do


  def load_pro({:prgm, code, _}) do
    {{:code, List.to_tuple(code)}, Mapm.new()}
  end

  ## in the report
  def new() do # returns a tuple on the following format {:mem, mem}, where mem is a list of tuples
  Mapm.new()
end

  def load({:prgm, code, data}) do
    {code, data}
  end

  ## in the report
  def assemble(code) do
    {:code, List.to_tuple(code)}
  end

  def read_instrc({:code, code}, pc) do
    elem(code, pc)
  end

  def find_label({:code, code}, label) do find_label(code, 0, label) end
  def find_label(code, i, label) do
    case elem(code, i) do
      {:label, ^label} -> i
      _ -> find_label(code, i + 1, label)
    end
  end

  def read({:mem, mem}, i) do
    case Mapm.get(mem, i) do
      nil -> 0
      val -> val
    end
  end

  def write({:mem, mem}, i, v) do
    {:mem, Map.put(mem, i, v)}
  end


end
