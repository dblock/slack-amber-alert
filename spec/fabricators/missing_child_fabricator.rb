Fabricator(:missing_child) do |_record|
  caseNumber { Faker::Number.number(6) }
  firstName { Faker::Name.first_name }
  middleName ''
  lastName { Faker::Name.last_name }
  published_at { Time.now.utc }
  missingCity { Faker::Address.city }
  missingState { Faker::Address.state_abbr }
  missingDate { 1.week.ago.to_date }
  hasPhoto true
  link { 'http://www.missingkids.com/missingkids/servlet/PubCaseSearchServlet?act=viewChildDetail&amp;LanguageCountry=en_US&amp;searchLang=en_US&amp;caseLang=en_US&amp;orgPrefix=NCMC&amp;caseNum=123&amp;seqNum=1' }
  altContact "Manatee County Sheriff's Office (Florida) 1-941-747-3011"
  circumstance 'They may still be in the local area.'
end
