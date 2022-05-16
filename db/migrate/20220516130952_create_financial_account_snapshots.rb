class CreateFinancialAccountSnapshots < ActiveRecord::Migration[7.0]
  def change
    create_table :financial_account_snapshots do |t|
      t.references :team, null: false, foreign_key: true
      t.references :financial_account, null: false, foreign_key: true
      t.references :snapshot, null: false, foreign_key: true
      t.money :total
      t.string :currency

      t.timestamps
    end
  end
end
