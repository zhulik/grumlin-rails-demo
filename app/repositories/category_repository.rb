# frozen_string_literal: true

class CategoryRepository < ApplicationRepository
  query(:all) do
    g.V.categories.elementMap
  end

  query(:find, return_mode: :single) do |id|
    g.V.categories
     .hasId(id)
     .elementMap
  end

  query(:add, return_mode: :single) do |name:|
    g.addV(:category)
     .props(name:)
     .elementMap
  end

  query(:update, return_mode: :single) do |id, name:|
    g.V.categories
     .hasId(id)
     .props(name:)
     .elementMap
  end

  query(:drop, return_mode: :none) do |id|
    g.V.categories
     .hasId(id)
     .drop
  end
end
