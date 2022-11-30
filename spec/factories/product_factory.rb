# frozen_string_literal: true

FactoryBot.define do
  factory :product, parent: :vertex do
    label { :product }

    sequence(:name) { "Product#{_1}" }
    sequence(:price) { Random.rand(100...200) }

    to_create do |instance|
      instance.merge!(ProductRepository.new.add(**instance.without(T.label, :created_at)))
    end
  end
end
