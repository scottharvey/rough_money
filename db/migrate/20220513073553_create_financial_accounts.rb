class CreateFinancialAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :financial_accounts do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name
      t.string :description
      t.string :currency
      t.integer :account_type

      t.timestamps
    end
  end
end
