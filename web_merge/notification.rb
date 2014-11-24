module WebMerge
  class Notification
    include ActiveModel::Validations

    attr_accessor :to, :from, :subject, :html, :security, :password

    validates_presence_of :to, :from
    validates_format_of :to, :from, :with => /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i
    validates_presence_of :password, if: :requires_password?
    validates :security, inclusion: { in: WebMerge::Constants::SECURITY_LEVELS }

    def initialize(to: required(:to), from: required(:from), subject: "WebMerge Notification", security: WebMerge::Constants::SECURITY_LEVEL_LOW, html: nil, password: nil)
      @to = to
      @from = from
      @subject = subject
      @security = security
      @html = html
      @password = password
    end

    def requires_password?
      security == WebMerge::Constants::SECURITY_LEVEL_MEDIUM || security == WebMerge::Constants::SECURITY_LEVEL_HIGH
    end

    def as_form_data
      request_params = {
        to: to,
        from: from,
        subject: subject,
        html: html,
        security: security
      }
      request_params.merge!(password: password) if requires_password?
      request_params
    end

  end
end
