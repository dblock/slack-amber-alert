class MissingKid
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
  field :hasPhoto, type: Boolean
  field :hasAgedPhoto, type: Boolean
  field :hasExtraPhoto, type: Boolean
  field :possibleLocation, type: String
  field :orgPrefix, type: String
  field :seqNumber, type: Integer
  field :approxAge, type: String
  field :sex, type: String
  field :race, type: String
  field :birthDate, type: String
  field :height, type: Integer
  field :heightInInch, type: Boolean
  field :weight, type: Integer
  field :weightInPound, type: Boolean
  field :eyeColor, type: String
  field :hairColor, type: String
  field :hasThumbnail, type: String
  field :hasPoster, type: String
  field :caseType, type: String
  field :missingCounty, type: String
  field :missingProvince, type: String
  field :missingCountry, type: String
  field :profileNarrative, type: String
  field :orgName, type: String
  field :orgContactInfo, type: String
  field :isClearinghouse, type: Boolean
  field :isKid, type: Boolean
  field :age, type: Integer

  SORT_ORDERS = ['created_at', '-created_at'].freeze

  def self.update!
    f = open('http://www.missingkids.org/missingkids/servlet/XmlServlet?act=rss&LanguageCountry=en_US&orgPrefix=NCMC')
    rss = SimpleRSS.parse(f)
    rss.items.each do |item|
      begin
        case_number = CGI.parse(URI.parse(item.link).query)['caseNum'][0]

        # existing record
        next if MissingKid.where(caseNumber: case_number).exists?

        # details
        detail_url = "http://www.missingkids.com/missingkids/servlet/JSONDataServlet?action=childDetail&orgPrefix=NCMC&caseNum=#{case_number}&seqNum=1&caseLang=en_US&searchLang=en_US&LanguageId=en_US"
        details_json = JSON.parse(open(URI.parse(detail_url)).read)

        unless details_json['status'] == 'success'
          Mongoid.logger.warn "Error retrieving details for #{item}: #{details_json['msg']} (#{detail_url})."
          next
        end

        details = details_json['childBean']
        next unless details

        missing_kid = MissingKid.new(details)
        missing_kid.title = item.title
        missing_kid.published_at = item.pubDate
        missing_kid.description = item.description
        missing_kid.link = item.link

        missing_kid.save!
        Mongoid.logger.info missing_kid.to_s
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
