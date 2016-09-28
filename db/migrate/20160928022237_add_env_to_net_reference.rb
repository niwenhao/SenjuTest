class AddEnvToNetReference < ActiveRecord::Migration[5.0]
  def change
    add_reference :net_references, :senjuEnv, foreign_key: true
  end
end
