module Rime
  class Token
    getter type, value, line_number
    setter type, value, line_number

    def initialize(type : Symbol = :EMPTY, value : String = "", line_number : Int32 = 1)
        @type = type
        @value = value
        @line_number = line_number
    end

    def to_s
      value.to_s()
    end
  end
end
