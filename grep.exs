#!/usr/bin/env elixir

defmodule Grep do
  def main(args) do
    case args do
      [pattern] ->
        IO.stream(:stdio, :line)
        |> process_one(Regex.compile!(pattern))
      [pattern, path] ->
        File.stream!(path, [:read], :line)
        |> process_one(Regex.compile!(pattern))
      [pattern | paths] ->
        Enum.map(paths, fn p -> {p, File.read!(p)} end)
        |> process_many(Regex.compile!(pattern))
    end
  end

  defp process_one(stream, re) do
    Stream.filter(stream, &Regex.match?(re, &1))
    |> Stream.map(&IO.write/1)
    |> Stream.run()
  end

  defp process_many(annotated_files, re) do
    Task.async_stream(annotated_files,
      fn {annot, contents} ->
        {annot, find_matches(contents, re)}
      end)
    |> Enum.to_list()
    |> Enum.each(&print_matches/1)
  end

  defp find_matches(blob, re) do
    String.split(blob, "\n")
    |> Enum.filter(&Regex.match?(re, &1))
  end

  defp print_matches({:ok, {_, []}}), do: :ok
  defp print_matches({:ok, {path, matches}}) do
    Enum.each(matches, fn match ->
      IO.write(:stdio, "#{path}:#{match}\n")
    end)
  end
end

System.argv() |> Grep.main()
