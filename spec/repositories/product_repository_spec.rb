# frozen_string_literal: true

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ProductRepository do
  let(:repository) { described_class.new }

  describe "#add" do
    subject { repository.add(name: "Some product", price: 123, category_ids:) }

    context "when category_ids list is not empty" do
      let(:categories) { create_list(:category, 2) }

      context "when all categories are found" do
        let(:category_ids) { categories.pluck(T.id) }

        it "creates a product vertex" do
          expect { subject }.to change { g.V.hasLabel(:product).count.next }.by 1
        end

        it "creates belongs_to edges" do
          expect { subject }.to change { g.E.hasLabel(:belongs_to).count.next }.by 2
          expect(g.V.hasId(subject[T.id]).out(:belongs_to).id.toList).to match_array(categories.pluck(T.id))
        end

        it "returns created product" do
          expect(subject.except(T.id, :created_at)).to eq(
            T.label => "product",
            name: "Some product",
            price: 123,
            categories: categories.map { _1.except(:product_count) }
          )
          expect(subject[T.id]).to be_a(String)
          expect(subject[:created_at]).to be_a(Numeric)
        end
      end

      context "when some categories are not found" do
        let(:category_ids) { [categories.first[T.id], SecureRandom.uuid] }

        it "raises an exception" do
          expect { subject }.to raise_error(Grumlin::ServerError)
        end
      end
    end

    context "when category_ids list is empty" do
      let(:category_ids) { [] }

      it "creates a new product vertex" do
        expect { subject }.to change { g.V.hasLabel(:product).count.next }.by 1
      end

      it "returns created product" do
        expect(subject.except(T.id, :created_at)).to eq(
          T.label => "product",
          name: "Some product",
          price: 123,
          categories: []
        )
        expect(subject[T.id]).to be_a(String)
        expect(subject[:created_at]).to be_a(Numeric)
      end

      it "does not create belongs_to edges" do
        expect { subject }.not_to(change { g.E.hasLabel(:belongs_to).count.next })
      end
    end
  end

  describe "#drop" do
    subject { repository.drop(id) }

    let!(:product) { create(:product) }

    context "when product exists" do
      let(:id) { product[T.id] }

      it "drops product" do
        expect { subject }.to change { g.V.hasLabel(:product).count.next }.by(-1)
      end
    end

    context "when product does not exist" do
      let(:id) { SecureRandom.uuid }

      it "raises an exception" do
        expect { subject }.to raise_error(StopIteration, "iteration reached an end")
      end
    end
  end

  describe "#find" do
    subject { repository.find(id) }

    context "when product exists" do
      let(:categories) { create_list(:category, 2) }
      let!(:product) { create(:product, categories:) }

      let(:id) { product[T.id] }

      it "returns the product" do
        expect(subject).to eq(product)
      end
    end

    context "when product does not exist" do
      let(:id) { SecureRandom.uuid }

      it "raises an exception" do
        expect { subject }.to raise_error(StopIteration, "iteration reached an end")
      end
    end
  end

  describe "#all" do
    subject { repository.all(category_ids:) }

    let!(:categories) { create_list(:category, 4) }
    let!(:product1) { create(:product, categories: [categories[0]]) }
    let!(:product2) { create(:product, categories: [categories[0]]) }
    let!(:product3) { create(:product, categories: [categories[1]]) }
    let!(:product4) { create(:product, categories: [categories[1]]) }
    let!(:product5) { create(:product, categories: [categories[2]]) }

    context "when no category ids is passed" do
      let(:category_ids) { [] }

      it "returns all products" do
        expect(subject).to match_array([product1, product2, product3, product4, product5])
      end
    end

    context "when one category id is passed" do
      context "when it's empty" do
        let(:category_ids) { [categories.dig(3, T.id)] }

        it "returns an empty list" do
          expect(subject).to be_empty
        end
      end

      context "when it exists" do
        let(:category_ids) { [categories.dig(0, T.id)] }

        it "returns products belonging to it" do
          expect(subject).to match_array([product1, product2])
        end
      end

      context "when it does not exist" do
        let(:category_ids) { [SecureRandom.uuid] }

        it "raises an error" do
          expect { subject }.to raise_error(Grumlin::FailStepError, "Some vertices were not found")
        end
      end
    end

    context "when multiple category id is passed" do
      context "when all of them exists" do
        let(:category_ids) { categories[0..1].pluck(T.id) }

        it "returns products belonging to all of them" do
          expect(subject).to match_array([product1, product2, product3, product4])
        end
      end

      context "when some of the do not exist" do
        let(:category_ids) { [categories.dig(0, T.id), SecureRandom.uuid] }

        it "raises an error" do
          expect { subject }.to raise_error(Grumlin::FailStepError, "Some vertices were not found")
        end
      end
    end
  end

  describe "#update" do
    subject { repository.update(id, **params) }

    let(:product) { create(:product) }

    let(:params) { { name: "New name", price: "12345", category_ids: } }
    let(:category_ids) { [] }

    context "when product exists" do
      let(:id) { product[T.id] }

      context "when product didn't have categories" do
        let(:category) { create(:category) }
        let(:category_ids) { [category[T.id]] }

        it "updates the product and assigns categories" do
          expect { subject }.to change { repository.find(id).except(:created_at) }.from(product.except(:created_at)).to(
            {
              T.label => "product",
              T.id => product[T.id],
              name: "New name",
              categories: [category.except(:product_count)],
              price: "12345"
            }
          )
        end
      end

      context "when product had categories" do
        let(:category) { create(:category) }
        let(:product) { create(:product, categories: [category]) }

        context "when passing an empty categories list" do
          it "updates the product and removes it's categories" do
            expect { subject }.to change { repository.find(id).except(:created_at) }.from(product.except(:created_at)).to(
              {
                T.label => "product",
                T.id => product[T.id],
                name: "New name",
                categories: [],
                price: "12345"
              }
            )
          end

          it "returns updated product" do
            expect(subject.except(:created_at)).to eq(
              {
                T.label => "product",
                T.id => product[T.id],
                name: "New name",
                categories: [],
                price: "12345"
              }
            )
          end
        end

        context "when passing a non-empty category list" do
          let(:another_category) { create(:category) }
          let(:category_ids) { [another_category[T.id]] }

          it "updates the product and replaces the categories" do
            expect { subject }.to change { repository.find(id).except(:created_at) }.from(product.except(:created_at)).to(
              {
                T.label => "product",
                T.id => product[T.id],
                name: "New name",
                categories: [another_category.except(:product_count)],
                price: "12345"
              }
            )
          end
        end
      end
    end

    context "when product does not exist" do
      let(:id) { SecureRandom.uuid }

      it "raises an exception" do
        expect { subject }.to raise_error(StopIteration, "iteration reached an end")
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
