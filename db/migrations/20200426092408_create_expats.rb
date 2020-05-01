# frozen_string_literal: true

Hanami::Model.migration do
  change do
    create_table :expats do
      primary_key :id,
                  'uuid',
                  null: false,
                  default: Hanami::Model::Sql.function(:uuid_generate_v4)

      foreign_key :account_id,
                  :accounts,
                  type: 'uuid',
                  null: false,
                  on_delete: :cascade

      column :first_name, String, null: false
      column :last_name, String

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
