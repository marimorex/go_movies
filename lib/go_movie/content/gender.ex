defmodule GoMovie.Content.Gender do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Phoenix.Param, key: :gender_id}
	@primary_key {:gender_id, :id, autogenerate: true}

  schema "genders" do
    field :description, :string
    field :name, :string
    field :status, :integer, default: 1

    timestamps()
    has_many :resource_genders, GoMovie.Content.ResourceGender, foreign_key: :gender_id, references: :gender_id
    has_many :user_genders_follow, GoMovie.Content.UserGenderFollow, foreign_key: :gender_id, references: :gender_id
  end

  @doc false
  def changeset(gender, attrs) do
    gender
    |> cast(attrs, [:name, :description, :status, :gender_id])
    |> validate_required([:name, :description, :status])
  end
end