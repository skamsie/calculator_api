# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalculatorController, type: :controller do
  describe 'GET #compute' do
    context 'with valid input' do
      it 'handles simple calculations' do
        get :compute, params: { expression: '3+4' }

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['expression']).to eq('3 + 4')
        expect(response.parsed_body['result']).to eq(7)
      end

      it 'handles operator precedence' do
        get :compute, params: { expression: '-3+8/4*10' }

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['expression']).to eq('-3 + 8 / 4 * 10')
        expect(response.parsed_body['result']).to eq(17)
      end

      it 'handles decimal response' do
        get :compute, params: { expression: '4/3' }

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['expression']).to eq('4 / 3')
        expect(response.parsed_body['result']).to eq(1.33)
      end

      it 'handles large numbers' do
        get :compute, params: { expression: '123456789012345*2' }

        expect(response).to have_http_status(:ok)
        response.parsed_body

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['expression']).to eq('123456789012345 * 2')
        expect(response.parsed_body['result']).to eq(246_913_578_024_690)
      end
    end

    context 'with invalid characters' do
      it 'renders bad_request' do
        get :compute, params: { expression: '8*(3+2)' }

        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body['error']).to eq('Invalid characters in expression')
      end
    end

    context 'with division by zero' do
      it 'renders unprocessable_entity' do
        get :compute, params: { expression: '5/0' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['error']).to eq('Division by zero')
      end
    end
  end
end
