# OmniAuth Aleph
[![Gem Version](https://badge.fury.io/rb/omniauth-aleph.png)](http://badge.fury.io/rb/omniauth-aleph)
[![Build Status](https://api.travis-ci.org/scotdalton/omniauth-aleph.png?branch=master)](https://travis-ci.org/scotdalton/omniauth-aleph)
[![Dependency Status](https://gemnasium.com/scotdalton/omniauth-aleph.png)](https://gemnasium.com/scotdalton/omniauth-aleph)
[![Code Climate](https://codeclimate.com/github/scotdalton/omniauth-aleph.png)](https://codeclimate.com/github/scotdalton/omniauth-aleph)
[![Coverage Status](https://coveralls.io/repos/scotdalton/omniauth-aleph/badge.png?branch=master)](https://coveralls.io/r/scotdalton/omniauth-aleph)

Aleph patron login strategy for OmniAuth.

## Installation
Add to your Gemfile:

    gem 'omniauth-aleph'

Then `bundle install`.

## Usage
`OmniAuth::Strategies::Aleph` simply makes a call to the Aleph bor_auth X-Service and
returns the attributes from the returned XML.

Use the Aleph strategy as a middleware in your application:

    use OmniAuth::Strategies::Aleph, title: 'My Library's Aleph', 
      host: 'aleph.library.edu', port: 80, library: 'ADM50', sub_library: 'SUB'

