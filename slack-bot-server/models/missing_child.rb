class MissingChild
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  # original RSS data
  field :title, type: String
  field :description, type: String
  field :link, type: String
  field :published_at, type: DateTime

  field :caseNumber, type: String
  field :firstName, type: String
  field :lastName, type: String
  field :middleName, type: String
  field :missingCity, type: String
  field :missingState, type: String
  field :circumstance, type: String
  field :missingDate, type: Date
  field :altContact, type: String
  field :hasPhoto, type: Boolean, default: false

  SORT_ORDERS = ['created_at', '-created_at']

  def self.update!
    f = open('http://www.missingkids.org/missingkids/servlet/XmlServlet?act=rss&LanguageCountry=en_US&orgPrefix=NCMC')
    rss = SimpleRSS.parse(f)
    rss.items.each do |item|
      begin
        case_number = CGI.parse(URI.parse(item.link).query)['caseNum'][0]

        # existing record
        next if MissingChild.where(caseNumber: case_number).exists?

        # details
        detail_url = "http://www.missingkids.com/missingkids/servlet/JSONDataServlet?action=childDetail&orgPrefix=NCMC&caseNum=#{case_number}&seqNum=1&caseLang=en_US&searchLang=en_US&LanguageId=en_US"
        details_json = JSON.parse(open(URI.parse(detail_url)).read)

        unless details_json['status'] == 'success'
          Mongoid.logger.warn "Error retrieving details for #{item}: #{details_json['msg']} (#{detail_url})."
          next
        end

        details = details_json['childBean']
        next unless details

        missing_child = MissingChild.new(details)
        missing_child.title = item.title
        missing_child.published_at = item.pubDate
        missing_child.description = item.description
        missing_child.link = item.link

        missing_child.save!
        Mongoid.logger.info missing_child.to_s
      rescue StandardError => e
        Mongoid.logger.error "Error parsing #{item}!"
        Mongoid.logger.error e
      end
    end
  end

  def photo
    "http://www.missingkids.com/photographs/NCMC#{caseNumber}c1.jpg" if hasPhoto
  end

  def name
    [firstName, middleName, lastName].reject(&:blank?).join(' ')
  end

  def to_s
    "#{name} (#{missingCity}, #{missingState})"
  end
end
