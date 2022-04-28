defmodule Huffman do

  def testAzer() do encode_table(tree(sample())) end
  def testEncode() do encode(sample(), testAzer()) end
  def testDecode() do decode(testEncode(),encode_table(tree(sample()))) end

  def sample() do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
  end

  def text()  do
    'this is something that we should encode'
  end


  def test do
    sample = sample()
    tree = tree(sample)
    table = encode_table(tree)
    text = text()
    seq = encode(text, table)
    decode(seq, table)
  end

  def tree(sample) do
    freq = freq(sample)
    huffman(freq)
  end

  # Sample is a list of characters
  # Freq finds the frequency of all characters
  def freq(sample) do freq(sample, []) end

  # If all characters have been checked, return the frequency list of all characters
  def freq([], freq) do freq end

  # Take each character and count how many times it appears in a text
  def freq([char | rest], freq) do
    freq(rest, update(char, freq))
  end

  # If the character doesn't appear in the list, then its the first instance of it and frequency is set to 1
  def update(char, []) do [{char, 1}] end

  # If the character is spotted in the frequency list, increment the frequency
  def update(char, [{char, n} | freq]) do
    [{char, n + 1} | freq]
  end

  # If character doesn't match the current element, iterate recursively
  def update(char, [elem | freq]) do
    [elem | update(char, freq)]
  end

  # Build the actual Huffman tree inserting a character at
  # time based on the frequency.
  def huffman(freq) do
    sorted = Enum.sort(freq, fn({_, x}, {_, y}) -> x < y end)
    huffman_tree(sorted)
  end

  # base case. If only one element remains in tree, remove the brackets and display the tree without its frequency
  # That is,
  def huffman_tree([{tree, _}]), do: tree

  def huffman_tree([{a, af}, {b, bf} | rest]) do
    huffman_tree(insert({{a, b}, af + bf}, rest))
  end

  # base case, the tuple is in the correct place as there is nothing more to compare it to
  def insert({a, af}, []), do: [{a, af}]

  # If the first tuple is less frequent than the second, its in the right place
  def insert({a, af}, [{b, bf} | rest]) when af < bf do
    [{a, af}, {b, bf} | rest]
  end

  # If its not more frequent, it is put further back in the list
  def insert({a, af}, [{b, bf} | rest]) do
    [{b, bf} | insert({a, af}, rest)]
  end

  # Build the encoding table.
  def encode_table(tree) do
    Enum.sort(codes(tree, []), fn({_,x},{_,y}) -> length(x) < length(y) end)
  end

  def codes({a, b}, sofar) do
    as = codes(a, append(sofar, 0))
    bs = codes(b, append(sofar, 1))
    as ++ bs
  end

  def codes(a, code) do
    [{a, code}]
  end

  def append([], x) do [x] end
  def append([h | t], x) do [h | append(t, x)] end

  # Translate a text to code
  def encode([], _) do [] end
  def encode([char | tail], table) do
    find(table, char) ++ encode(tail, table)
  end

  # Find the code sequence of a character
  def find([], _) do :noSuchCharEncoding end
  def find([{match, seq} | tail], char) do
    case char == match do
      true -> seq
      false -> find(tail, char)
    end
  end

  # Find the code sequence of a character
  def findChar([], _) do :noSuchCharEncoding end
  def findChar([{char, seq} | tail], code) do
    case code == seq do
      true -> char
      false -> findChar(tail, code)
    end
  end

  # Base case, if there is no sequence left to decode, return nothing
  def decode([], _), do: []
  def decode(seq, table) do
    {char, rest} = decode_char(seq, 1, table) # Return the character of each sequence
    [char | decode(rest, table)]              # Add character to a string
  end


  def decode_char(seq, n, table) do
    {code, rest} = Enum.split(seq, n)
    case findChar(table, code) do
      :noSuchCharEncoding ->
        decode_char(seq, n + 1, table)
        
      char ->
        {char, rest}
    end
  end

  def bench(file, n) do
    {text, b} = read(file, n)
    c = length(text)
    {tree, t2} = time(fn -> tree(text) end)
    {encode, t3} = time(fn -> encode_table(tree) end)
    s = length(encode)
    #{decode, _} = time(fn -> decode_table(tree) end)
    {encoded, t5} = time(fn -> encode(text, encode) end)
    e = div(length(encoded), 8)
    r = Float.round(e / b, 3)
    {_, t6} = time(fn -> decode(encoded, encode) end)

    IO.puts("text of #{c} characters")
    IO.puts("tree built in #{t2} ms")
    IO.puts("table of size #{s} in #{t3} ms")
    IO.puts("encoded in #{t5} ms")
    IO.puts("decoded in #{t6} ms")
    IO.puts("source #{b} bytes, encoded #{e} bytes, compression #{r}")
  end

  # Measure the execution time of a function.
  def time(func) do
    initial = Time.utc_now()
    result = func.()
    final = Time.utc_now()
    {result, Time.diff(final, initial, :microsecond) / 1000}
  end


 # Get a suitable chunk of text to encode.
  def read(file, n) do
   {:ok, fd} = File.open(file, [:read, :utf8])
    binary = IO.read(fd, n)
    File.close(fd)

    length = byte_size(binary)
    case :unicode.characters_to_list(binary, :utf8) do
      {:incomplete, chars, rest} ->
        {chars, length - byte_size(rest)}
      chars ->
        {chars, length}
    end
  end

  '
  def read(file) do
    {:ok, file} = File.open(file, [:read, :utf8])
    binary = IO.read(file, :all)
    File.close(file)
    case :unicode.characters_to_list(binary, :utf8) do
      {:incomplete, list, _} ->
        list
      list ->
        list
    end
  end
  '


end
