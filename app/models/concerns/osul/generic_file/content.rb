module Osul
  module GenericFile
    module Content
      extend ActiveSupport::Concern

      included do
        contains 'low_resolution'
      end

    end
  end
end