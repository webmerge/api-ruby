# WebMerge Ruby

Manage and merge Documents using the WebMerge.me REST API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'web_merge'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install web_merge

## Usage

```ruby
config = {
  key: "N64EFIM0000000000000",
  secret: "ABCDEFGH"
}

api = WebMerge::API.new(config)

# Get Document List
api.get_documents
# => [{"id" => 1, "key" => "abcd", "type" => "pdf", ...}, ...]

# Get Single Document
api.get_document(30036)
# => {"id" => 1, "key" => "abcd", "type" => "pdf", ...}

# Merge Fields with Document
fields = {
  first_name: "John",
  last_name: "Doe",
}

api.merge_document(doc_id=10000, key="4y7e1h", fields, {test: 1})
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/web_merge/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
