defmodule Barbridge.Moderation.ReportQueries do
  @moduledoc false
  alias Ecto.Query
  alias Barbridge.Moderation.Report

  use Barbridge.FileMacros, :queries

  @type t :: Query.t()

  @spec reports() :: t()
  def reports do
    from(reports in Report, as: :reports)
  end

  @spec where_id(t(), pos_integer()) :: t()
  def where_id(query, id) do
    from reports in query,
      where: reports.id == ^id
  end

  @spec where_report_id(t(), pos_integer()) :: t()
  def where_report_id(query, report_id) do
    from reports in query,
      where: reports.report_id == ^report_id
  end

  @spec where_reviewer_id(t(), Ecto.UUID.t()) :: t()
  def where_reviewer_id(query, reviewer_id) do
    from reports in query,
      where: reports.reviewer_id == ^reviewer_id
  end

  @spec where_discord_message_id(t(), pos_integer()) :: t()
  def where_discord_message_id(query, discord_message_id) do
    from reports in query,
      where: reports.discord_message_id == ^discord_message_id
  end

  @spec where_discord_channel_id(t(), pos_integer()) :: t()
  def where_discord_channel_id(query, discord_channel_id) do
    from reports in query,
      where: reports.discord_channel_id == ^discord_channel_id
  end

  @spec where_first_report_id(t(), pos_integer()) :: t()
  def where_first_report_id(query, first_report_id) do
    from reports in query,
      where: reports.first_report_id == ^first_report_id
  end

  @spec where_reporter_id(t(), pos_integer()) :: t()
  def where_reporter_id(query, reporter_id) do
    from reports in query,
      where: reports.reporter_id == ^reporter_id
  end

  @spec order_by_id(t(), :asc | :desc) :: t()
  def order_by_id(query, direction \\ :asc) do
    if direction == :asc do
      from(reports in query, order_by: [asc: reports.id])
    else
      from(reports in query, order_by: [desc: reports.id])
    end
  end

  @spec inserted_before(t(), NaiveDateTime.t()) :: t()
  def inserted_before(query, timestamp) do
    from reports in query,
      where: reports.inserted_at > ^timestamp
  end

  @spec inserted_after(t(), NaiveDateTime.t()) :: t()
  def inserted_after(query, timestamp) do
    from reports in query,
      where: reports.inserted_at < ^timestamp
  end

  @spec limit(t(), pos_integer()) :: t()
  def limit(query, limit) do
    from reports in query,
      limit: ^limit
  end
end
