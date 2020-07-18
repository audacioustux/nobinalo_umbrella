defmodule NobinaloApi.AccountView do
  use NobinaloApi, :view

  alias __MODULE__

  def render("index.json", %{accounts: accounts}) do
    %{data: render_many(accounts, AccountView, "account.json")}
  end

  def render("show.json", %{account: account}) do
    %{data: render_one(account, AccountView, "account.json")}
  end

  def render("account.json", %{account: account}) do
    %{id: account.id, is_active: account.is_active}
  end
end
