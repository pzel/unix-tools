#!/usr/bin/env elixir

defmodule Cat do
  def main(args) do
    case args do
      [file] -> File.stream!(file, [:read], :line)
      [] -> IO.stream(:stdio, :line)
    end
    |> Stream.map(&IO.write/1)
    |> Stream.run()
  end
end

System.argv() |> Cat.main()
