# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Categories" do
  let(:categories) { build_list(:category, 2).map(&:stringify_keys) }

  let(:repository_mock) { instance_double(CategoryRepository, all: categories) }

  before do
    stub_const("CategoriesController::REPOSITORY", repository_mock)
  end

  describe "GET /categories" do
    subject { get "/categories" }

    it "is successful" do
      subject
      expect(response).to be_successful
    end

    it "returns all categories" do
      subject
      expect(response.parsed_body).to eq(categories)
    end
  end

  describe "GET /categories/:id" do
    subject { get "/categories/#{id}" }

    let(:id) { SecureRandom.uuid }

    context "when category exists" do
      before do
        allow(repository_mock).to receive(:find).with(id).and_return(categories[0])
      end

      it "is successful" do
        subject
        expect(response).to be_successful
      end

      it "returns the category" do
        subject
        expect(response.parsed_body).to eq(categories[0])
      end
    end

    context "when category does not exist" do
      before do
        allow(repository_mock).to receive(:find).with(id).and_raise(StopIteration)
      end

      it "is not found" do
        subject
        expect(response).to be_not_found
      end
    end
  end

  describe "POST /categories" do
    subject { post "/categories/", params: }

    let(:params) { { category: category_params } }
    let(:category_params) { build(:category) }

    before do
      allow(repository_mock).to receive(:add).with(category_params.slice(:name).stringify_keys).and_return(category_params)
    end

    it "is successful" do
      subject
      expect(response).to be_successful
    end

    it "returns the category" do
      subject
      expect(response.parsed_body).to eq(category_params.stringify_keys)
    end
  end

  describe "PATCH /categories" do
    subject { patch "/categories/#{id}", params: }

    let(:id) { SecureRandom.uuid }

    let(:params) { { category: category_params } }
    let(:category_params) { build(:category) }

    context "when category exists" do
      before do
        allow(repository_mock).to receive(:update).with(id, category_params.slice(:name).stringify_keys).and_return(categories[0])
      end

      it "is successful" do
        subject
        expect(response).to be_successful
      end

      it "returns the category" do
        subject
        expect(response.parsed_body).to eq(categories[0])
      end
    end

    context "when category does not exist" do
      before do
        allow(repository_mock).to receive(:update).with(id, category_params.slice(:name).stringify_keys).and_raise(StopIteration)
      end

      it "is not found" do
        subject
        expect(response).to be_not_found
      end
    end
  end

  describe "DELETE /categories" do
    subject { delete "/categories/#{id}", params: }

    let(:id) { SecureRandom.uuid }

    let(:params) { { category: category_params } }
    let(:category_params) { build(:category) }

    context "when category exists" do
      before do
        allow(repository_mock).to receive(:drop).with(id).and_return(categories[0])
      end

      it "is successful" do
        subject
        expect(response).to be_successful
      end
    end

    context "when category does not exist" do
      before do
        allow(repository_mock).to receive(:drop).with(id).and_raise(StopIteration)
      end

      it "is not found" do
        subject
        expect(response).to be_not_found
      end
    end
  end
end
