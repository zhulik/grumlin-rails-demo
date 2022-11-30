# frozen_string_literal: true

FactoryBot.define do
  factory :category, parent: :vertex do
    label { :category }

    sequence(:name) { "Category#{_1}" }

    to_create do |instance|
      instance.merge!(CategoryRepository.new.add(**instance.without(T.label, :created_at)))
    end
  end
end
