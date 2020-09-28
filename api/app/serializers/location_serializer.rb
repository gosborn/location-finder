class LocationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description
end
