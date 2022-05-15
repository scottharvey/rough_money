require "test_helper"
require "controllers/api/test"

class Api::V1::FinancialAccountsEndpointTest < Api::Test
  include Devise::Test::IntegrationHelpers

    def setup
      # See `test/controllers/api/test.rb` for common set up for API tests.
      super

      @financial_account = create(:financial_account, team: @team)
      @other_financial_accounts = create_list(:financial_account, 3)
    end

    # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
    # data we were previously providing to users _will_ break the test suite.
    def assert_proper_object_serialization(financial_account_data)
      # Fetch the financial_account in question and prepare to compare it's attributes.
      financial_account = FinancialAccount.find(financial_account_data["id"])

      assert_equal financial_account_data['name'], financial_account.name
      assert_equal financial_account_data['description'], financial_account.description
      assert_equal financial_account_data['currency'], financial_account.currency
      assert_equal financial_account_data['account_type'], financial_account.account_type
      # 🚅 super scaffolding will insert new fields above this line.

      assert_equal financial_account_data["team_id"], financial_account.team_id
    end

    test "index" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/teams/#{@team.id}/financial_accounts", params: {access_token: access_token}
      assert_response :success

      # Make sure it's returning our resources.
      financial_account_ids_returned = response.parsed_body.dig("data").map { |financial_account| financial_account.dig("attributes", "id") }
      assert_includes(financial_account_ids_returned, @financial_account.id)

      # But not returning other people's resources.
      assert_not_includes(financial_account_ids_returned, @other_financial_accounts[0].id)

      # And that the object structure is correct.
      assert_proper_object_serialization response.parsed_body.dig("data").first.dig("attributes")
    end

    test "show" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/financial_accounts/#{@financial_account.id}", params: {access_token: access_token}
      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # Also ensure we can't do that same action as another user.
      get "/api/v1/financial_accounts/#{@financial_account.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end

    test "create" do
      # Use the serializer to generate a payload, but strip some attributes out.
      financial_account_data = Api::V1::FinancialAccountSerializer.new(build(:financial_account, team: nil)).serializable_hash.dig(:data, :attributes)
      financial_account_data.except!(:id, :team_id, :created_at, :updated_at)

      post "/api/v1/teams/#{@team.id}/financial_accounts",
        params: financial_account_data.merge({access_token: access_token})

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # Also ensure we can't do that same action as another user.
      post "/api/v1/teams/#{@team.id}/financial_accounts",
        params: financial_account_data.merge({access_token: another_access_token})
      # TODO Why is this returning forbidden instead of the specific "Not Found" we get everywhere else?
      assert_response :forbidden
    end

    test "update" do
      # Post an attribute update ensure nothing is seriously broken.
      put "/api/v1/financial_accounts/#{@financial_account.id}", params: {
        access_token: access_token,
        name: 'Alternative String Value',
        description: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # But we have to manually assert the value was properly updated.
      @financial_account.reload
      assert_equal @financial_account.name, 'Alternative String Value'
      assert_equal @financial_account.description, 'Alternative String Value'
      # 🚅 super scaffolding will additionally insert new fields above this line.

      # Also ensure we can't do that same action as another user.
      put "/api/v1/financial_accounts/#{@financial_account.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end

    test "destroy" do
      # Delete and ensure it actually went away.
      assert_difference("FinancialAccount.count", -1) do
        delete "/api/v1/financial_accounts/#{@financial_account.id}", params: {access_token: access_token}
        assert_response :success
      end

      # Also ensure we can't do that same action as another user.
      delete "/api/v1/financial_accounts/#{@financial_account.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end
end
