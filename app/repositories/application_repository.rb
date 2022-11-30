# frozen_string_literal: true

class ApplicationRepository
  extend Grumlin::Repository

  default_vertex_properties do |_label|
    {
      created_at: Time.zone.now.getutc.to_i
    }
  end

  default_edge_properties do |_label|
    {
      created_at: Time.zone.now.getutc.to_i
    }
  end

  shortcut :mergeElementMap do |**params|
    coalesce(
      __.union(
        __.elementMap,
        *params.map { __.project(_1).by(_2) }
      )
      .unfold
      .group.by(Column.keys).by(__.select(Column.values))
    )
  end

  shortcut :products do
    hasLabel(:product)
  end

  shortcut :categories do
    hasLabel(:category)
  end

  shortcut :allV do |*ids|
    self.V(ids)
        .fold
        .coalesce(
          __.filter(
            __.count(Scope.local).is(ids.size)
          ),
          __.fail("Some vertices were not found")
        )
        .unfold
  end
end
