require 'spec_helper'
require_relative '../lib/web_merge/constants'
require_relative '../lib/web_merge/api'

describe WebMerge::API do
  let(:api) { described_class.new(secret: 'foo', key: 'bar', force_test_mode: true) }
  let(:document) do
    double(:document, id: 123, type: 'pdf', contents: 'things', updated_at: Time.now)
  end

  describe '#get_document_file' do

    let(:url_string) { "#{WebMerge::Constants::DOCUMENTS}/#{document.id}/file" }
    let(:response) do
      { 'type' => document.type, 'last_update' => document.updated_at, 'contents' => document.contents }
    end
    it 'makes a get request' do
      expect(api).to receive(:get).with(url_string).and_return(response)
      expect(api.get_document_file(document.id)).to eq(response)
    end
  end
end
