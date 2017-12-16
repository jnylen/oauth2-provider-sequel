module Songkick
  module OAuth2
    module Model

      class Authorization < Sequel::Model(:oauth2_authorizations)
        plugin :polymorphic
        plugin :validation_helpers
        plugin :active_model
        plugin :finder
        plugin :association_proxies

        many_to_one :oauth2_resource_owner, :polymorphic => true
        alias :owner  :oauth2_resource_owner
        alias :owner= :oauth2_resource_owner=

        many_to_one :client, :class => 'Songkick::OAuth2::Model::Client'

        def validate
          super
          validates_presence [:client, :owner]
          validates_unique :access_token_hash, allow_nil: true
          validates_unique :code, allow_nil: true #,               :scope => :client_id
          validates_unique :refresh_token_hash, allow_nil: true #, :scope => :client_id
        end

        class << self
          private :create, :new
        end

        extend Hashing
        hashes_attributes :access_token, :refresh_token

        def self.create_code(client)
          Songkick::OAuth2.generate_id do |code|
            Helpers.count(client.authorizations, :code => code).zero?
          end
        end

        def self.create_access_token
          Songkick::OAuth2.generate_id do |token|
            hash = Songkick::OAuth2.hashify(token)
            Helpers.count(self, :access_token_hash => hash).zero?
          end
        end

        def self.create_refresh_token(client)
          Songkick::OAuth2.generate_id do |refresh_token|
            hash = Songkick::OAuth2.hashify(refresh_token)
            Helpers.count(client.authorizations, :refresh_token_hash => hash).zero?
          end
        end

        def self.for(owner, client, attributes = {})
          return nil unless owner and client

          unless client.is_a?(Client)
            raise ArgumentError, "The argument should be a #{Client}, instead it was a #{client.class}"
          end

          instance = owner.oauth2_authorization_for(client) ||
                     new do |authorization|
                       authorization.owner  = owner
                       authorization.client = client
                     end

          case attributes[:response_type]
            when CODE
              instance.code ||= create_code(client)
            when TOKEN
              instance.access_token  ||= create_access_token
              instance.refresh_token ||= create_refresh_token(client)
            when CODE_AND_TOKEN
              instance.code = create_code(client)
              instance.access_token  ||= create_access_token
              instance.refresh_token ||= create_refresh_token(client)
          end

          if attributes[:duration]
            instance.expires_at = Time.now + attributes[:duration].to_i
          else
            instance.expires_at = nil
          end

          scopes = instance.scopes + (attributes[:scopes] || [])
          scopes += attributes[:scope].split(/\s+/) if attributes[:scope]
          instance.scope = scopes.empty? ? nil : scopes.entries.join(' ')

          instance.save && instance

        rescue Object => error
          if Model.duplicate_record_error?(error)
            retry
          else
            raise error
          end
        end

        def exchange!
          self.code          = nil
          self.access_token  = self.class.create_access_token
          self.refresh_token = nil
          save
        end

        def expired?
          return false unless expires_at
          expires_at < Time.now
        end

        def expires_in
          expires_at && (expires_at - Time.now).ceil
        end

        def generate_code
          self.code ||= self.class.create_code(client)
          save && code
        end

        def generate_access_token
          self.access_token ||= self.class.create_access_token
          save && access_token
        end

        def grants_access?(user, *scopes)
          not expired? and user == owner and in_scope?(scopes)
        end

        def in_scope?(request_scope)
          [*request_scope].all?(&scopes.method(:include?))
        end

        def scopes
          scopes = scope ? scope.split(/\s+/) : []
          Set.new(scopes)
        end
      end

    end
  end
end
