defmodule Barbridge.Moderation.ReportLibTest do

  alias Barbridge.AccountFixtures
  alias Barbridge.DiscordFixtures
  alias Barbridge.Moderation.Report
  alias Barbridge.Moderation.ReportLib
  alias Barbridge.Moderation.ReportQueries
  alias Barbridge.ModerationFixtures

  use Barbridge.DataCase, async: true

  @minimum_attributes %{
    "report_id" => 1_234_567_890,
    "discord_message_id" => 1_529_108_517_032_693_771,
    "discord_channel_id" => 1_410_220_729_361_764_412,
  }
  @all_attributes %{
    "report_id" => 1_234_567_891,
    "discord_message_id" => 1_529_108_517_032_693_771,
    "discord_channel_id" => 1_410_220_729_361_764_412
  }
  @no_attributes %{}
  @invalid_attributes %{
    "report_id" => "1_234_567_891",
    "discord_message_id" => "1529108517032693771",
    "discord_channel_id" => "1410220729361764412",
    "first_report_id" => "1_234_567_890",
    "reviewer_id" => 1_234_567_890
  }
  @more_attributes %{
    "report_id" => 1_234_567_891,
    "discord_message_id" => 1_529_108_517_032_693_771,
    "discord_channel_id" => 1_410_220_729_361_764_412,
    "test" => "test"
  }

  describe "create_reports/1" do
    test "handles minimal required attributes" do
      DiscordFixtures.channel_fixture(%{id: @minimum_attributes["discord_channel_id"]})

      {:ok, %Report{} = report} = ReportLib.create_report(@minimum_attributes)

      assert report.report_id == @minimum_attributes["report_id"]
      assert report.discord_message_id == @minimum_attributes["discord_message_id"]
      assert report.discord_channel_id == @minimum_attributes["discord_channel_id"]
    end

    test "handles all attributes" do
      DiscordFixtures.channel_fixture(%{id: @all_attributes["discord_channel_id"]})

      first_report = ModerationFixtures.report_fixture(@minimum_attributes)
      reviewer = AccountFixtures.user_fixture()

      attrs =
        Map.merge(@all_attributes, %{
          "first_report_id" => first_report.id,
          "reviewer_id" => reviewer.id
        })

      {:ok, %Report{} = report} = ReportLib.create_report(attrs)

      assert report.report_id == @all_attributes["report_id"]
      assert report.first_report_id == first_report.id
      assert report.discord_message_id == @all_attributes["discord_message_id"]
      assert report.discord_channel_id == @all_attributes["discord_channel_id"]
      assert report.reviewer_id == reviewer.id
    end

    test "handles no attributes" do
      assert {:error, _error} = ReportLib.create_report(@no_attributes)
    end

    test "handles invalid attributes" do
      DiscordFixtures.channel_fixture(%{id: @invalid_attributes["discord_channel_id"]})

      assert {:error, _error} = ReportLib.create_report(@invalid_attributes)
    end

    test "handles more attributes" do
      DiscordFixtures.channel_fixture(%{id: @more_attributes["discord_channel_id"]})

      first_report = ModerationFixtures.report_fixture(@more_attributes)
      reviewer = AccountFixtures.user_fixture()

      attrs =
        Map.merge(@all_attributes, %{
          "first_report_id" => first_report.id,
          "reviewer_id" => reviewer.id
        })

      {:ok, %Report{} = report} = ReportLib.create_report(attrs)

      assert report.report_id == @more_attributes["report_id"]
      assert report.first_report_id == first_report.id
      assert report.discord_message_id == @more_attributes["discord_message_id"]
      assert report.discord_channel_id == @more_attributes["discord_channel_id"]
      assert report.reviewer_id == reviewer.id
      refute :test in Map.keys(report)
    end
  end

  describe "claim_report/2" do
    test "user can claim report" do
      report = ModerationFixtures.report_fixture()
      reviewer = AccountFixtures.user_fixture()

      {:ok, %Report{} = report} = ReportLib.claim_report(report, reviewer.id)

      assert report.reviewer_id == reviewer.id
    end
  end

  # TODO: Currently uses list_reports/0 to check against the queries. Queries will need to be moved to separate test file in the future
  describe "list_reports/0" do
    test "list by reviewer_id" do
      reviewer = AccountFixtures.user_fixture()
      ModerationFixtures.report_fixture(%{"reviewer_id" => reviewer.id})
      ModerationFixtures.report_fixture()

      queried_reports =
        ReportQueries.reports()
        |> ReportQueries.where_reviewer_id(reviewer.id)
        |> Repo.all()

      assert length(ReportLib.list_reports()) == 2
      assert length(queried_reports) == 1
    end

    test "list by discord_message_id" do
      report = ModerationFixtures.report_fixture()
      ModerationFixtures.report_fixture()

      queried_reports =
        ReportQueries.reports()
        |> ReportQueries.where_discord_message_id(report.discord_message_id)
        |> Repo.all()

      assert length(ReportLib.list_reports()) == 2
      assert length(queried_reports) == 1
    end

    test "list by discord_channel_id" do
      channel = DiscordFixtures.channel_fixture()

      ModerationFixtures.report_fixture(%{"discord_channel_id" => channel.id})
      ModerationFixtures.report_fixture()

      queried_reports =
        ReportQueries.reports()
        |> ReportQueries.where_discord_channel_id(channel.id)
        |> Repo.all()

      assert length(ReportLib.list_reports()) == 2
      assert length(queried_reports) == 1
    end

    test "list by first_report_id" do
      report = ModerationFixtures.report_fixture()
      ModerationFixtures.report_fixture(%{"first_report_id" => report.id})

      queried_reports =
        ReportQueries.reports()
        |> ReportQueries.where_first_report_id(report.id)
        |> Repo.all()

      assert length(ReportLib.list_reports()) == 2
      assert length(queried_reports) == 1
    end

    test "list by inserted_after" do
      ModerationFixtures.report_fixture()
      :timer.sleep(1000)
      report = ModerationFixtures.report_fixture()
      :timer.sleep(1000)
      ModerationFixtures.report_fixture()

      queried_reports =
        ReportQueries.reports()
        |> ReportQueries.inserted_after(report.inserted_at)
        |> Repo.all()

      assert length(ReportLib.list_reports()) == 3
      assert length(queried_reports) == 1
    end

    test "list by inserted_before" do
      ModerationFixtures.report_fixture()
      :timer.sleep(1000)
      report = ModerationFixtures.report_fixture()
      :timer.sleep(1000)
      ModerationFixtures.report_fixture()

      queried_reports =
        ReportQueries.reports()
        |> ReportQueries.inserted_before(report.inserted_at)
        |> Repo.all()

      assert length(ReportLib.list_reports()) == 3
      assert length(queried_reports) == 1
    end

    test "limits by limit" do
      ModerationFixtures.report_fixture()
      ModerationFixtures.report_fixture()

      queried_reports =
        ReportQueries.reports()
        |> ReportQueries.limit(1)
        |> Repo.all()

      assert length(ReportLib.list_reports()) == 2
      assert length(queried_reports) == 1
    end
  end
end
