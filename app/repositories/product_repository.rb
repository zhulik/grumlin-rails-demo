# frozen_string_literal: true

class ProductRepository < ApplicationRepository
  shortcut :withCategories do
    mergeElementMap(
      categories: __.out(:belongs_to).order.by(:name).elementMap.fold
    )
  end

  query(:all) do |category_ids: []|
    next g.V.products.withCategories if category_ids.empty?

    g.allV(*category_ids).in(:belongs_to).dedup.withCategories
  end

  query(:find, return_mode: :single) do |id|
    g.V(id)
     .products
     .withCategories
  end

  query(:add, return_mode: :single) do |name:, price:, category_ids: []|
    t = g.addV(:product)
         .props(name:, price:)
         .as(:product)

    category_ids.reduce(t) do |tt, id|
      tt.addE(:belongs_to)
        .from(:product)
        .to(__.V(id))
    end.select(:product).withCategories
  end

  # query(:update, return_mode: :single) do |id, name:, price:, categories: []|
  #   # g.V.products
  #   #  .hasId(id)
  #   #  .props(name:, price:)
  #   #  .elementMap
  # end

  query(:drop, return_mode: :none) do |id|
    g.V.products
     .hasId(id)
     .drop
  end
end
