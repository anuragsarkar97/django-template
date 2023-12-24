#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH << '.'
$LOAD_PATH << File.join(__dir__, '../lib')
$LOAD_PATH << File.join(__dir__, '../ext')

require 'active_support'
require 'json'
require 'oj'

Oj.mimic_JSON()
# Oj::Rails.mimic_JSON()

begin
  ::JSON.parse('{ "foo": 84e }')
  #::JSON.parse('{ "foo": 84eb234 }')
rescue Exception => e
  puts "#{e.class}: #{e.message}"
end
