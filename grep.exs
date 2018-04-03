#!/usr/bin/env elixir

defmodule Grep do
  def main(args) do
    case args do
      [pattern] ->
        IO.stream(:stdio, :line)
        |> process_one(pattern)
      [pattern, path] ->
        File.stream!(path, [:read], :line)
        |> process_one(pattern)
      [pattern | paths ] ->
        Enum.map(paths, fn p -> {p, File.read!(p)} end)
        |> process_many(pattern)
    end
  end

  defp process_one(stream, pattern) do
    stream
    |> Stream.filter(&String.contains?(&1, pattern))
    |> Stream.map(&IO.write/1)
    |> Stream.run()
  end

  defp process_many(annotated_files, pattern) do
    annotated_files
    |> Enum.map(fn {annot, contents} ->
      {annot, find_matches(contents, pattern)}
    end)
    |> Enum.each(&print_matches/1)
  end

  defp find_matches(blob, pattern) do
    String.split(blob, "\n")
    |> Enum.filter(&String.contains?(&1, pattern))
  end

  defp print_matches({_, []}), do: :ok
  defp print_matches({path, matches}) do
    matches
    |> Enum.each(fn match ->
      IO.write(:stdio, "#{path}:#{match}\n")
    end)
  end


end

System.argv() |> Grep.main()
