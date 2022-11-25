# frozen_string_literal: true

FactoryBot.define do
  factory :vertex, class: Hash do
    label { "vertex" }

    initialize_with do
      attributes.merge(T.label => attributes[:label]).without(:label)
    end

    created_at { Time.zone.now.getutc.to_i }

    to_create do |instance|
      instance.merge!(Grumlin::Repository.new.g
                         .addV(instance[T.label])
                         .props(**instance.without(T.label))
                         .elementMap
                         .next)
    end
  end
end
