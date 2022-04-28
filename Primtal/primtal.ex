defmodule First do

  def instantiate(n) do
    [head|tail] = Enum.to_list(2..n)
    [head|sieve(head, tail)]
  end


  ## remove specific value from the list by using Enum.filter,
  ## if the value has a reminder with the division with 2 then it is a prime value so we keep it in the tail lst.
  def sieve(_x, []) do [] end
  def sieve(x, [h|t]) do
      [h|sieve(h, Enum.filter(t, fn p -> rem(p, x) != 0 end))]
  end

end

defmodule Second do

  def instantiate(n) do
    list = Enum.to_list(2..n)
    sieve(list, [])
  end


  ## pass the created list to second()/2
  ## in second()/2 we will get a return list with all the primes in it
  def sieve(list, primes) do
    case list do
        ## when the number of list is empty return the list primes
        [] -> primes
        [head|tail] ->
            ## we check if the header of the list of number is prime
            isPrime = checkPrime(list, primes)
            ## if the value is a prime, insert the head of the list of numbers in the primes list
            primes = insert(isPrime, head, primes)
            sieve(tail, primes)
    end
end

## we check if a number is prime in the list of number by comparing the reminder of the division with other numbers in primes list
def checkIfPrime(_, []) do true end
def checkIfPrime(list = [head|tail], [h2|t2]) do
    cond do
        rem(head, h2) == 0 -> false
        true -> checkIfPrime(list, t2)
    end
end

## we insert a value x in the list primes when the value of bool = true
  def insert(bool, x, primes) do
      case bool do
        ## we add the value x to the right of the list primes
          true -> primes ++ [x]
          false -> primes
      end
  end
end

defmodule Third do
## create a list of numbers starts from 2 to n
  def instantiate(n) do
      list = Enum.to_list(2..n)
      sieve(list, [])
  end

  def sieve(list, primes) do
    case list do
        ## when the number of list is empty return the list primes in reverse order
        [] -> reverse(primes)
        [h|t] ->
            ## we check if the header of the list of number is prime
            bool = checkPrime(list, primes)
            ##  if the value is a prime, insert the head of the list of numbers in the primes list
            primes = insertPrime(bool, h, primes)
            sieve(t, primes)
    end
end

## we check if a number is prime in the list of number by comparing the reminder of the division with other numbers in primes list
def checkPrime(_, []) do true end
def checkPrime([h|t], [h2|t2]) do
    cond do
        rem(h, h2) == 0 -> false
        true -> checkPrime([h|t], t2)
    end
end

## we insert a value x in the list primes when the value of bool = true
  def insertPrime(bool, x, primes) do
      case bool do
            ## we add the value x to the left of the list primes
          true -> [x | primes]
          false -> primes
      end
  end

  def reverse(list) do reverse(list, []) end
  def reverse([], reversed) do reversed end
  def reverse([h | t], r) do reverse(t, [h | r]) end

end

defmodule Dummy do
  def  instantiate(n) do
    n+1
  end
end


defmodule Bench2 do

  def bench(n) do
    ## :timer.tc return a tuple frist element is the time while the second is the list of primes
    ## IO.inspect prints out the result on the console
      IO.inspect(:timer.tc(fn -> First.instantiate(n) end))
      IO.inspect(:timer.tc(fn -> Second.instantiate(n) end))
      IO.inspect(:timer.tc(fn -> Third.instantiate(n) end))
      :ok
  end

end


defmodule Bench do
  def bench() do

    ls = [16, 32, 64, 128, 256, 512, 1024, 2*1024, 4*1024]
    time = fn (f) ->
        elem(:timer.tc(fn () -> loop(50, fn -> f.() end) end),0)
    end

    bench = fn (i) ->
        first = fn () -> First.instantiate(i) end
        second = fn () -> Second.instantiate(i) end
        third = fn () -> Third.instantiate(i) end

        t1 = time.(first)
        t2 = time.(second)
        t3 = time.(third)

        t11 = div(t1,50)
        t22 = div(t2,50)
        t33 = div(t3,50)

          # here we print out the measured times
          IO.write("  #{t1}\t\t\t#{t2}\t\t\t#{t3}\n")
    end

    ## IO.write("# benchmark of lists and tree (loop: #{l}) \n")

    Enum.map(ls, bench)
    :ok
  end

  def loop(0,f) do f.() end
  def loop(n, f) do
    f.()
    loop(n-1, f)
  end


end
