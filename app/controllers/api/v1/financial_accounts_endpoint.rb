class Api::V1::FinancialAccountsEndpoint < Api::V1::Root
  helpers do
    params :team_id do
      requires :team_id, type: Integer, allow_blank: false, desc: "Team ID"
    end

    params :id do
      requires :id, type: Integer, allow_blank: false, desc: "Financial Account ID"
    end

    params :financial_account do
      optional :name, type: String, desc: Api.heading(:name)
      optional :description, type: String, desc: Api.heading(:description)
      optional :currency, type: String, desc: Api.heading(:currency)
      optional :account_type, type: String, desc: Api.heading(:account_type)
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.

      # 🚅 super scaffolding will insert processing for new fields above this line.
    end
  end

  resource "teams", desc: Api.title(:collection_actions) do
    after_validation do
      load_and_authorize_api_resource FinancialAccount
    end

    #
    # INDEX
    #

    desc Api.title(:index), &Api.index_desc
    params do
      use :team_id
    end
    oauth2
    paginate per_page: 100
    get "/:team_id/financial_accounts" do
      @paginated_financial_accounts = paginate @financial_accounts
      render @paginated_financial_accounts, serializer: Api.serializer
    end

    #
    # CREATE
    #

    desc Api.title(:create), &Api.create_desc
    params do
      use :team_id
      use :financial_account
    end
    route_setting :api_resource_options, permission: :create
    oauth2 "write"
    post "/:team_id/financial_accounts" do
      if @financial_account.save
        render @financial_account, serializer: Api.serializer
      else
        record_not_saved @financial_account
      end
    end
  end

  resource "financial_accounts", desc: Api.title(:member_actions) do
    after_validation do
      load_and_authorize_api_resource FinancialAccount
    end

    #
    # SHOW
    #

    desc Api.title(:show), &Api.show_desc
    params do
      use :id
    end
    oauth2
    route_param :id do
      get do
        render @financial_account, serializer: Api.serializer
      end
    end

    #
    # UPDATE
    #

    desc Api.title(:update), &Api.update_desc
    params do
      use :id
      use :financial_account
    end
    route_setting :api_resource_options, permission: :update
    oauth2 "write"
    route_param :id do
      put do
        if @financial_account.update(declared(params, include_missing: false))
          render @financial_account, serializer: Api.serializer
        else
          record_not_saved @financial_account
        end
      end
    end

    #
    # DESTROY
    #

    desc Api.title(:destroy), &Api.destroy_desc
    params do
      use :id
    end
    route_setting :api_resource_options, permission: :destroy
    oauth2 "delete"
    route_param :id do
      delete do
        render @financial_account.destroy, serializer: Api.serializer
      end
    end
  end
end
