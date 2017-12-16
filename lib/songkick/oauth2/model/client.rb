module Songkick
  module OAuth2
    module Model

      class Client < Sequel::Model(:oauth2_clients)
        plugin :polymorphic
        plugin :validation_helpers
        plugin :active_model
        plugin :hook_class_methods
        plugin :finder
        plugin :association_proxies

        many_to_one :oauth2_client_owner, :polymorphic => true
        alias :owner  :oauth2_client_owner
        alias :owner= :oauth2_client_owner=

        one_to_many :authorizations, :class => 'Songkick::OAuth2::Model::Authorization', :dependent => :destroy



        def validate
          super
          validates_presence [:name, :redirect_uri]
          validates_unique :client_id, :name
          check_format_of_redirect_uri
        end

        before_create :generate_credentials

        def self.create_client_id
          Songkick::OAuth2.generate_id do |client_id|
            Helpers.count(self, :client_id => client_id).zero?
          end
        end

        attr_reader :client_secret

        def client_secret=(secret)
          @client_secret = secret
          hash = BCrypt::Password.create(secret)
          hash.force_encoding('UTF-8') if hash.respond_to?(:force_encoding)
          self.client_secret_hash = hash
        end

        def valid_client_secret?(secret)
          BCrypt::Password.new(client_secret_hash) == secret
        end

      private

        def check_format_of_redirect_uri
          uri = URI.parse(redirect_uri)
          errors.add(:redirect_uri, 'must be an absolute URI') unless uri.absolute?
        rescue
          errors.add(:redirect_uri, 'must be a URI')
        end

        def generate_credentials
          self.client_id = self.class.create_client_id
          self.client_secret = Songkick::OAuth2.random_string
        end
      end

    end
  end
end
