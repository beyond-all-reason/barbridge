defmodule Barbridge.Communication.ApiLib do
  @moduledoc false

  @base_url "http://localhost:5000/api/"

  @type report_opt ::
          {:start_date, String.t() | Date.t() | nil}
          | {:end_date, String.t() | Date.t() | nil}
          | {:status, String.t() | nil}
          | {:limit, pos_integer() | nil}
          | {:closed, boolean() | nil}

  @type action_opt ::
          {:id, integer() | String.t() | nil}
          | {:target_id, integer() | String.t() | nil}
          | {:discord_message_id, integer() | String.t() | nil}

  @type result ::
          {:ok, term()}
          | {:error, Jason.DecodeError.t()}
          | {:error, {:http_error, non_neg_integer(), String.t()}}
          | {:error, term()}

  @spec get_actions([action_opt()]) :: result()
  def get_reports(opts \\ []) do
    params =
      opts
      |> Keyword.take([
        :closed,
        :discord_message_id,
        :id,
        :match_id,
        :result_id,
        :reporter_id,
        :target_id,
        :type
      ])
      |> Enum.reject(fn {_k, v} -> is_nil(v) end)

    case HTTPoison.get(@base_url <> "reports", [], params: params) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Jason.decode(body)

      {:ok, %HTTPoison.Response{status_code: status, body: body}} ->
        {:error, {:http_error, status, body}}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @spec get_actions([action_opt()]) :: result()
  def get_actions(opts \\ []) do
    params =
      opts
      |> Keyword.take([:id, :target_id, :discord_message_id])
      |> Enum.reject(fn {_k, v} -> is_nil(v) end)

    case HTTPoison.get(@base_url <> "actions", [], params: params) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Jason.decode(body)

      {:ok, %HTTPoison.Response{status_code: status, body: body}} ->
        {:error, {:http_error, status, body}}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
