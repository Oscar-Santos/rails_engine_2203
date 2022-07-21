class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name

  attribute :revenue do |object|
    object.revenue
  end
end
