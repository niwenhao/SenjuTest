class SenjuJob < ApplicationRecord
    NAME = 0
    EXEC_ENV = 1
    EXPECTED = 2
    CMD = 3
    DESC = 4

    belongs_to :senjuEnv
    belongs_to :task, polymorphic: true, dependent: :destroy
    belongs_to :preExec, polymorphic: true, dependent: :destroy
    belongs_to :postExec, polymorphic: true, dependent: :destroy
end
