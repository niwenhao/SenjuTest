class SenjuSuccession < ApplicationRecord
  belongs_to :left, class_name: NetReference
  belongs_to :right, class_name: NetReference
  belongs_to :task, polymorphic: true
end
