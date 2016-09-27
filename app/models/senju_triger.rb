class SenjuTriger < ApplicationRecord
  belongs_to :postExec, polymorphic: true
end
