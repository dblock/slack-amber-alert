Fabricator(:missing_child) do |_record|
  name { Faker::Name.name }
  state { Faker::Address.state_abbr }
  status 'Missing'
  published_at { Time.now.utc }
  after_build do
    self.title = "Missing: #{name} (#{state})"
    self.description = "#{name}, Age Now: 16, #{status}: 03/07/2016. Missing from LEANDER, #{state}. ANYONE HAVING INFORMATION SHOULD CONTACT: Leander Police Department (Texas) 1-512-528-2800."
  end
  link 'http://www.missingkids.com/missingkids/servlet/PubCaseSearchServlet?act=viewChildDetail&amp;LanguageCountry=en_US&amp;searchLang=en_US&amp;caseLang=en_US&amp;orgPrefix=NCMC&amp;caseNum=1264275&amp;seqNum=1'
end
