class SenjuNet < ApplicationRecord
    NAME = 0
    AVA_DATE = 1
    DESC = 2
    TYPE = 3
    REF_NAME = 4
    EXECENV = 9

    JOB_TYPE = "ジョブ"
    NET_TYPE = "ネット"
    TRG_TYPE = "トリガ"

    PRECEDE_START = 20
    PRECEDE_COUNT = 30
  belongs_to :senjuEnv
  belongs_to :preExec, polymorphic: true, dependent: :destroy
  belongs_to :postExec, polymorphic: true, dependent: :destroy
  has_many :netReferences, dependent: :destroy
end
