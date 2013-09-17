# MySociety::MapIt

Interact with the MySociety MapIt service.


## Installation

Add this line to your application's Gemfile:

    gem 'my_society-map_it'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install my_society-map_it


## Usage

    require 'my_society/map_it'
    p = MySociety::MapIt::Postcode.new 'SE1 1EY'
    p.two_tier? # => false
    la = p.local_authority
    la.name # => "Southwark Borough Council"
    
    p = MySociety::MapIt::Postcode.new 'B46 3LD'
    p.two_tier? # => true
    la = p.local_authority
    la[:district].name # => "North Warwickshire Borough Council"
    la[:county].name # => "Warwickshire County Council"

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
