class CreateSnapshots < ActiveRecord::Migration[7.0]
  def change
    create_table :snapshots do |t|
      t.references :team, null: false, foreign_key: true
      t.string :note
      t.money :total

      t.timestamps
    end
  end
end
