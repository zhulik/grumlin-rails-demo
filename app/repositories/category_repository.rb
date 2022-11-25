# frozen_string_literal: true

class CategoryRepository < ApplicationRepository
  shortcut :categories do
    hasLabel(:categories)
  end

  query(:add, return_mode: :single) do |name:|
    g.addV(:category)
     .props(name:)
     .elementMap
  end
end
