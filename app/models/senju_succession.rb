class SenjuSuccession < ApplicationRecord
  belongs_to :left, polymorphic: true
  belongs_to :right, polymorphic: true
  belongs_to :task, polymorphic: true
end
