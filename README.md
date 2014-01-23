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

## Configuring
You can configure several options, which you pass in to the `provider` method via a `Hash`:

- `title`: title for the `request_phase` form; defaults to `Aleph Authentication`
- `scheme`: scheme for your Aleph X-Server as a String; defaults to `http`
- `host`: host name for your Aleph X-Server as a String; required
- `port`: port for your Aleph X-Server as an Integer; defaults to `80`
- `library`: Aleph administrative library for authentication; required
- `sub_library`: Aleph sub library for authentication; required

## Auth Hash
Here's an example _Auth Hash_ available in `request.env['omniauth.auth']`:

    {
      :provider => 'aleph',
      :uid => 'USERNAME',
      :info => {
        :name => "USERNAME, TEST-RECORD",
        :nickname => "USERNAME",
        :email => "username@library.edu",
        :phone => nil
      },
      :credentials => {},
      :extra => {
        :raw_info => {
          :bor_auth => {
            :z303 => {
              :z303_id => "USERNAME",
              :z303_proxy_for_id => nil,
              :z303_primary_id => nil,
              :z303_name_key => "username test record                     USERNAME",
              :z303_user_type => nil,
              :z303_user_library => nil,
              :z303_open_date => "09/30/2013",
              :z303_update_date => "10/26/2013",
              :z303_con_lng => "ENG",
              :z303_alpha => "L",
              :z303_name => "USERNAME, TEST-RECORD",
              :z303_title => nil,
              :z303_delinq_1 => "00",
              :z303_delinq_n_1 => nil,
              :z303_delinq_1_update_date => "00000000",
              :z303_delinq_1_cat_name => nil,
              :z303_delinq_2 => "00",
              :z303_delinq_n_2 => nil,
              :z303_delinq_2_update_date => "00000000",
              :z303_delinq_2_cat_name => nil,
              :z303_delinq_3 => "00",
              :z303_delinq_n_3 => nil,
              :z303_delinq_3_update_date => "00000000",
              :z303_delinq_3_cat_name => nil,
              :z303_budget => nil,
              :z303_profile_id => nil,
              :z303_ill_library => nil,
              :z303_home_library => "Home Library",
              :z303_field_1 => nil,
              :z303_field_2 => nil,
              :z303_field_3 => nil,
              :z303_note_1 => nil,
              :z303_note_2 => nil,
              :z303_salutation => nil,
              :z303_ill_total_limit => "0000",
              :z303_ill_active_limit => "0000",
              :z303_dispatch_library => nil,
              :z303_birth_date => nil,
              :z303_export_consent => "Y",
              :z303_proxy_id_type => "00",
              :z303_send_all_letters => "Y",
              :z303_plain_html => "P",
              :z303_want_sms => nil,
              :z303_plif_modification => nil,
              :z303_title_req_limit => "0000",
              :z303_gender => nil,
              :z303_birthplace => nil},
            :z304 => {
              :z304_id => "USERNAME",
              :z304_sequence => "02",
              :z304_address_0 => "USERNAME, TEST-RECORD",
              :z304_address_1 => "100 Testing Lane",
              :z304_address_2 => "Testing Town",
              :z304_address_3 => "NY",
              :z304_zip => "10012",
              :z304_email_address => "username@library.edu",
              :z304_telephone => nil,
              :z304_date_from => "20100101",
              :z304_date_to => "20201231",
              :z304_address_type => "02",
              :z304_telephone_2 => nil,
              :z304_telephone_3 => nil,
              :z304_telephone_4 => nil,
              :z304_sms_number => nil,
              :z304_update_date => "20131026",
              :z304_cat_name => "BATCH"
            },
            :z305 => {
              :z305_id => "USERNAME",
              :z305_sub_library => "SUB",
              :z305_open_date => "09/30/2013",
              :z305_update_date => "10/26/2013",
              :z305_bor_type => nil,
              :z305_bor_status => "Adjunct Faculty",
              :z305_registration_date => "00000000",
              :z305_expiry_date => "12/31/2020",
              :z305_note => nil,
              :z305_loan_permission => "Y",
              :z305_photo_permission => "N",
              :z305_over_permission => "Y",
              :z305_multi_hold => "N",
              :z305_loan_check => "Y",
              :z305_hold_permission => "Y",
              :z305_renew_permission => "Y",
              :z305_rr_permission => "N",
              :z305_ignore_late_return => "N",
              :z305_last_activity_date => nil,
              :z305_photo_charge => "F",
              :z305_no_loan => "0000",
              :z305_no_hold => "0000",
              :z305_no_photo => "0000",
              :z305_no_cash => "0000",
              :z305_cash_limit => "5.00",
              :z305_credit_debit => nil,
              :z305_sum => "0.00",
              :z305_delinq_1 => "00",
              :z305_delinq_n_1 => nil,
              :z305_delinq_1_update_date => "00000000",
              :z305_delinq_1_cat_name => nil,
              :z305_delinq_2 => "00",
              :z305_delinq_n_2 => nil,
              :z305_delinq_2_update_date => "00000000",
              :z305_delinq_2_cat_name => nil,
              :z305_delinq_3 => "00",
              :z305_delinq_n_3 => nil,
              :z305_delinq_3_update_date => "00000000",
              :z305_delinq_3_cat_name => nil,
              :z305_field_1 => nil,
              :z305_field_2 => nil,
              :z305_field_3 => nil,
              :z305_hold_on_shelf => "N",
              :z305_end_block_date => nil,
              :z305_booking_permission => "N",
              :z305_booking_ignore_hours => "N",
              :z305_rush_cat_request => "N"
            },
            :session_id => "B3S4C6Y7DLQCA41NAYH1BQHLU6F24AKJRRSPRTF99FXECEUMIS"
          }
        }
      }
    }