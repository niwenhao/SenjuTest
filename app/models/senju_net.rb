class SenjuNet < ApplicationRecord
  NAME = 0
  AVA_DATE = 1
  DESC = 2
  TYPE = 3
  REF_NAME = 4
  EXECENV = 9

  PRECEDE_START = 20
  PRECEDE_COUNT = 30

  SENJU_TYPE = "ネット"

  belongs_to :senjuEnv, optional: true
  belongs_to :preExec, polymorphic: true, dependent: :destroy, optional: true
  belongs_to :postExec, polymorphic: true, dependent: :destroy, optional: true
  has_many :netReferences, dependent: :destroy, foreign_key: "senjuNet_id"

  alias :refs :netReferences
end
