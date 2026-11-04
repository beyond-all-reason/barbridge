defmodule Barbridge.Moderation.ReportLib do
  @moduledoc false

  alias Barbridge.Moderation.Report
  alias Barbridge.Moderation.ReportQueries
  alias Barbridge.Repo

  @spec create_report(map) :: {:ok, Report} | {:error, Ecto.Changeset.t()}
  def create_report(attrs \\ %{}) do
    %Report{}
    |> Report.changeset(attrs)
    |> Repo.insert()
  end

  @spec claim_report(Report.t(), non_neg_integer) :: {:ok, Report} | {:error, Ecto.Changeset.t()}
  def claim_report(%Report{} = report, user_id) do
    report
    |> Report.changeset(%{user_id: user_id})
    |> Repo.update()
  end

  def list_reports do
    ReportQueries.reports()
    |> Repo.all()
  end

  @spec get_report_by_message_id(integer()) :: Report.t()
  def get_report_by_message_id(discord_message_id) do
    ReportQueries.reports()
    |> ReportQueries.where_discord_message_id(discord_message_id)
    |> Repo.one()
  end

  @spec get_report_by_channel_id(integer()) :: [Report.t()]
  def get_report_by_channel_id(discord_channel_id) do
    ReportQueries.reports()
    |> ReportQueries.where_discord_channel_id(discord_channel_id)
    |> Repo.all()
  end
end
