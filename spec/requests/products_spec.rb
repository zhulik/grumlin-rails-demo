# frozen_string_literal: true

RSpec.describe "Products" do
  let(:products) { build_list(:product, 2).map(&:stringify_keys) }

  let(:repository_mock) { instance_double(ProductRepository) }

  before do
    stub_const("ProductsController::REPOSITORY", repository_mock)
  end

  describe "GET /products" do
    subject { get "/products", params: }

    context "when category_ids is passed" do
      let(:params) { { category_ids: [SecureRandom.uuid] } }

      before do
        allow(repository_mock).to receive(:all).with(**params).and_return(products)
      end

      it "is successful" do
        subject
        expect(response).to be_successful
      end

      it "returns products" do
        subject
        expect(response.parsed_body).to eq(products)
      end
    end

    context "when category_ids is not passed" do
      let(:params) { {} }

      before do
        allow(repository_mock).to receive(:all).with(no_args).and_return(products)
      end

      it "is successful" do
        subject
        expect(response).to be_successful
      end

      it "returns products" do
        subject
        expect(response.parsed_body).to eq(products)
      end
    end

    context "when category_ids is not an array" do
      let(:params) { { category_ids: "wat" } }

      before do
        allow(repository_mock).to receive(:all).with(no_args).and_return(products)
      end

      it "is successful" do
        subject
        expect(response).to be_successful
      end

      it "returns products" do
        subject
        expect(response.parsed_body).to eq(products)
      end
    end
  end
end
