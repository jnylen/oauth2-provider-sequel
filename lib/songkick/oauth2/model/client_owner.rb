module Songkick
  module OAuth2
    module Model

      module ClientOwner
        def self.included(klass)
          klass.one_to_many :oauth2_clients,
                      :class => 'Songkick::OAuth2::Model::Client',
                      :as => :oauth2_client_owner
        end
      end

    end
  end
end
