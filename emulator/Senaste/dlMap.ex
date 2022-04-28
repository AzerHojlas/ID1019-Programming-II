defmodule Mapm do
    ## in the report
    def new() do
        {:mem, %{}}
    end

    def get(map, key) do
        map[key]
    end

    def put(map, key, value) do
        
        condition = value

        cond do
            get(map, key) == nil -> Map.put_new(map, key, value)
            condition != get(map, key) -> %{map | key => value}
        end
    end

    def testMap() do
      map = %{a: 1, b: 2}
      put(map, :c, 5)
    end
end
