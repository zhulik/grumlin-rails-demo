# frozen_string_literal: true

class ProductRepository < ApplicationRepository
  shortcut :products do
    self.V.hasLabel(:product)
  end

  shortcut :with_categories do
    mergeElementMap(
      categories: __.out(:belongs_to).order.by(:name).elementMap.fold
    )
  end

  # query(:all) do
  #   g.products.elementMap
  # end

  query(:find, return_mode: :single) do |id|
    g.products
     .hasId(id)
     .with_categories
  end

  query(:add, return_mode: :single) do |name:, price:, category_ids: []|
    t = g.addV(:product)
         .props(name:, price:)
         .as(:product)

    category_ids.reduce(t) do |tt, id|
      tt.addE(:belongs_to)
        .from(:product)
        .to(__.V(id))
    end.select(:product).with_categories
  end

  # query(:update, return_mode: :single) do |id, name:, price:, categories: []|
  #   # g.products
  #   #  .hasId(id)
  #   #  .props(name:, price:)
  #   #  .elementMap
  # end

  query(:drop, return_mode: :none) do |id|
    g.products
     .hasId(id)
     .drop
  end
end
