class NetReference < ApplicationRecord
  belongs_to :senjuNet
  belongs_to :senjuObject, polymorphic: true
  has_many :left, class_name: "SenjuSuccession", foreign_key: "left_id"
  has_many :right, class_name: "SenjuSuccession", foreign_key: "right_id"
end
