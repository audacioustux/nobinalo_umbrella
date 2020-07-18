defmodule Nobinalo.Users do
  import Ecto.Query
  alias Nobinalo.Repo

  alias Nobinalo.Users.Emails.Email

  def get_account_by_email_and_password(email, password) do
    account =
      from e in Email,
        join: a in assoc(e, :account),
        where: e.email == ^email,
        select: a

    account
    |> Repo.one()
    |> verify_password(password)
  end

  defp verify_password(nil, _) do
    # Perform a dummy check to make user enumeration more difficult
    Argon2.no_user_verify()
    {:error, "Wrong email or password"}
  end

  defp verify_password(user, password) do
    if Argon2.verify_pass(password, user.password_hash) do
      {:ok, user}
    else
      {:error, "Wrong email or password"}
    end
  end
end
