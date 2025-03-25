class PlayersController < ApplicationController
  before_action :set_player, only: %i[ show edit update destroy ]
  

  # GET /players or /players.json
  def index
    @players = Player.all
  end

  # GET /players/1 or /players/1.json
  def show
  end

  # GET /players/new
  def new
    @game = Game.find_by(id: params[:game_id])
    unless @game
      flash[:alert] = "Juego no encontrado"
      redirect_to root_path
      return
    end
    @player = Player.new
  end

  # GET /players/1/edit
  def edit
  end

  # POST /players or /players.json
  def create
    @game = Game.find(params[:game_id])
    @players = players_params.map { |pdata| @game.players.build(pdata) }
  
    if @players.all?(&:valid?)
      @players.each(&:save!)
      redirect_to play_game_path(@game, locale: I18n.locale.to_s), notice: "Jugadores registrados correctamente."
    else
      flash[:alert] = "Hubo un error al registrar los jugadores. Verifica los datos."
      render :new, status: :unprocessable_entity
    end
  end
  
  

  # PATCH/PUT /players/1 or /players/1.json
  def update
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to @player, notice: "Player was successfully updated." }
        format.json { render :show, status: :ok, location: @player }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1 or /players/1.json
  def destroy
    @player.destroy!

    respond_to do |format|
      format.html { redirect_to players_path, status: :see_other, notice: "Player was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def players_params
      params.require(:players).permit(
        "0" => [:first_name, :last_name, :email, :cellphone],
        "1" => [:first_name, :last_name, :email, :cellphone]
      ).to_h.values
    end
end
