# frozen_string_literal: true

FactoryBot.define do
  factory :product, parent: :vertex do
    label { :product }

    sequence(:name) { "Product#{_1}" }
    sequence(:price) { Random.rand(100...200) }
  end
end
