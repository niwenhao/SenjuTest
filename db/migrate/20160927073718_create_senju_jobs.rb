class CreateSenjuJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :senju_jobs do |t|
      t.string :name
      t.string :description
      t.string :command
      t.integer :expected
      t.references :senjuEnv, foreign_key: true
      t.references :task, polymorphic: true

      t.timestamps
    end
  end
end
