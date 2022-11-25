# frozen_string_literal: true

RSpec.describe CategoryRepository do
  let(:repository) { described_class.new }

  describe "#add" do
    subject { repository.add(name: "Some category") }

    it "creates a new category vertex" do
      expect { subject }.to change { g.V.hasLabel(:category).count.next }.by 1
    end

    it "returns created category with it's id" do
      expect(subject.except(T.id, :created_at)).to eq(
        T.label => "category",
        name: "Some category"
      )
      expect(subject[T.id]).to be_a(Numeric)
      expect(subject[:created_at]).to be_a(Numeric)
    end
  end
end
