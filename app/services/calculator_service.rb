# frozen_string_literal: true

require 'bigdecimal'
require 'bigdecimal/util'

# Returns { result: BigDecimal, tokens: str }
#
# Input may contain:
#   - integer literals (positive or negative, e.g. "42", "-7")
#   - the operators +, -, *, /
#   - optional whitespace (ignored)
#
# Raises InvalidCharacter if any invalid characters are present.
# Raises DivisionByZero if division by zero is attempted.
class CalculatorService
  class InvalidCharacter < StandardError; end
  class DivisionByZero < StandardError; end
  class << self
    def call(raw_expression)
      expression = strip_and_remove_spaces(raw_expression)
      validate_format!(expression)

      tokens = tokenize(expression)
      evaluate_and_compute(tokens)
    end

    private

    def strip_and_remove_spaces(str)
      str.to_s.strip.delete(' ')
    end

    def validate_format!(str)
      pattern = %r{\A-?\d+(?:[+\-*/]-?\d+)*\z}
      return if str.match?(pattern)

      raise InvalidCharacter, 'Expression may only contain integers and + - * /'
    end

    def tokenize(str)
      # Splits into integers or single operators
      str.scan(%r{-?\d+|[+\-*/]})
    end

    def evaluate_and_compute(tokens)
      stack = []
      current_operator = '+'

      tokens.each do |token|
        if token.match?(/\A-?\d+\z/) # integer
          number = BigDecimal(token)

          case current_operator
          when '+'
            stack.push(number)
          when '-'
            stack.push(number * -1)
          when '*'
            prev = stack.pop
            stack.push(prev * number)
          when '/'
            raise DivisionByZero, 'Division by zero' if number.zero?

            prev = stack.pop
            stack.push(prev / number)
          end
        else
          # token is one of +, -, *, /
          current_operator = token
        end
      end

      result = stack.reduce(BigDecimal('0'), :+)

      { result: result, tokens: tokens }
    end
  end
end
