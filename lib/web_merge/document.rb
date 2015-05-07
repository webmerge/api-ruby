module WebMerge
  class Document
    include ::ActiveModel::Validations

    attr_accessor :name, :type, :output, :output_name, :size_width, :size_height, :notification, :file_path
    attr_reader :id, :key, :size, :active, :url

    validates_presence_of :name, :type, :output
    validates_presence_of :file_path
    validates :type, inclusion: { in: WebMerge::Constants::SUPPORTED_TYPES }
    validates :output, inclusion: { in: WebMerge::Constants::SUPPORTED_OUTPUTS }

    def initialize(name: required(:name), type: required(:type), output: WebMerge::Constants::PDF, file_path: nil, options: {})
      @name = name
      @type = type
      @output = output
      @file_path = file_path
      @output_name = options[:output_name]
      @size_width = options[:size_width]
      @size_height = options[:size_height]
    end

    def self.find(doc_id)
      instance = empty_instance
      instance.send(:id=, doc_id)
      instance.reload
    end

    def self.each
      all.each do |doc|
        yield doc if block_given?
      end
    end

    def self.all
      WebMerge::API.get_documents.map do |doc_hash|
        instance = empty_instance
        instance.send(:update_instance, doc_hash)
        instance
      end
    end

    def html?
      type == WebMerge::Constants::HTML
    end

    def new_document?
      id.blank?
    end

    def save
      return false unless valid?
      response = if new_document?
        WebMerge::API.create_document(as_form_data)
      else
        WebMerge::API.update_document(id, as_form_data)
      end
      update_instance(response.symbolize_keys)
      true
    end

    def save!
      raise "Document contains errors: #{errors.full_messages.join(", ")}" unless save
    end

    def reload
      raise "Cannot reload a new document, perhaps you'd like to call `save' first?" if new_document?
      response = WebMerge::API.get_document(id)
      update_instance(response)
      self
    end

    def delete
      delete = false
      WebMerge::API.delete_document(id) { |response| delete = JSON(response.body)["success"] } unless new_document?
      delete
    end

    def fields
      raise "Cannot fetch fields for an unpersisted document, perhaps you'd like to call `save' first?" if new_document?
      @fields ||= WebMerge::API.get_document_fields(id)
    end

    def field_names
      fields.map { |field| field["name"] }
    end

    def merge(field_mappings, options = {}, &block)
      raise "Cannot merge an unpersisted document, perhaps you'd like to call `save' first?" if new_document?
      WebMerge::API.merge_document(id, key, field_mappings, options, &block)
    end

    def as_form_data
      request_params = {
        name: name,
        type: type,
        output: output
      }
      [:output_name, :size_width, :size_height].each do |key|
        value = send(key)
        request_params.merge!(key => value) if value.present?
      end
      merge_file_contents!(request_params)
      merge_notification!(request_params) if notification.present?
      request_params
    end

    private
    attr_writer :id, :key, :size, :active, :url

    def self.empty_instance
      new(name: "", type: "", output: "")
    end

    def update_instance(response)
      response.each_pair do |key, value|
        send("#{key}=".to_sym, value) if respond_to?("#{key}=".to_sym, true)
      end
    end

    def merge_file_contents!(request_params)
      if html?
        html_string = IO.binread(file_path)
        request_params.merge!(html: html_string)
      else
        encoded = Base64.encode64(IO.binread(file_path))
        request_params.merge!(file_contents: encoded)
      end
      request_params
    end

    def merge_notification!(request_params)
      notification.as_form_data.each_pair do |key, value|
        request_params.merge!("notification[#{key}]" => value)
      end
    end

  end
end
