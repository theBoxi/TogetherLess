class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.integer :user_id
      t.float :weight
      t.datetime :date

      t.timestamps
    end
  end
end
