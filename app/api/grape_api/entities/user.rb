class GrapeApi
    module Entities
      class User < Grape::Entity
        expose :id
        expose :full_name
  
        def full_name
          "#{object.first_name} #{object.last_name}"
        end
      end
    end
  end
  