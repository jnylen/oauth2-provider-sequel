module Sequel
  module Plugins
    module Oauth2ClientOwner
      # called when
      def self.configure(model, opts = {})
        model.instance_eval do
          one_to_many :oauth2_clients,
                      :class => 'Songkick::OAuth2::Model::Client',
                      :as => :oauth2_client_owner
        end
      end
    end
  end
end
