#!/usr/bin/env elixir

defmodule Cat do
  def main() do
    case System.argv() do
      [file] -> File.stream!(file, [:read], :line)
      [] -> IO.stream(:stdio, :line)
    end
    |> Stream.map(&IO.write/1)
    |> Stream.run()
  end
end

Cat.main()
