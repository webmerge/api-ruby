require 'spec_helper'
require_relative '../lib/web_merge/constants'
require_relative '../lib/web_merge/document'

describe WebMerge::Document do
  describe '.find' do
    let(:document) do
      described_class.new(client: 'foo', name: 'foo', type: 'foo').tap do |document|
        document.send(:id=, rand(1..10))
      end
    end
    let(:client) { double(:client, get_document: response ) }
    let(:response) { { foo: 'irrelevant' } }

    it 'returns a document' do
      finder = described_class.find(document.id, client: client)
      expect(finder).to be_kind_of(described_class)
    end
  end

  describe '.all' do
    let(:client) { double(:client, get_documents: response ) }
    let(:response) { [ first_document: 'foo', second_document: 'bar' ] }

    it 'returns a collection of documents' do
      finder = described_class.all(client: client)

      finder.each do |doc|
        expect(doc).to be_kind_of(described_class)
      end
    end
  end
end
