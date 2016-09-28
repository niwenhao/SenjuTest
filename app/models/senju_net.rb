class SenjuNet < ApplicationRecord
    NAME = 0
    AVA_DATE = 1
    DESC = 2
    TYPE = 3
    REF_NAME = 4
    EXECENV = 9
  belongs_to :senjuEnv
  belongs_to :preExec, polymorphic: true, dependent: :destroy
  belongs_to :postExec, polymorphic: true, dependent: :destroy
  has_many :netReference, dependent: :destroy
end
