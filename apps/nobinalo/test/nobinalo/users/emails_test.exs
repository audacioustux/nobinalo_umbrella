defmodule Nobinalo.Users.EmailsTest do
  use Nobinalo.DataCase

  alias Nobinalo.Users.Emails

  describe "emails" do
    alias Nobinalo.Users.Emails.Email

    @valid_attrs %{
      email: "abc@example.com",
      is_backup: true,
      is_primary: true,
      is_public: true,
      account: %{display_name: "some display_name", is_active: true}
    }
    @update_attrs %{
      email: "abcd@example.com",
      is_backup: false,
      is_primary: false,
      is_public: false,
      account: %{display_name: "some other display_name", is_active: true}
    }
    @invalid_attrs %{email: nil, is_backup: nil, is_primary: nil, is_public: nil}

    def email_fixture(attrs \\ %{}) do
      {:ok, email} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Emails.create_email()

      email
    end

    test "list_emails/0 returns all emails" do
      email = email_fixture()
      assert Repo.preload(Emails.list_emails(), [:account]) == [email]
    end

    test "get_email!/1 returns the email with given id" do
      email = email_fixture()
      assert Repo.preload(Emails.get_email!(email.id), [:account]) == email
    end

    test "create_email/1 with valid data creates a email" do
      assert {:ok, %Email{} = email} = Emails.create_email(@valid_attrs)
      assert email.email == "abc@example.com"
      assert email.is_backup == true
      assert email.is_primary == true
      assert email.is_public == true
    end

    test "create_email/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Emails.create_email(@invalid_attrs)
    end

    test "update_email/2 with valid data updates the email" do
      email = email_fixture()
      assert {:ok, %Email{} = email} = Emails.update_email(email, @update_attrs)
      assert email.email == "abcd@example.com"
      assert email.is_backup == false
      assert email.is_primary == false
      assert email.is_public == false
    end

    test "update_email/2 with invalid data returns error changeset" do
      email = email_fixture()
      assert {:error, %Ecto.Changeset{}} = Emails.update_email(email, @invalid_attrs)
      assert email == Repo.preload(Emails.get_email!(email.id), [:account])
    end

    test "delete_email/1 deletes the email" do
      email = email_fixture()
      assert {:ok, %Email{}} = Emails.delete_email(email)
      assert_raise Ecto.NoResultsError, fn -> Emails.get_email!(email.id) end
    end

    test "change_email/1 returns a email changeset" do
      email = email_fixture()
      assert %Ecto.Changeset{} = Emails.change_email(email)
    end
  end
end
