require "test_helper"
require "controllers/api/test"

class Api::V1::FinnacialAccountsEndpointTest < Api::Test
  include Devise::Test::IntegrationHelpers

    def setup
      # See `test/controllers/api/test.rb` for common set up for API tests.
      super

      # 🚅 super scaffolding will insert factory setup in place of this line.
      @other_finnacial_accounts = create_list(:finnacial_account, 3)
    end

    # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
    # data we were previously providing to users _will_ break the test suite.
    def assert_proper_object_serialization(finnacial_account_data)
      # Fetch the finnacial_account in question and prepare to compare it's attributes.
      finnacial_account = FinnacialAccount.find(finnacial_account_data["id"])

      # 🚅 super scaffolding will insert new fields above this line.

      assert_equal finnacial_account_data["team_id"], finnacial_account.team_id
    end

    test "index" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/teams/#{@team.id}/finnacial_accounts", params: {access_token: access_token}
      assert_response :success

      # Make sure it's returning our resources.
      finnacial_account_ids_returned = response.parsed_body.dig("data").map { |finnacial_account| finnacial_account.dig("attributes", "id") }
      assert_includes(finnacial_account_ids_returned, @finnacial_account.id)

      # But not returning other people's resources.
      assert_not_includes(finnacial_account_ids_returned, @other_finnacial_accounts[0].id)

      # And that the object structure is correct.
      assert_proper_object_serialization response.parsed_body.dig("data").first.dig("attributes")
    end

    test "show" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/finnacial_accounts/#{@finnacial_account.id}", params: {access_token: access_token}
      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # Also ensure we can't do that same action as another user.
      get "/api/v1/finnacial_accounts/#{@finnacial_account.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end

    test "create" do
      # Use the serializer to generate a payload, but strip some attributes out.
      finnacial_account_data = Api::V1::FinnacialAccountSerializer.new(build(:finnacial_account, team: nil)).serializable_hash.dig(:data, :attributes)
      finnacial_account_data.except!(:id, :team_id, :created_at, :updated_at)

      post "/api/v1/teams/#{@team.id}/finnacial_accounts",
        params: finnacial_account_data.merge({access_token: access_token})

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # Also ensure we can't do that same action as another user.
      post "/api/v1/teams/#{@team.id}/finnacial_accounts",
        params: finnacial_account_data.merge({access_token: another_access_token})
      # TODO Why is this returning forbidden instead of the specific "Not Found" we get everywhere else?
      assert_response :forbidden
    end

    test "update" do
      # Post an attribute update ensure nothing is seriously broken.
      put "/api/v1/finnacial_accounts/#{@finnacial_account.id}", params: {
        access_token: access_token,
        # 🚅 super scaffolding will also insert new fields above this line.
      }

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # But we have to manually assert the value was properly updated.
      @finnacial_account.reload
      # 🚅 super scaffolding will additionally insert new fields above this line.

      # Also ensure we can't do that same action as another user.
      put "/api/v1/finnacial_accounts/#{@finnacial_account.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end

    test "destroy" do
      # Delete and ensure it actually went away.
      assert_difference("FinnacialAccount.count", -1) do
        delete "/api/v1/finnacial_accounts/#{@finnacial_account.id}", params: {access_token: access_token}
        assert_response :success
      end

      # Also ensure we can't do that same action as another user.
      delete "/api/v1/finnacial_accounts/#{@finnacial_account.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end
end
