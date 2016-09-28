class NetReference < ApplicationRecord
  belongs_to :senjuNet
  belongs_to :senjuObject, polymorphic: true
  belongs_to :senjuEnv
  has_many :left, class_name: "SenjuSuccession", foreign_key: "left_id", dependent: :destroy
  has_many :right, class_name: "SenjuSuccession", foreign_key: "right_id", dependent: :destroy
end
