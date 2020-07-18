defmodule Nobinalo.Users.ProfilesTest do
  use Nobinalo.DataCase

  alias Nobinalo.Users.Profiles

  describe "profiles" do
    alias Nobinalo.Users.Profiles.Profile

    @valid_attrs %{
      gender: "male",
      handle: "tux",
      account: %{display_name: "some display_name"},
      preferences: %{avatar_cord: [5, 5, 100], cover_cord: [0, 0, 200]}
    }
    @update_attrs %{
      gender: "female",
      handle: "fetux",
      account: %{display_name: "some other display_name"},
      preferences: %{avatar_cord: [10, 15, 150], cover_cord: [5, 5, 150]}
    }
    @invalid_attrs %{gender: nil, handle: nil, account: nil}

    def profile_fixture(attrs \\ %{}) do
      {:ok, profile} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Profiles.create_profile()

      profile
    end

    test "list_profiles/0 returns all profiles" do
      profile = profile_fixture()
      assert Repo.preload(Profiles.list_profiles(), [:account]) == [profile]
    end

    test "get_profile!/1 returns the profile with given id" do
      profile = profile_fixture()
      assert Repo.preload(Profiles.get_profile!(profile.id), [:account]) == profile
    end

    test "create_profile/1 with valid data creates a profile" do
      assert {:ok, %Profile{} = profile} = Profiles.create_profile(@valid_attrs)
      assert profile.gender == "male"
      assert profile.handle == "tux"
    end

    test "create_profile/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Profiles.create_profile(@invalid_attrs)
    end

    test "update_profile/2 with valid data updates the profile" do
      profile = profile_fixture()
      assert {:ok, %Profile{} = profile} = Profiles.update_profile(profile, @update_attrs)
      assert profile.gender == "female"
      assert profile.handle == "fetux"
    end

    test "update_profile/2 with invalid data returns error changeset" do
      profile = profile_fixture()
      assert {:error, %Ecto.Changeset{}} = Profiles.update_profile(profile, @invalid_attrs)
      assert profile == Repo.preload(Profiles.get_profile!(profile.id), [:account])
    end

    test "delete_profile/1 deletes the profile" do
      profile = profile_fixture()
      assert {:ok, %Profile{}} = Profiles.delete_profile(profile)
      assert_raise Ecto.NoResultsError, fn -> Profiles.get_profile!(profile.id) end
    end

    test "change_profile/1 returns a profile changeset" do
      profile = profile_fixture()
      assert %Ecto.Changeset{} = Profiles.change_profile(profile)
    end
  end
end
