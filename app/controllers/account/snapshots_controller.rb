class Account::SnapshotsController < Account::ApplicationController
  account_load_and_authorize_resource :snapshot, through: :team, through_association: :snapshots

  # GET /account/teams/:team_id/snapshots
  # GET /account/teams/:team_id/snapshots.json
  def index
    # if you only want these objects shown on their parent's show page, uncomment this:
    # redirect_to [:account, @team]
  end

  # GET /account/snapshots/:id
  # GET /account/snapshots/:id.json
  def show
  end

  # GET /account/teams/:team_id/snapshots/new
  def new
  end

  # GET /account/snapshots/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/snapshots
  # POST /account/teams/:team_id/snapshots.json
  def create
    respond_to do |format|
      if @snapshot.save
        format.html { redirect_to [:account, @team, :snapshots], notice: I18n.t("snapshots.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @snapshot] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @snapshot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/snapshots/:id
  # PATCH/PUT /account/snapshots/:id.json
  def update
    respond_to do |format|
      if @snapshot.update(snapshot_params)
        format.html { redirect_to [:account, @snapshot], notice: I18n.t("snapshots.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @snapshot] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @snapshot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/snapshots/:id
  # DELETE /account/snapshots/:id.json
  def destroy
    @snapshot.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :snapshots], notice: I18n.t("snapshots.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def snapshot_params
    strong_params = params.require(:snapshot).permit(
      :note,
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.
    )

    # 🚅 super scaffolding will insert processing for new fields above this line.

    strong_params
  end
end
