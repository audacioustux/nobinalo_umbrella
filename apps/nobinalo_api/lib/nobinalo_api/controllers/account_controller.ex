defmodule NobinaloApi.AccountController do
  use NobinaloApi, :controller

  alias Nobinalo.Users.Accounts

  action_fallback(NobinaloApi.FallbackController)

  def index(conn, _) do
    accounts = Accounts.list_accounts()
    render(conn, "index.json", accounts: accounts)
  end
end
