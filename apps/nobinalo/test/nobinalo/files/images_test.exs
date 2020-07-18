defmodule Nobinalo.Files.ImagesTest do
  use Nobinalo.DataCase

  alias Nobinalo.Files.Images

  describe "images" do
    alias Nobinalo.Files.Images.Image

    @valid_attrs %{
      height: 42,
      name: "some name",
      width: 42,
      profile: %{
        handle: "tux",
        preferences: %{},
        account: %{display_name: "some display_name"}
      }
    }
    @update_attrs %{
      height: 43,
      name: "some updated name",
      width: 43,
      profile: %{
        handle: "fetux",
        preferences: %{},
        account: %{display_name: "some other display_name"}
      }
    }
    @invalid_attrs %{height: nil, name: nil, width: nil}

    def image_fixture(attrs \\ %{}) do
      {:ok, image} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Images.create_image()

      image
    end

    test "list_images/0 returns all images" do
      image = image_fixture()
      assert Repo.preload(Images.list_images(), [:profile, profile: :account]) == [image]
    end

    test "get_image!/1 returns the image with given id" do
      image = image_fixture()
      assert Repo.preload(Images.get_image!(image.id), [:profile, profile: :account]) == image
    end

    test "create_image/1 with valid data creates a image" do
      assert {:ok, %Image{} = image} = Images.create_image(@valid_attrs)
      assert image.height == 42
      assert image.name == "some name"
      assert image.width == 42
    end

    test "create_image/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Images.create_image(@invalid_attrs)
    end

    test "update_image/2 with valid data updates the image" do
      image = image_fixture()
      assert {:ok, %Image{} = image} = Images.update_image(image, @update_attrs)
      assert image.height == 43
      assert image.name == "some updated name"
      assert image.width == 43
    end

    test "update_image/2 with invalid data returns error changeset" do
      image = image_fixture()
      assert {:error, %Ecto.Changeset{}} = Images.update_image(image, @invalid_attrs)
      assert image == Repo.preload(Images.get_image!(image.id), [:profile, [profile: :account]])
    end

    test "delete_image/1 deletes the image" do
      image = image_fixture()
      assert {:ok, %Image{}} = Images.delete_image(image)
      assert_raise Ecto.NoResultsError, fn -> Images.get_image!(image.id) end
    end

    test "change_image/1 returns a image changeset" do
      image = image_fixture()
      assert %Ecto.Changeset{} = Images.change_image(image)
    end
  end
end
