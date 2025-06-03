# frozen_string_literal: true

class CalculatorController < ApplicationController
  def compute
    result = CalculatorService.call(calculator_params)

    render json: {
      expression: format_expression(result[:tokens]),
      result: format_result(result[:result])
    }
  rescue ActionController::ParameterMissing
    render json: { error: 'Missing required parameter: expression' }, status: :bad_request
  rescue CalculatorService::InvalidCharacter
    render json: { error: 'Invalid characters in expression' }, status: :bad_request
  rescue CalculatorService::DivisionByZero
    render json: { error: 'Division by zero' }, status: :unprocessable_entity
  end

  private

  def calculator_params
    params.require(:expression).to_s
  end

  def format_expression(tokenized_expression)
    tokenized_expression.join(' ')
  end

  def format_result(value)
    (value % 1).zero? ? value.to_i : value.truncate(2).to_f
  end
end
