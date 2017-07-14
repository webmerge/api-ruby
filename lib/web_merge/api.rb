module WebMerge
  class API

    def initialize(options={})
      @api_secret = options[:secret] || ENV['WEB_MERGE_API_SECRET']
      @api_key = options[:key] || ENV['WEB_MERGE_API_KEY']
      @force_test_mode = options[:force_test_mode] || ENV['WEB_MERGE_FORCE_TEST_MODE']
      @verbose = options[:verbose] || false
    end

    #
    # DOCUMENTS
    #
    def create_document(form_data, &block)
      post("#{WebMerge::Constants::DOCUMENTS}", form_data, &block)
    end

    def update_document(doc_id, form_data, &block)
      put("#{WebMerge::Constants::DOCUMENTS}/#{doc_id}", form_data, &block)
    end

    def delete_document(doc_id, &block)
      delete("#{WebMerge::Constants::DOCUMENTS}/#{doc_id}", &block)
    end

    def get_documents(&block)
      get("#{WebMerge::Constants::DOCUMENTS}", &block)
    end

    def get_document(doc_id, &block)
      get("#{WebMerge::Constants::DOCUMENTS}/#{doc_id}", &block)
    end

    def get_document_fields(doc_id, &block)
      get("#{WebMerge::Constants::DOCUMENTS}/#{doc_id}/fields", &block)
    end

    def get_document_file(doc_id, &block)
      get("#{WebMerge::Constants::DOCUMENTS}/#{doc_id}/file", &block)
    end

    # doc_id	The Document ID
    #   example: 436346
    # doc_key	The Document Key
    #   example: firm3
    # field_mappings	The data to be merged in name/value pairs
    #   example: { name: "John Smith", occupation: "Plumber" }
    #
    # options[:test] Merges the document in "test mode"
    #   default: false.
    # options[:download] Will return the merged document in response
    #   default: false
    # options[:flatten] Will return the merged document flattened (with no editing capabilities)
    #   default: 0
    #
    def merge_document(doc_id, doc_key, field_mappings, options = {}, &block)
      query = ""
      if options.present?
        query = "?" + URI.encode(options.map{|k,v| "#{k}=#{v}"}.join("&"))
      end
      post("#{WebMerge::Constants::MERGE_ENDPOINT}/#{doc_id}/#{doc_key}#{query}", field_mappings, &block)
    end

    #
    # ROUTES
    #
    def get_routes(&block)
      get("#{WebMerge::Constants::ROUTES}", &block)
    end

    def get_route(route_id, &block)
      get("#{WebMerge::Constants::ROUTES}/#{route_id}", &block)
    end

    def get_route_fields(route_id, &block)
      get("#{WebMerge::Constants::ROUTES}/#{route_id}/fields", &block)
    end

    def merge_route(route_id, route_key, field_mappings, options = {}, &block)
      post("#{WebMerge::Constants::ROUTE_ENDPOINT}/#{route_id}/#{route_key}?download=#{download(options)}&test=#{test(options)}", field_mappings, &block)
    end

    # internal helpers
    def post(url_string, form_data, &block)
      request("post", url_string, form_data, &block)
    end

    def put(url_string, form_data, &block)
      request("put", url_string, form_data, &block)
    end

    def delete(url_string, &block)
      request("delete", url_string, &block)
    end

    def get(url_string, &block)
      request("get", url_string, &block)
    end

    def request(verb, url_string, form_data = nil, &block)
      parsed_response_body = nil
      uri = URI.parse(url_string)
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        action_klass = "Net::HTTP::#{verb.camelize}".constantize
        request = action_klass.new(uri.request_uri, 'Content-Type' => 'application/json')
        request.basic_auth(@api_key, @api_secret)
        request.body = form_data.to_json if form_data.present?
        http.request(request) do |response|
          if block_given?
            return block.call(response)
          else
            begin
              parsed_response_body = JSON.parse(response.body)
            rescue
              parsed_response_body = "Unable to parse response body as JSON perhaps you'd like to pass a block to process the response?"
              parsed_response_body << "#{response.body}"
            end
          end
        end
      end
      parsed_response_body
    end

    def download(options)
      options[:download] && true?(options[:download]) ? 1 : 0
    end

    def test(options)
      true?(@force_test_mode) || (options[:test] && true?(options[:test])) ? 1 : 0
    end

    def true?(value)
      value.to_s.match(/(true|t|yes|y|1)$/i).present?
    end
  end
end
