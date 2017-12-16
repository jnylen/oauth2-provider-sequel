module Songkick
  module OAuth2
    module Model

      module ResourceOwner
        def self.included(klass)
          plugin :association_proxies
          klass.one_to_many :oauth2_authorizations,
                      :class => Songkick::OAuth2::Model::Authorization.name,
                      :as => :oauth2_resource_owner,
                      :dependent => :destroy
        end

        def grant_access!(client, options = {})
          Songkick::OAuth2::Model::Authorization.for(self, client, options)
        end

        def oauth2_authorization_for(client)
          oauth2_authorizations.where(client_id: client.id).first
        end
      end

    end
  end
end
