defmodule Nobinalo.Users.Guardian do
  use Guardian, otp_app: :nobinalo

  alias Nobinalo.Users.Accounts
  alias Accounts.Account

  def subject_for_token(%Account{id: id}, _claims) do
    {:ok, id}
  end

  def resource_from_claims(claims) do
    account =
      claims["sub"]
      |> Accounts.get_account!()

    {:ok, account}
  end
end
