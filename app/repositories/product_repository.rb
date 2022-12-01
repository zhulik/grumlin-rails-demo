# frozen_string_literal: true

class ProductRepository < ApplicationRepository
  shortcut :withCategories do
    mergeElementMap(
      categories: __.out(:belongs_to).order.by(:name).elementMap.fold
    )
  end

  shortcut :assignCategories do |ids|
    ids.reduce(self) do |t, id|
      t.addE(:belongs_to)
       .from(:product)
       .to(__.V(id))
    end
  end

  shortcut :replaceCategories do |ids|
    sideEffect(__.outE(:belongs_to).drop)
      .assignCategories(ids)
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
    g.addV(:product)
     .props(name:, price:)
     .as(:product)
     .assignCategories(category_ids)
     .select(:product).withCategories
  end

  query(:update, return_mode: :single) do |id, name:, price:, category_ids: []|
    g.V.products
     .hasId(id)
     .as(:product)
     .replaceCategories(category_ids)
     .select(:product)
     .props(name:, price:)
     .withCategories
  end

  query(:drop, return_mode: :none) do |id|
    g.V.products
     .hasId(id)
     .drop
  end
end
