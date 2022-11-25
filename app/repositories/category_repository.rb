# frozen_string_literal: true

class CategoryRepository < ApplicationRepository
  shortcut :categories do
    self.V.hasLabel(:category)
  end

  query(:all) do
    g.categories.elementMap
  end

  query(:find, return_mode: :single) do |id|
    g.categories
     .hasId(id)
     .elementMap
  end

  query(:add, return_mode: :single) do |name:|
    g.addV(:category)
     .props(name:)
     .elementMap
  end

  query(:update, return_mode: :single) do |id, name:|
    g.categories
     .hasId(id)
     .props(name:)
     .elementMap
  end

  query(:drop, return_mode: :none) do |id|
    g.categories
     .hasId(id)
     .drop
  end
end
