defmodule GoMovie.Account.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias Argon2
  alias GoMovie.Repo

  @derive {Phoenix.Param, key: :user_id}
	@primary_key {:user_id, :id, autogenerate: true}

  schema "users" do
    field :address, :string
    field :city, :string
    field :country, :string
    field :email, :string
    field :image_url, :string
    field :lastname, :string
    field :name, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :phone_number, :string
    field :postal_code, :string
    field :profile_description, :string
    field :sesion_counter, :integer
    field :status, :integer, default: 1

    timestamps()
    belongs_to :role, GoMovie.Account.Role, foreign_key: :role_id, references: :role_id
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :lastname, :email, :password, :image_url, :status, :phone_number, :profile_description, :country, :city, :address, :postal_code, :sesion_counter, :user_id])
    |> unique_constraint(:email)
    |> put_password_hash()
    |> validate_required([:name, :lastname, :email])
  end

  def changesetPasswordUpdate(user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> put_password_hash()
  end

  defp put_password_hash(
    %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
    ) do
  change(changeset, password_hash: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset) do
    changeset
  end

  def authenticate(email, plain_pass) do
      case Repo.one(get_by_email(email)) do
        nil ->
          Argon2.no_user_verify()
          {:error, :invalid_credentials}
        user ->
          if Argon2.verify_pass(plain_pass, user.password_hash) do
            {:ok, user}
          else
            {:error, :invalid_credentials}
          end
      end
  end

  def get_by_email(email) do
    from u in __MODULE__, where: u.email == ^email
  end
end
