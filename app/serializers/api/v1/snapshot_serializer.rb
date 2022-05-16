class Api::V1::SnapshotSerializer < Api::V1::ApplicationSerializer
  set_type "snapshot"

  attributes :id,
    :team_id,
    :note,
    # 🚅 super scaffolding will insert new fields above this line.
    :created_at,
    :updated_at

  belongs_to :team, serializer: Api::V1::TeamSerializer
end
