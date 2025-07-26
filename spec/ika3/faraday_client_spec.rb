# frozen_string_literal: true

require 'spec_helper'
require 'faraday'

RSpec.describe Ika3::FaradayClient do
  let(:client) { described_class.new('test@example.com') }

  # Faradayのテスト用スタブをセットアップ
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:connection) do
    Faraday.new do |conn|
      conn.request :json
      conn.response :json
      conn.adapter :test, stubs
    end
  end

  describe '#get' do
    before do
      # clientインスタンスが内部で使うconnectionをスタブに差し替える
      allow(client).to receive(:connection).and_return(connection)
    end

    context 'when the request is successful' do
      let(:path) { '/api/test' }
      let(:response_body) { { 'result' => 'ok' } }

      before do
        stubs.get(path) { [200, { 'Content-Type' => 'application/json' }, response_body] }
      end

      it 'returns an Ika3::Response object' do
        expect(client.get(path)).to be_a(Ika3::Response)
      end

      it 'has a parsed JSON body in the response' do
        response = client.get(path)
        expect(response.body).to eq(response_body)
      end
    end

    context 'when the API returns an error status' do
      let(:path) { '/api/error' }

      before do
        stubs.get(path) { [500, {}, 'Internal Server Error'] }
      end

      it 'raises an Ika3::Error' do
        expect { client.get(path) }.to raise_error(Ika3::Error, 'API Error: 500')
      end
    end

    context 'when a connection error occurs' do
      let(:path) { '/api/connection_error' }

      before do
        stubs.get(path) { raise Faraday::ConnectionFailed, 'connection failed' }
      end

      it 'raises an Ika3::Error and wraps the original error' do
        expect { client.get(path) }.to raise_error(Ika3::Error, 'Connection Error: connection failed')
      end
    end
  end
end
