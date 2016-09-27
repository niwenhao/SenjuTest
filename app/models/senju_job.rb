class SenjuJob < ApplicationRecord
  belongs_to :senjuEnv
  belongs_to :task, polymorphic: true
end
