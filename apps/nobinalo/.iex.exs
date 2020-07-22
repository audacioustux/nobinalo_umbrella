IEx.configure(history_size: 50)

import Ecto.Query

alias Nobinalo.Repo

alias Nobinalo.Users
alias Users.Accounts
alias Accounts.Account
alias Users.Emails
alias Emails.Email
alias Emails.Mailer
alias Users.Profiles
alias Profiles.Profile
alias Users.Guardian

alias Nobinalo.Files
alias Files.Images
alias Images.Image
