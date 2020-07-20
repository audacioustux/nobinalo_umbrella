defmodule Nobinalo.Users.Emails.Bamboo do
  use Bamboo.Phoenix, view: NobinaloEmailViews

  alias Nobinalo.Users.Emails.Mailer

  def deliver(%Bamboo.Email{} = email, later \\ false) do
    case later do
      true -> Mailer.deliver_now(email)
      false -> Mailer.deliver_later(email)
    end

    {:ok, %{to: email.to, body: email.html_body}}
  end
end
