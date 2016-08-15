require "./spec_helper"

include Rime


describe Lexer do
  it_lexes " ", :SPACE, "\s+"
  it_lexes "    ", :SPACE, "\s+"
  it_lexes "\n", :NEWLINE, "\n"
  it_lexes "\n\n\n", :NEWLINE, "\n"
  it_lexes_keywords "function", "if", "else", "elsif", "end", "true", "false", "class", "while", "none",
                    "yield", "return", "unless", "next", "break"
  it_lexes_idents "ident", "something", "with_underscores", "with_1", "foo?", "bar!"
  it_lexes_ints "1", ["1_hello42", "1"], "+1", "-1"
  it_lexes_floats "1.0", ["1.0_hello42", "1.0"], "+1.0", "-1.0"
  it_lexes_char "'a'", "a"
  it_lexes_char "'\\n'", "\n"
  it_lexes_char "'\\t'", "\t"
  it_lexes_string "\"hello, world\"", "hello, world"
  it_lexes_operators "=", "<", "<=", ">", ">=", "+", "-", "*", "/", "(", ")", "==", "!=", "!", ",", ".", "&&", "||", "|", "{", "}", "?", ":", "+=", "-=", "*=", "/=", "%=", "&=", "|=", "^=", "**=", "<<", ">>", "%", "&", "|", "^", "**", "<<=", ">>=", "~", "[]", "[", "]"
end


def it_lexes(string, type, value = nil)
  it "lexes #{string}" do
    lexer = Lexer.new(string)
    token = lexer.next_token
    token.type.should eq(type)
    token.value.should eq(value)
  end
end


def self.it_lexes_keywords(*args)
  args.each do |arg|
    it_lexes arg, :KEYWORD, arg
  end
end


def self.it_lexes_idents(*args)
  args.each do |arg|
    it_lexes arg, :IDENT, arg
  end
end


def self.it_lexes_ints(*args)
  args.each do |arg|
    if arg.is_a? Array
      it_lexes arg[0], :INT, arg[1]
    else
      it_lexes arg, :INT, arg
    end
  end
end


def self.it_lexes_floats(*args)
  args.each do |arg|
    if arg.is_a? Array
      it_lexes arg[0], :FLOAT, arg[1]
    else
      it_lexes arg, :FLOAT, arg
    end
  end
end


def self.it_lexes_char(string, value)
  it_lexes string, :CHAR, value
end


def self.it_lexes_string(string, value)
  it_lexes string, :STRING, value
end


  def self.it_lexes_operators(*args)
    args.each do |arg|
      it_lexes arg, :OPRATION, arg
    end
  end
