# frozen_string_literal: true

RSpec.describe CategoryRepository do
  let(:repository) { described_class.new }

  let!(:category) { create(:category, name: "Old name") }

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
      expect(subject[T.id]).to be_a(String)
      expect(subject[:created_at]).to be_a(Numeric)
    end
  end

  describe "#update" do
    subject { repository.update(category[T.id], name: "New name") }

    it "updates category" do
      expect { subject }.to change { g.V(category[T.id]).elementMap.next[:name] }.from("Old name").to("New name")
    end
  end

  describe "#drop" do
    subject { repository.drop(category[T.id]) }

    it "drops category" do
      expect { subject }.to change { g.V.hasLabel(:category).count.next }.by(-1)
    end
  end
end
