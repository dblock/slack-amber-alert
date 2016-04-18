class MissingChild
  include Mongoid::Document
  include Mongoid::Timestamps

  # original RSS data
  field :title, type: String
  field :description, type: String
  field :link, type: String
  field :published_at, type: DateTime

  # parsed
  field :status, type: String
  field :name, type: String
  field :state, type: String

  SORT_ORDERS = ['created_at', '-created_at']

  def self.update!
    f = open('http://www.missingkids.org/missingkids/servlet/XmlServlet?act=rss&LanguageCountry=en_US&orgPrefix=NCMC')
    rss = SimpleRSS.parse(f)
    rss.items.each do |item|
      begin
        missing_child = MissingChild.where(title: item.title, published_at: item.pubDate).first
        missing_child ||= MissingChild.new(title: item.title, published_at: item.pubDate)
        missing_child.description = item.description
        missing_child.link = item.link
        title_data = missing_child.title.match(/^(?<status>[\w]*):\s(?<name>.*)\s\((?<state>[A-Z]*)\)$/)
        missing_child.status = title_data[:status]
        missing_child.name = title_data[:name]
        missing_child.state = title_data[:state]
        next unless missing_child.changed?
        missing_child.save!
        Mongoid.logger.info missing_child.to_s
      rescue StandardError => e
        Mongoid.logger.error "Error parsing #{item}!"
        Mongoid.logger.error e
      end
    end
  end

  def to_s
    "#{status}: #{name} (#{state})"
  end
end
