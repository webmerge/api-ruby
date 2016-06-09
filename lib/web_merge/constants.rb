module WebMerge
  class Constants
    WEB_MERGE = "https://www.webmerge.me"

    API_ENDPOINT = "#{WEB_MERGE}/api"

    MERGE_ENDPOINT = "#{WEB_MERGE}/merge"
    ROUTE_ENDPOINT = "#{WEB_MERGE}/route"

    DOCUMENTS = "#{API_ENDPOINT}/documents"

    ROUTES = "#{API_ENDPOINT}/routes"

    API_SECRET = ENV['WEB_MERGE_API_SECRET']
    API_KEY = ENV['WEB_MERGE_API_KEY']

    FORCE_TEST_MODE = ENV['WEB_MERGE_FORCE_TEST_MODE']

    PDF = 'pdf'
    HTML = 'html'
    DOCX = 'docx'
    EMAIL = 'email'
    PPTX = 'pptx'
    XLSX = 'xlsx'

    SECURITY_LEVEL_LOW = 'low'
    SECURITY_LEVEL_MEDIUM = 'medium'
    SECURITY_LEVEL_HIGH = 'high'

    SUPPORTED_TYPES = [HTML, PDF, DOCX, PPTX, XLSX]
    SUPPORTED_OUTPUTS = [PDF, DOCX, EMAIL, PPTX, XLSX]

    SECURITY_LEVELS = [SECURITY_LEVEL_LOW, SECURITY_LEVEL_MEDIUM, SECURITY_LEVEL_HIGH]
  end
end
