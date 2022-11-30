# frozen_string_literal: true

class CategoryRepository < ApplicationRepository
  shortcut :withProductCount do
    mergeElementMap(
      product_count: __.inE(:belongs_to).dedup.count
    )
  end

  query(:all) do
    g.V.categories
     .withProductCount
  end

  query(:find, return_mode: :single) do |id|
    g.V.categories
     .hasId(id)
     .withProductCount
  end

  query(:add, return_mode: :single) do |name:|
    g.addV(:category)
     .props(name:)
     .withProductCount
  end

  query(:update, return_mode: :single) do |id, name:|
    g.V.categories
     .hasId(id)
     .props(name:)
     .withProductCount
  end

  query(:drop, return_mode: :none) do |id|
    g.V.categories
     .hasId(id)
     .drop
  end
end
