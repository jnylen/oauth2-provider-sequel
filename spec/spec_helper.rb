require 'rubygems'
require 'bundler/setup'
require 'as-duration'

require 'dotenv'
Dotenv.load(File.expand_path('../../.env.test', __FILE__))

require File.dirname(__FILE__) + '/sequel_setup'

RSpec.configure do |config|
  # to run only specific specs, add :focus to the spec
  #   describe "foo", :focus do
  # OR
  #   it "should foo", :focus do
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
  config.expect_with(:rspec) { |c| c.syntax = :should }

  config.before do
    Songkick::OAuth2::Provider.enforce_ssl = false
    time = Time.now
    Time.stub(:now).and_return time
  end

  config.after do
    [ :oauth2_clients, :oauth2_authorizations,
      :users
    ].each { |k| DB[k].delete }
  end
end

require 'songkick/oauth2/provider'

require 'test_app/provider/application'
require 'request_helpers'
require 'factories'

require 'thin'
Thin::Logging.silent = true
$VERBOSE = nil

def create_authorization(params)
  Songkick::OAuth2::Model::Authorization.__send__(:create) do |authorization|
    params.each do |key, value|
      authorization.__send__ "#{key}=", value
    end
  end
end
