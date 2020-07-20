defmodule Nobinalo.Users.Guardian do
  use Guardian, otp_app: :nobinalo

  alias Nobinalo.Users.Accounts

  def subject_for_token(sub, _claims) do
    {:ok, sub}
  end

  def resource_from_claims(%{"sub" => account_id}) do
    account = Accounts.get_account!(account_id)
    {:ok, account}
  rescue
    Ecto.NoResultsError -> {:error, :resource_not_found}
  end
end
