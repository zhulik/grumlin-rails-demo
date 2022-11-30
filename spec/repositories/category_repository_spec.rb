# frozen_string_literal: true

RSpec.describe CategoryRepository do
  let(:repository) { described_class.new }

  describe "#add" do
    subject { repository.add(name: "Some category") }

    it "creates a new category vertex" do
      expect { subject }.to change { g.V.hasLabel(:category).count.next }.by 1
    end

    it "returns created category" do
      expect(subject.except(T.id, :created_at)).to eq(
        T.label => "category",
        name: "Some category",
        product_count: 0
      )
      expect(subject[T.id]).to be_a(String)
      expect(subject[:created_at]).to be_a(Numeric)
    end
  end

  describe "#update" do
    subject { repository.update(category[T.id], name: "New name") }

    let!(:category) { create(:category, name: "Old name") }

    it "updates category" do
      expect { subject }.to change { g.V(category[T.id]).elementMap.next[:name] }.from("Old name").to("New name")
    end
  end

  describe "#drop" do
    subject { repository.drop(category[T.id]) }

    let!(:category) { create(:category) }

    it "drops category" do
      expect { subject }.to change { g.V.hasLabel(:category).count.next }.by(-1)
    end
  end

  describe "#all" do
    subject { repository.all }

    let!(:categories) { create_list(:category, 2) }

    it "returns all categories" do
      expect(subject).to match_array(categories)
    end
  end

  describe "#find" do
    subject { repository.find(id) }

    let!(:category) { create(:category) }

    context "when category exists" do
      let(:id) { category[T.id] }

      context "when it does not have any products" do
        it "returns the category" do
          expect(subject).to eq(category)
        end
      end

      context "when it has products" do
        before do
          create_list(:product, 2, categories: [category])
        end

        it "returns the category" do
          expect(subject).to eq(category.merge(product_count: 2))
        end
      end
    end

    context "when category does not exist" do
      let(:id) { SecureRandom.uuid }

      it "raises an exception" do
        expect { subject }.to raise_error(StopIteration, "iteration reached an end")
      end
    end
  end
end
