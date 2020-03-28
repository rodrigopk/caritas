# frozen_string_literal: true

Hanami::Model.migration do
  change do
    create_table :institutions do
      primary_key :id,
                  'uuid',
                  null: false,
                  default: Hanami::Model::Sql.function(:uuid_generate_v4)

      column :name, String, null: false
      column :cnpj, String, null: false, limit: 14
      column :description, String
      column :website_url, String
      column :logo_url, String

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
