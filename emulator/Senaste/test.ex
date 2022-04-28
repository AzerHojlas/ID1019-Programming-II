defmodule Test do

  def test() do
    mem = []
    {code, mem} = Program.load_pro({:prgm, demo(), mem}) # takes in a list as an argument and returns a tuple, code will specifically be a tuple of tuples
    prgm = {:prgm, code, mem}
    Emulator.run(prgm)
  end

  def demo() do


    [{:addi, 1, 0, 10},    # $1 <- 10
    {:addi, 2, 0, 5},     # $2 <- 5
    {:add, 3, 1, 2},      # $3 <- $1 + $2
    {:sw, 3, 0, 7},       # mem[0 + 7] <- $3
    {:lw, 4, 0, 7},       # $4 <- mem[0+7]
    {:addi, 5, 0, 1},     # $5 <- 1
    {:label, :loop},
    {:sub, 4, 4, 5},      # $4 <- $4 - $5
    {:out, 4},            # out $4
    {:bne, 4, 0, :loop},  # branch if not equal
    {:halt}]




  end
end

     #$0 = 0
     #$1 = 10
     #$2 = 5
     #$3 = 15
     #$4 = 15 14 13 12 11 10 ...
     #$5 = 1
     #$6 = 0
     #$7 = 0
     #$8 = 0
     #$9 = 0
     #$10 = 0
     # mem = {{addr7, 15}}
     # out = [... 12 13 14]


    '''


     [{:addi, 1, 0, 5}, # $1 <- 5
     {:lw, 2, 0, :arg}, # $2 <- data[:arg]
     {:add, 4, 2, 1}, # $4 <- $2 + $1
     {:addi, 5, 0, 1}, # $5 <- 1
     {:label, :loop},
     {:sub, 4, 4, 5}, # $4 <- $4 - $5
     {:out, 4},            # out $4
    {:bne, 4, 0, :loop},  # branch if not equal
    {:halt}]


'''
