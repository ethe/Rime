require "string_scanner"

module Rime
  class Lexer < StringScanner
    def initialize(@str :  String)
      super
      @line_number = 1
      @token = Token.new
    end

    def next_token
      @token.line_number = @line_number

      if eos?
        @token.type = :EOF
        @token.value = "EOF"
      elsif scan(/\n/)
        @token.type = :NEWLINE
        @token.value = "\n"
        @line_number += 1
      elsif scan(/\s+/)
        @token.type = :SPACE
        @token.value = "\s+"
      elsif match = scan(/(\+|-)?\d+\.\d+/)
        @token.type = :FLOAT
        @token.value = match
      elsif match = scan(/(\+|-)?\d+/)
        @token.type = :INT
        @token.value = match
      elsif match = scan(/'\\n'|"\\n"/)
        @token.type = :CHAR
        @token.value = "\n"
      elsif match = scan(/'\\t'|"\\t"/)
        @token.type = :CHAR
        @token.value = "\t"
      elsif match = scan(/'.'|"."/)
        @token.type = :CHAR
        @token.value = match[1..-2]
      elsif match = scan(/'.*'|".*"/)
        @token.type = :STRING
        @token.value = match[1..-2]
      elsif match = scan(%r(!=|!|==|=|<<=|<<|<=|<|>>=|>>|>=|>|\+=|\+|-=|-|\*=|\*\*=|\*\*|\*|/=|%=|&=|\|=|\^=|/|\(|\)|,|\.|&&|&|\|\||\||\{|\}|\?|:|%|\^|~|\[\]|\[|\]))
        @token.type = :OPRATION
        @token.value = match
      elsif match = scan(/(function|elsif|else|end|if|true|false|class|while|none|yield|return|unless|next|break|and|or|not)\b/)
        @token.type = :KEYWORD
        @token.value = match
      elsif match = scan(/[a-zA-Z_][a-zA-Z_0-9]*(\?|!)?/)
        @token.type = :IDENT
        @token.value = match
      elsif scan(/#/)
        if scan /.*\n/
          @token.type = :NEWLINE
          @line_number += 1
        else
          scan(/.*/)
          @token.type = :EOF
        end
      else
        raise_error("can't lex anymore")
      end

      return @token
    end

    def next_token_if(*types : Symbol)
      while true
        next_token
        if types.include? @token.type
          return
        end
      end
    end

    def next_token_skip_space
      next_token_if :SPACE
      return next_token
    end

    def raise_error(message : String)
      raise Exception.new("Syntax error on line #{@line_number}: #{message}")
    end
  end
end
