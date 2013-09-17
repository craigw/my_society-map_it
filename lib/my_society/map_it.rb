require "my_society/map_it/version"
require "json"
require "net/http"
require "uri"

module MySociety
  module MapIt
    def self.base_url
      "http://mapit.mysociety.org"
    end

    module UriToHash
      def to_hash
        u = URI.parse uri
        r = Net::HTTP.get_response u
        JSON.parse r.body
      end
    end

    module LocalAuthorityFinder
      DISTRICT_TYPE_CODES = %w(
        DIS LGD
      ).freeze
      
      UNITARY_TYPE_CODES = %w(
        UTA MTD LBO COI
      ).freeze
      
      COUNTY_TYPE_CODES = %w(
        CTY
      ).freeze
      
      COUNTY_WARD_TYPE_CODES = %w(
        CED
      )
      
      PARISH_TYPE_CODES = %w(
        CPC COP
      )
      
      WARD_TYPE_CODES = %w(
        DIW LBW LGW MTW UTW
      )
      
      def district
        detect(DISTRICT_TYPE_CODES)
      end
      
      def parish
        detect(PARISH_TYPE_CODES)
      end
      
      def county
        return if district.nil?
        detect(COUNTY_TYPE_CODES)
      end
      
      def county_ward
        return if county.nil?
        detect(COUNTY_WARD_TYPE_CODES)
      end
      
      def unitary
        detect(UNITARY_TYPE_CODES)
      end
      
      def ward
        detect(WARD_TYPE_CODES)
      end

      def local_authority
        if district.nil?
          unitary
        else
          {
            :district => district,
            :county   => county
          }
        end
      rescue
        nil
      end
      
      def detect(type)
        la = to_point.to_hash.values.detect do |la|
	        type.include? la['type']
	      end
	      
	      return if la.nil?
	      
	      LocalAuthority.new la
      rescue
        nil
      end
      
      def two_tier?
        local_authority.kind_of? Hash
      end
    end

    class LocalAuthority
      attr_accessor :attributes
      private :attributes=, :attributes

      def self.find uri
        u = URI.parse uri
        r = Net::HTTP.get_response u
        new JSON.parse r.body
      end

      def initialize attributes
        self.attributes = attributes
      end

      def name
        attributes['name']
      end

      def id
        attributes['id']
      end

      def uri
        [ MySociety::MapIt.base_url, 'area', id ].join '/'
      end
    end

    class Point
      include LocalAuthorityFinder
      include UriToHash

      SYSTEM_WGS84 = 4326
      SYSTEM_IRISH_NATIONAL_GRID = 29902
      SYSTEM_BRITISH_NATIONAL_GRID = 27700

      attr_accessor :x
      private :x=

      attr_accessor :y
      private :y=

      attr_accessor :coordinate_system
      private :coordinate_system=

      def initialize x, y, coordinate_system = SYSTEM_WGS84
        self.x = x
        self.y = y
        self.coordinate_system = coordinate_system
      end

      def uri
        "#{MySociety::MapIt.base_url}/point/#{coordinate_system}/#{x},#{y}"
      end

      def to_point
        self
      end
    end

    class Postcode
      include LocalAuthorityFinder
      include UriToHash

      attr_accessor :postcode
      private :postcode=

      def initialize postcode
        self.postcode = postcode
      end

      def normalised_postcode
        postcode.upcase.gsub /\s+/, ''
      end

      def uri
        "#{MySociety::MapIt.base_url}/postcode/#{normalised_postcode}"
      end

      def to_point
        h = to_hash.dup
        Point.new h['wgs84_lon'], h['wgs84_lat'], Point::SYSTEM_WGS84
      end
    end
  end
end
