#!/usr/bin/env elixir
defmodule Curl do
  def main([uri]) do
    target = URI.parse(uri)
    case target.scheme do
      "http" -> http_request(target) |> IO.write()
      other -> raise "Unsupported scheme #{other}"
    end
  end

  defp http_request(%URI{scheme: "http"} = target) do
    host = String.to_charlist(target.host)
    path = target.path || "/"
    {:ok, socket} = :gen_tcp.connect(host, target.port,
      [packet: :http, active: false])
    req = ["GET #{path} HTTP/1.1\r\n",
           "Host: #{target.host}:#{target.port}\r\n",
           "Accept: */*\r\n",
           "\r\n"]
    :ok = :gen_tcp.send(socket, req)
    receive_http_reply(socket)
  end

  defp receive_http_reply(socket) do
    {:ok, {:http_response, _, 200, _}} = :gen_tcp.recv(socket, 0)
    headers = get_headers(socket)
    content_length_value = headers[:"Content-Length"]
    {len,""} = Integer.parse("#{content_length_value}")
    body = get_body(socket, len)
  end

  defp get_headers(socket, acc \\ []) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, {:http_header, _len, k, _, v}} ->
        get_headers(socket, [{k,v}|acc])
      {:ok, :http_eoh} -> Enum.reverse(acc) |> Enum.into(%{})
    end
  end

  defp get_body(socket, length) do
    :ok = :inet.setopts(socket, packet: :raw)
    {:ok, body} = :gen_tcp.recv(socket, length)
    body
  end
end

System.argv() |> Curl.main()
