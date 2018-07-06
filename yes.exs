#!/bin/env elixir

defmodule Yes do
  @default_output "y"

  def main([]), do: loop(@default_output)
  def main([arg]), do: loop(arg)

  def loop(arg) do
    IO.puts(arg)
    loop(arg)
  end

  def loop_(arg) do
    try do IO.puts(arg)
    rescue _ -> System.halt(1)
    end
    loop(arg)
  end
end

System.argv() |> Yes.main()
