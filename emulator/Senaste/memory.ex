defmodule Memory do


  '''
  def new(segments) do
    f = fn({start, data}, layout) -> # this is a function that takes as arguments a tuple
      last = start +  length(data) -1
      Enum.zip(start..last, data) ++ layout # returns a list of tuples, where each element in data is associated with an index, start..last creates a range
    end
    layout = List.foldr(segments, [], f)
    {:mem, Map.new(layout)}
  end
  '''



end
