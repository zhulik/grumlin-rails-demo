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
end
