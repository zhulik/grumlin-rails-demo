# frozen_string_literal: true

FactoryBot.define do
  factory :category, parent: :vertex do
    label { :category }

    sequence(:name) { "Category#{_1}" }
  end
end
