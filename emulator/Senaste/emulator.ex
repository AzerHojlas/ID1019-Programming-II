defmodule Emulator do

	# code is a tuple of instructions where every instruction is also a tuple
	# mem is a key-value data structure where a specific address is the key to a value
	# out is a storage unit of our output, in form of a list

	def run(prgm) do
		{code, data} = Program.load(prgm)
		out = Out.new()
		reg = Register.new() # returns a tuple of 32 zeros
		run(0, code, data, reg, out)
	end

  def run(pc, code, mem, reg, out) do

    next = Program.read_instrc(code, pc) # returns the tuple of a certain index

    case next do

      {:halt} ->
				out
	#Out.close(out) # we reverse the stored values so that the list is in timestamp order,

      {:out, rs} ->
				a = Register.read(reg, rs) # we read the value of register rs
				run(pc+1, code, mem, reg, Out.put(out,a)) # we run the code with the value stored in out, as the first value

      {:add, rd, rs, rt} ->
				a = Register.read(reg, rs)
				b = Register.read(reg, rt)
				reg = Register.write(reg, rd, a + b)  # we are not handling overflow
				run(pc+1, code, mem, reg, out)

      {:sub, rd, rs, rt} ->
				a = Register.read(reg, rs)
				b = Register.read(reg, rt)
				reg = Register.write(reg, rd, a - b) # this line updates the register
				run(pc+1, code, mem, reg, out) # discuss about + 1 or + 4 for the counter

      {:addi, rd, rs, imm} ->
				a = Register.read(reg, rs)
				reg = Register.write(reg, rd, a + imm)
				run(pc+1, code, mem, reg, out)

      {:beq, rs, rt, label} ->
				a = Register.read(reg, rs)
				b = Register.read(reg, rt)
				pc = if a == b do  Program.find_label(code, label) else pc end # if a == b do pc = pc + imm end
				#if a == b do pc = pc + imm end
				run(pc+1, code, mem, reg, out)

      {:bne, rs, rt, label} ->
				a = Register.read(reg, rs)
				b = Register.read(reg, rt)
				pc = if a != b do  Program.find_label(code, label) else pc end #if a != b do pc = pc + imm end
				run(pc+1, code, mem, reg, out)

      {:lw, rd, rs, imm} -> # we want to load a value from memory to the register rd
			a = Register.read(reg, rs) # read the address stored in register rs
			addr = a + imm # add the index to the address of rs
			val = Program.read(mem, addr) # read the value of the calculated address
			reg = Register.write(reg, rd, val) # we put the value in the register rd
			run(pc+1, code, mem, reg, out)

      {:sw, rs, rt, imm} ->
				vs = Register.read(reg, rs) # we retrieve the value stored in register rs
				vt = Register.read(reg, rt)	# we read the address stored in register rt
				addr = vt + imm # we add the index to the address
				mem = Program.write(mem, addr, vs) # we store the retrieved value at the calculated address
				run(pc+1, code, mem, reg, out)

	_ -> run(pc+1, code, mem, reg, out)
    end
  end
end
