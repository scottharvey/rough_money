class Api::V1::Root < Api::Base
  include Api::V1::Base

  mount Api::V1::FinancialAccountsEndpoint
  mount Api::V1::SnapshotsEndpoint
  # 🚅 super scaffolding will mount new endpoints above this line.

  handle_not_found
end
