class CreateSenjuSuccessions < ActiveRecord::Migration[5.0]
  def change
    create_table :senju_successions do |t|
      t.references :left, foreign_key: true
      t.references :right, foreign_key: true
      t.references :task, polymorphic: true

      t.timestamps
    end
  end
end
