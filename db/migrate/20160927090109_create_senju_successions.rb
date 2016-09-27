class CreateSenjuSuccessions < ActiveRecord::Migration[5.0]
  def change
    create_table :senju_successions do |t|
      t.references :left, polymorphic: true
      t.references :right, polymorphic: true
      t.references :task, polymorphic: true

      t.timestamps
    end
  end
end
