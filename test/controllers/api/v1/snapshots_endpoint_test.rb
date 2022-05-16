require "test_helper"
require "controllers/api/test"

class Api::V1::SnapshotsEndpointTest < Api::Test
  include Devise::Test::IntegrationHelpers

    def setup
      # See `test/controllers/api/test.rb` for common set up for API tests.
      super

      @snapshot = create(:snapshot, team: @team)
      @other_snapshots = create_list(:snapshot, 3)
    end

    # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
    # data we were previously providing to users _will_ break the test suite.
    def assert_proper_object_serialization(snapshot_data)
      # Fetch the snapshot in question and prepare to compare it's attributes.
      snapshot = Snapshot.find(snapshot_data["id"])

      assert_equal snapshot_data['note'], snapshot.note
      # 🚅 super scaffolding will insert new fields above this line.

      assert_equal snapshot_data["team_id"], snapshot.team_id
    end

    test "index" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/teams/#{@team.id}/snapshots", params: {access_token: access_token}
      assert_response :success

      # Make sure it's returning our resources.
      snapshot_ids_returned = response.parsed_body.dig("data").map { |snapshot| snapshot.dig("attributes", "id") }
      assert_includes(snapshot_ids_returned, @snapshot.id)

      # But not returning other people's resources.
      assert_not_includes(snapshot_ids_returned, @other_snapshots[0].id)

      # And that the object structure is correct.
      assert_proper_object_serialization response.parsed_body.dig("data").first.dig("attributes")
    end

    test "show" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/snapshots/#{@snapshot.id}", params: {access_token: access_token}
      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # Also ensure we can't do that same action as another user.
      get "/api/v1/snapshots/#{@snapshot.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end

    test "create" do
      # Use the serializer to generate a payload, but strip some attributes out.
      snapshot_data = Api::V1::SnapshotSerializer.new(build(:snapshot, team: nil)).serializable_hash.dig(:data, :attributes)
      snapshot_data.except!(:id, :team_id, :created_at, :updated_at)

      post "/api/v1/teams/#{@team.id}/snapshots",
        params: snapshot_data.merge({access_token: access_token})

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # Also ensure we can't do that same action as another user.
      post "/api/v1/teams/#{@team.id}/snapshots",
        params: snapshot_data.merge({access_token: another_access_token})
      # TODO Why is this returning forbidden instead of the specific "Not Found" we get everywhere else?
      assert_response :forbidden
    end

    test "update" do
      # Post an attribute update ensure nothing is seriously broken.
      put "/api/v1/snapshots/#{@snapshot.id}", params: {
        access_token: access_token,
        note: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # But we have to manually assert the value was properly updated.
      @snapshot.reload
      assert_equal @snapshot.note, 'Alternative String Value'
      # 🚅 super scaffolding will additionally insert new fields above this line.

      # Also ensure we can't do that same action as another user.
      put "/api/v1/snapshots/#{@snapshot.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end

    test "destroy" do
      # Delete and ensure it actually went away.
      assert_difference("Snapshot.count", -1) do
        delete "/api/v1/snapshots/#{@snapshot.id}", params: {access_token: access_token}
        assert_response :success
      end

      # Also ensure we can't do that same action as another user.
      delete "/api/v1/snapshots/#{@snapshot.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end
end
