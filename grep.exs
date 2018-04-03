#!/usr/bin/env elixir

defmodule Grep do
  def main([pattern | tail]) do
    open_stream(tail)
    |> Stream.filter(&String.contains?(&1, pattern))
    |> Stream.map(&IO.write/1)
    |> Stream.run()
  end
  defp open_stream([path]), do: File.stream!(path, [:read], :line)
  defp open_stream([]), do: IO.stream(:stdio, :line)
end

System.argv() |> Grep.main()
