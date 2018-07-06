#!/bin/env elixir

defmodule Wc do
  def main(filenames) do
    Enum.map(filenames, &count_file/1)
    |> add_total()
    |> Enum.each(&print_result/1)
  end

  defp count_file(filename) do
    stream = IO.stream(File.open!(filename), :line)
    Enum.reduce(stream, {0, 0, 0, filename},
      fn(line, {lines, words, bytes, filename}) ->
        {lines + 1,
         words + (String.split(line) |> Enum.count()),
         bytes + byte_size(line),
         filename}
    end)
  end

  defp add_total([s]), do: [s]
  defp add_total(counts) do
    total = Enum.reduce(counts, {0,0,0, "total"},
      fn({l,w,b,_}, {al,aw,ab,an}) ->
        {l+al, w+aw, b+ab, an}
      end)
    counts ++ [total]
  end

  defp print_result({lines, words, bytes, filename}) do
    IO.puts " #{lines} #{words} #{bytes} #{filename}"
  end

end

System.argv() |> Wc.main()
