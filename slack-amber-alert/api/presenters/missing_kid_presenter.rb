module Api
  module Presenters
    module MissingKidPresenter
      include Roar::JSON::HAL
      include Roar::Hypermedia
      include Grape::Roar::Representer

      property :id, type: String, desc: 'Missing Kid ID.'
      property :title, type: String, desc: 'Missing kid record title.'
      property :description, type: String, desc: 'Missing kid description.'

      # from missingkids.org
      property :caseNumber, as: :case_number, type: String
      property :firstName, as: :first_name, type: String
      property :lastName, as: :last_name, type: String
      property :middleName, as: :middle_name, type: String
      property :missingCity, as: :missing_city, type: String
      property :missingState, as: :missing_state, type: String
      property :circumstance, as: :circumstance, type: String
      property :missingDate, as: :missing_date, type: Date
      property :altContact, as: :alt_contact, type: String
      property :possibleLocation, as: :possible_location, type: String
      property :orgPrefix, as: :org_prefix, type: String
      property :seqNumber, as: :seq_number, type: Integer
      property :approxAge, as: :approx_age, type: String
      property :sex, as: :sex, type: String
      property :race, as: :race, type: String
      property :birthDate, as: :birth_date, type: Date
      property :height, as: :height, type: Integer
      property :height_units, type: String
      property :weight, type: Integer
      property :weight_units, type: String
      property :eyeColor, as: :eye_color, type: String
      property :hairColor, as: :hair_color, type: String
      property :caseType, as: :case_type, type: String
      property :missingCounty, as: :missing_county, type: String
      property :missingProvince, as: :missing_province, type: String
      property :missingCountry, as: :missing_country, type: String
      property :profileNarrative, as: :profile_narrative, type: String
      property :orgName, as: :org_name, type: String
      property :orgContactInfo, as: :org_contact_info, type: String
      property :isClearinghouse, as: :is_clearing_house, type: Boolean
      property :isKid, as: :is_kid, type: Boolean
      property :age, as: :age, type: Integer

      property :published_at, type: DateTime, desc: 'Date/time when the record was published in the registry of missing kids.'
      property :created_at, type: DateTime, desc: 'Date/time when the record was created.'
      property :updated_at, type: DateTime, desc: 'Date/time when the record was updated.'

      link :poster do
        represented.link
      end

      link :photo do
        photo
      end

      link :self do |opts|
        request = Grape::Request.new(opts[:env])
        "#{request.base_url}/api/missing_kids/#{id}"
      end

      def height_units
        represented.heightInInch ? 'in' : 'cm'
      end

      def weight_units
        represented.weightInPound ? 'lbs' : 'kg'
      end
    end
  end
end
