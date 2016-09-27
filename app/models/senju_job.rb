class SenjuJob < ApplicationRecord
  belongs_to :senjuEnv
  belongs_to :task, polymorphic: true
  belongs_to :preExec, polymorphic: true
  belongs_to :postExec, polymorphic: true
end
