class API < Grape::API
  prefix 'api'
  mount Versions::V1
  mount Versions::V2
end
