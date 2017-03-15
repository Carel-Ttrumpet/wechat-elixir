defmodule Wechat.ApiBase do
  @moduledoc """
  HTTP request for basic api.
  """
  require Logger
  use HTTPoison.Base

  @base_url "https://api.weixin.qq.com/cgi-bin/"

  def process_url(path) do
    @base_url <> path
  end

  def process_response_body(body), do: Poison.decode!(body, keys: :atoms)

  def get(config_data, path, params \\ []) do
    if String.starts_with?(path, "token") do
      __MODULE__.get!(path, [], params: params).body
    else
      __MODULE__.get!(path, [], params: append_access_token(config_data, params)).body
    end
  end

  def post(config_data, path, body, params \\ []) do
    body = Poison.encode!(body)
    __MODULE__.post!(path, body, [], [params: append_access_token(config_data, params)]).body
  end

  defp append_access_token(config_data, params) do
    params
    |> Keyword.merge([access_token: Wechat.access_token(config_data)])
  end
end
