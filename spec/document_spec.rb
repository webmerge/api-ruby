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

  describe '#save' do
    let(:client) { double(:client, create_document: response ) }
    context 'document is valid' do
      let(:response) do
        {
          "id":"234543",
          "key":"firm3",
          "type":"html",
          "name":"1040 EZ",
          "output":"pdf",
          "size":"",
          "size_width":"8.5",
          "size_height":"11",
          "active":"1",
          "url":"https://www.webmerge.me/merge/234543/firm3",
          "fields":[
            {"key":"aflekjf409t3j4mg30m409m", "name":"FirstName"},
            {"key":"3to3igj3g3gt94j9304jfqw", "name":"LastName"},
            {"key":"t43j0grjaslkfje304vj9we", "name":"Email"}
          ]
        }
      end

      let(:valid_document) do
        described_class.new(client: client, name: 'foo', type: 'docx')
      end

      it 'returns true' do
        expect(valid_document.save).to eq(true)
      end
    end
  end

  describe '#save!' do
    let(:client) { double(:client, create_document: response ) }
    context 'document is valid' do
      let(:response) do
        {
          "id":"234543",
          "key":"firm3",
          "type":"html",
          "name":"1040 EZ",
          "output":"pdf",
          "size":"",
          "size_width":"8.5",
          "size_height":"11",
          "active":"1",
          "url":"https://www.webmerge.me/merge/234543/firm3",
          "fields":[
            {"key":"aflekjf409t3j4mg30m409m", "name":"FirstName"},
            {"key":"3to3igj3g3gt94j9304jfqw", "name":"LastName"},
            {"key":"t43j0grjaslkfje304vj9we", "name":"Email"}
          ]
        }
      end

      let(:valid_document) do
        described_class.new(client: client, name: 'foo', type: 'docx')
      end

      it 'returns nil' do
        expect(valid_document.save!).to be_nil
      end
    end

    context 'document has merge field errors' do
      let(:response) do
        { 'error' => 'Error merging document: Syntax error in template...' }
      end
      let(:document_with_merge_field_errors) do
        described_class.new(client: client, name: 'foo', type: 'docx')
      end

      it 'raises an error upon document save error' do
        expect { document_with_merge_field_errors.save! }.to raise_error(WebMerge::DocumentError)
      end
    end
  end
end
