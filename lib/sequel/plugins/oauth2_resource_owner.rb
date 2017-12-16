module Sequel
  module Plugins
    module Oauth2ResourceOwner
      # called when
      def self.configure(model, opts = {})
        model.instance_eval do
          plugin :finder
          plugin :association_proxies

          one_to_many :oauth2_authorizations,
                      :class => Songkick::OAuth2::Model::Authorization,
                      :as => :oauth2_resource_owner,
                      :dependent => :destroy
        end
      end

      module InstanceMethods
        def grant_access!(client, options = {})
          Songkick::OAuth2::Model::Authorization.for(self, client, options)
        end

        def oauth2_authorization_for(client)
          b = oauth2_authorizations.where(client_id: client.pk).first rescue nil
          b
        end
      end
    end
  end
end
