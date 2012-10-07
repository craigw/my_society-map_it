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
      LOCAL_AUTHORITY_TYPE_CODES = %w(
	DIS MTD UTA LBO CTY LGD
      ).map { |c| c.freeze }.freeze

      def local_authority
        local_authority_info = to_point.to_hash.values.sort_by { |a|
          LOCAL_AUTHORITY_TYPE_CODES.index(a['type']) || -1
        }.detect do |la|
	  LOCAL_AUTHORITY_TYPE_CODES.include? la['type']
	end

        LocalAuthority.new local_authority_info
      rescue
        nil
      end
    end

    class LocalAuthority
      attr_accessor :attributes
      private :attributes=, :attributes

      def initialize attributes
        self.attributes = attributes
      end

      def name
        attributes['name']
      end

      def id
        attributes['id']
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
