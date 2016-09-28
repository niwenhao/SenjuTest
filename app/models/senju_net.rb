class SenjuNet < ApplicationRecord
  belongs_to :senjuEnv
  belongs_to :preExec, polymorphic: true
  belongs_to :postExec, polymorphic: true
  has_many :netReference
end
