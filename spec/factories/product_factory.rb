# frozen_string_literal: true

FactoryBot.define do
  factory :product, parent: :vertex do
    label { "product" }

    sequence(:name) { "Product#{_1}" }
    sequence(:price) { Random.rand(100...200) }

    categories { [] }

    to_create do |instance|
      ids = instance[:categories].map { _1.is_a?(String) ? _1 : _1[T.id] }

      instance.merge!(
        ProductRepository.new.add(
          **instance.without(T.label, :created_at, :categories)
                    .merge(category_ids: ids)
        )
      )
    end
  end
end
