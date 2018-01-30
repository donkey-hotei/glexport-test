require "rails_helper"

# Tests the structure of the returned json
# What should be returned when hitting /api/v1/shipments?company_id=#{YALMART_ID}
# {
#   "records": [
#     {
#       "id": 1,
#       "name": "yalmart apparel from china",
#       "products": [
#         {
#           "quantity": 123,
#           "id": 1,
#           "sku": "shoe1",
#           "description": "shoes",
#           "active_shipment_count": 1
#         },
#         {
#           "quantity": 234,
#           "id": 2,
#           "sku": "pant1",
#           "description": "pants",
#           "active_shipment_count": 2
#         }
#       ]
#     },
#     {
#       "id": 2,
#       ...
#     },
#     {
#       "id": 3,
#       ...
#     }
#   ]
# }

RSpec.describe "Shipments" do
  context "GET /api/v1/shipments" do
    let(:headers) { default_headers }
    let!(:company) { create(:company) }
    let!(:shipments) do
      create_list(:shipment, 3, :with_products, company: company)
    end

    let(:params) { { company_id: company.id } }

    before do |test|
      get api_v1_shipments_path, headers: headers, params: params unless test.metadata[:skip_get]
    end

    context "with valid params" do
      let(:shipment) { shipments.first }

      context "shipment json" do
        it "returns success" do
          expect(response).to be_success
        end

        it "displays shipment name" do
          expect(json["shipments"].first["name"]).to include(shipment.name)
        end
      end

      context "products json" do
        let(:products_json) do
          json["shipments"].first["products"]
        end

        it "returns product id's" do
          # match_array matches true for both [1,2] and [2,1]
          expect(products_json.map do |product_json|
            product_json["id"].to_i
          end).to match_array(shipment.product_ids)
        end

        it "returns product's sku's" do
          expect(products_json.map do |product_json|
            product_json["sku"]
          end).to match_array(shipment.products.pluck(:sku))
        end

        it "returns includes product's description" do
          expect(products_json.map do |product_json|
            product_json["description"]
          end).to match_array(shipment.products.pluck(:description))
        end

        it "returns product's quanity on shipment" do
          expect(products_json.map do |product_json|
            product_json["quantity"].to_i
          end).to match_array(shipment.products.map(&:quantity))
        end

        pending "includes the calculated attribute active_shipment_count"
          # This active_shipment_count field should be a code smell to you
          # expect(products_json.map do |product_json|
          #   product_json["active_shipment_count"].to_i
          # end).to match_array([1, 2])
      end
    end

    describe "sorting" do
      # Company has three shipments, departing (in order of id) Jan 1, Jan 3, Jan 2
      context "by default" do
        it "sorts by id in ascending order" do
          expect(json["shipments"].map { |s| s["id"] }).to \
            eq(Shipment.where(company: company).order(id: :asc).pluck(:id))
        end
      end

      context "by international departure date", :skip_get do
        context "in ascending sort" do
          let(:shipment_params) do
            params.merge(sort: :international_departure_date, direction: :asc)
          end

          before do
            get api_v1_shipments_path, headers: headers, params: shipment_params
          end

          it "returns success" do
            expect(response).to be_success
          end

          it "allows ascending sort" do
            expect(json["shipments"].map do |shipment_json|
              shipment_json["id"]
            end).to eq(Shipment.where(company: company).order(id: :asc).pluck(:id))
          end
        end

        context "in descending sort", :skip_get do
          let(:shipment_params) do
            params.merge(sort: :international_departure_date, direction: :asc)
          end

          before do
            get api_v1_shipments_path, headers: headers, params: shipment_params
          end

          it "returns success" do
            expect(response).to be_success
          end

          it "allows descending sort" do
            expect(json["shipments"].map do |shipment_json|
              shipment_json["id"]
            end).to eq(Shipment.where(company: company).order(id: :desc).pluck(:id))
          end
        end
      end
    end

    describe "filters" do
      # Company YALMART has three shipments, two by ocean and one by truck

      context "using international_transportation_mode", :skip_get do
        describe "filters by ocean" do
          let(:shipment_params) do
            params.merge(international_transportation_mode: :truck)
          end

          before do
            get api_v1_shipments_path, headers: headers, params: shipment_params
          end

          it "returns success" do
            expect(response).to be_success
          end

          it "returns oceanic shipments" do
            expect(json["shipments"].map do |shipment_json|
              shipment_json["id"]
            end).to match_array(Shipments.where(company: company).by_ocean.pluck(:id))
          end
        end

        describe "filters by truck", :skip_get do
          let(:shipment_params) do
            params.merge(international_transportaiont_mode: :truck)
          end

          before do
            get api_v1_shipments_path, headers: headers, params: shipment_params
          end

          it "returns success" do
            expect(response).to be_success
          end

          it "returns truck shipments" do
            expect(json["shipments"].map do |shipment_json|
              shipment_json["id"]
            end).to match_array(Shipment.where(company: company).by_truck.pluck(:id))
          end
        end
      end
    end

    context "pagination" do
      # Company DOSTCO has six shipments, with ids [4, 5, 6, 7, 8, 9]

      context "with no params" do
        it "defaults to 4 results" do
          expect(json["shipments"].map do |shipment_json|
            shipment_json["id"]
          end).to eq(Shipment.where(company: company).pluck(:id))
        end
      end

      context "with page params" do
        let(:page_params) do
          params.merge(page: 2)
        end

        before do
          get api_v1_shipments_path, headers: headers, params: page_params
        end

        it "returns success" do
          expect(response).to be_success
        end

        it "allows page navigation with the default 4 per page" do
          expect(json["shipments"].map do |shipment_json|
            shipment_json["id"]
          end).to eq(Shipment.where(company: company).paginate(page: 2).pluck(:id))
        end
      end

      context "with explicit page and per params" do
        let(:page_params) do
          params.merge(page: 2, per: 2)
        end

        it "returns success" do
          expect(response).to be_success
        end

        it "allows custom pagination" do
          expect(json["shipments"].map do |shipment_json|
            shipment_json["id"]
          end).to eq(Shipment.where(company: company).paginate(page: 2, per_page: 2).pluck(:id))
        end
      end
    end
  end

  context "with invalid params", :skip_get do
    context "company_id is not provided" do
      let(:empty_params) { {} }

      before do
        get api_v1_shipments_path, headers: headers, params: empty_params
      end

      it "returns a 422" do
        expect(response).to be_unprocessible
      end

      it "returns an errored response and a useful error message" do
        expect(json["errors"]).to eq(["company_id is required"])
      end
    end
  end
end
