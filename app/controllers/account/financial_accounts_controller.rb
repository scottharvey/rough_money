class Account::FinancialAccountsController < Account::ApplicationController
  account_load_and_authorize_resource :financial_account, through: :team, through_association: :financial_accounts

  # GET /account/teams/:team_id/financial_accounts
  # GET /account/teams/:team_id/financial_accounts.json
  def index
    # if you only want these objects shown on their parent's show page, uncomment this:
    # redirect_to [:account, @team]
  end

  # GET /account/financial_accounts/:id
  # GET /account/financial_accounts/:id.json
  def show
  end

  # GET /account/teams/:team_id/financial_accounts/new
  def new
  end

  # GET /account/financial_accounts/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/financial_accounts
  # POST /account/teams/:team_id/financial_accounts.json
  def create
    respond_to do |format|
      if @financial_account.save
        format.html { redirect_to [:account, @team, :financial_accounts], notice: I18n.t("financial_accounts.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @financial_account] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @financial_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/financial_accounts/:id
  # PATCH/PUT /account/financial_accounts/:id.json
  def update
    respond_to do |format|
      if @financial_account.update(financial_account_params)
        format.html { redirect_to [:account, @financial_account], notice: I18n.t("financial_accounts.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @financial_account] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @financial_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/financial_accounts/:id
  # DELETE /account/financial_accounts/:id.json
  def destroy
    @financial_account.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :financial_accounts], notice: I18n.t("financial_accounts.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def financial_account_params
    strong_params = params.require(:financial_account).permit(
      :name,
      :description,
      :currency,
      :account_type,
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.
    )

    # 🚅 super scaffolding will insert processing for new fields above this line.

    strong_params
  end
end
