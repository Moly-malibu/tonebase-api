require_relative './create/presence_validation' # allows controller spec to avoid separately loading this file (for convenience and brevity)
require_relative './create/uniqueness_validation' # allows controller spec to avoid separately loading this file (for convenience and brevity)

# @param [ApplicationRecord] model_class
# @param [Hash] resource_params For initializing the resource. Pass this from inside a block so you can use other variables in its contstruction.
# @param [Hash] also_serialize Optionally provide methods to also be serialized when checking for their persistance. Do this to test persistance of nested attributes. Requires a matching instance method, which you will have to also define in the model class.
# @example
#
#   it_behaves_like "a create endpoint", Ad  do
#     let(:advertiser){ create(:advertiser)}
#     let(:resource_params){
#       {
#         advertiser_id: advertiser.id,
#         title: "Buy a Fendie",
#         content: "Fendie sitars are the best.",
#         url: "https://www.fendie.com/promo",
#         image_url: "https://my-bucket.s3.amazonaws.com/my-dir/my-image.jpg"
#       }
#     }
#   end
#
#
#   it_behaves_like "a create endpoint", User  do
#     let(:also_serialize){ [:user_profile_attributes] }
#     let(:resource_params){
#       {
#         email: "avg.joe@gmail.com",
#         password: "abc123",
#         user_profile_attributes:{
#           birth_year: 1975,
#           professions: ["Student", "Performer", "Instructor"]
#         }
#       }
#     }
#   end
#
shared_examples_for "a create endpoint" do |model_class|
  describe "response" do
    context "with valid params" do
      let(:response){ post(:create, params: {format: 'json', model_class.name.underscore.to_sym => resource_params}) }

      it "should be successful (created)" do
        expect(response.status).to eql(201)
        expect(response.message).to eql("Created")
      end

      it "should create a new resource" do
        expect{response}.to change{model_class.count}.by(1)
      end

      it "should create a resource and persist all the relevant attributes" do
        response

        methods = defined?(also_serialize) ? also_serialize : []
        persisted_attributes = model_class.last.serializable_hash(except: [:id, :created_at, :updated_at], methods: methods).deep_symbolize_keys

        persisted_attributes.each do |k,v|
          persisted_attributes[k] = persisted_attributes[k].to_s if v.class == Date # convert Sat, 01 Jul 2017 to "2017-07-01"
        end

        expect(persisted_attributes).to include(resource_params)
      end
    end
  end
end
