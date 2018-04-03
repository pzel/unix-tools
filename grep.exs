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
      [pattern | paths] ->
        Enum.map(paths, fn p -> {p, File.read!(p)} end)
        |> process_many(pattern)
    end
  end

  defp process_one(stream, pattern) do
    stream
    |> Stream.filter(&pattern_matches?(pattern, &1))
    |> Stream.map(&IO.write/1)
    |> Stream.run()
  end

  defp process_many(annotated_files, pattern) do
    Task.async_stream(annotated_files,
      fn {annot, contents} ->
        {annot, find_matches(contents, pattern)}
      end)
    |> Enum.to_list()
    |> Enum.each(&print_matches/1)
  end

  defp find_matches(blob, pattern) do
    String.split(blob, "\n")
    |> Enum.filter(&pattern_matches?(pattern, &1))
  end

  defp print_matches({:ok, {_, []}}), do: :ok
  defp print_matches({:ok, {path, matches}}) do
    Enum.each(matches, fn match ->
      IO.write(:stdio, "#{path}:#{match}\n")
    end)
  end

  defp pattern_matches?(pattern, subject) do
    Regex.match?(Regex.compile!(pattern), subject)
  end

end

System.argv() |> Grep.main()
