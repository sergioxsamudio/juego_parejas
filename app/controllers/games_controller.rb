class GamesController < ApplicationController
  before_action :set_game, only: %i[ show edit update destroy play finish ]
  before_action :set_game, only: [:show, :edit, :update, :destroy, :start, :register_players, :play, :finish]

  # GET /games or /games.json
  def index
    @games = Game.all
  end

  # GET /games/1 or /games/1.json
  def show
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
  end
  def purge_logo
    @game.logo.purge
    redirect_to edit_game_path(@game), notice: 'Logo eliminado correctamente.'
  end

  # POST /games or /games.json
  def create
    @game = current_admin.games.build(game_params)
    respond_to do |format|
      if @game.save
        format.html { redirect_to game_path(@game, locale: I18n.locale.to_s), notice: "Game was successfully created." }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1 or /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: "Game was successfully updated." }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1 or /games/1.json
  def destroy
    @game.destroy!
    respond_to do |format|
      format.html { redirect_to games_path, status: :see_other, notice: "Game was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def export_players
    @game = Game.find(params[:id])
    respond_to do |format|
      format.xlsx  # Esto renderizará export_players.xlsx.axlsx
    end
  end
  

  def enter_code
  end

  def verify_code
    @game = Game.find_by(code: params[:code])
    if @game
      session[:game_id] = @game.id

      redirect_to start_game_path(@game, locale: I18n.locale.to_s)

    else
      flash[:alert] = "Código inválido"
      redirect_to enter_code_games_path
    end
  end
  def start
    @game = Game.find(params[:id])
    unless @game
      redirect_to enter_code_games_path, alert: t('games.enter_code.required')
    end
  end

  def register_players
    @game = Game.find(params[:id])
    @player1 = Player.new
    @player2 = Player.new
  end

  def save_players
    @game = Game.find(params[:id])
  
    player1_params = player_params[:player1]
    player2_params = player_params[:player2]
  
    # Validar que todos los campos estén presentes
    if player1_params[:first_name].blank? || player1_params[:last_name].blank? || player1_params[:email].blank? ||
       player2_params[:first_name].blank? || player2_params[:last_name].blank? || player2_params[:email].blank?
      flash[:alert] = 'Por favor, complete todos los campos.'
      render :register_players
      return
    end
  
    @player1 = @game.players.new(player1_params)
    @player2 = @game.players.new(player2_params)
  
    if @player1.save && @player2.save
      redirect_to game_path(@game)
    else
      render :register_players
    end
  end

  # ------------------
  # Lógica del juego
  # ------------------

  def play
    @game = Game.find(params[:id])
    @players = Player.last(2) # Obtiene los últimos dos jugadores inscritos
    @current_player = @players.first
    
    # Reinicializar variables de sesión para iniciar el juego desde cero
    session[:turn]   = 0
    session[:start_time] = Time.current
    session[:matched_pairs] = []
    
    @current_turn   = session[:turn] % @players.size
    @current_player = @players[@current_turn]
    @remaining_time = 60 - (Time.current - session[:start_time]).to_i
    
    # Duplicar y mezclar las imágenes para formar parejas
    @images = (@game.images.to_a * 2).shuffle
    
    # Solo evalúa la condición de parejas si hay imágenes disponibles
    if @remaining_time <= 0 || (@images.any? && session[:matched_pairs].size >= (@images.size / 2))
      redirect_to finish_game_path(@game, locale: I18n.locale.to_s), notice: "Tiempo finalizado o todas las parejas encontradas" and return
    end
    
    # Se renderiza la vista play.html.erb
  end
  

  def finish
    @game = Game.find(params[:id])
    @elapsed_time = Time.now - @game.created_at

    # Obtener los dos últimos jugadores que jugaron
    last_two_players = @game.players.last(2)
    @winner = nil
    @winner_score = nil
    @resultado_del_juego = nil # Inicializamos a nil

    if last_two_players.size == 2
      # Calcular los puntajes solo para los dos últimos jugadores
      scores = {}
      last_two_players.each { |player| scores[player] = player.score.to_i }

      highest_score = scores.values.max || 0
      winners = scores.select { |_, score| score == highest_score }.keys

      if winners.length == 1
        @winner = winners.first
        @winner_score = highest_score
        @resultado_del_juego = "#{winners.first.first_name} CON #{highest_score} PUNTOS"
      else
        @resultado_del_juego = "¡... UN EMPATE !"
      end
    elsif last_two_players.size == 1
      @resultado_del_juego = "#{last_two_players.first.first_name} es el ganador."
      @winner = last_two_players.first
      @winner_score = last_two_players.first.score.to_i
    else
      # Si no hay suficientes jugadores, @resultado_del_juego permanece nil
    end

    if request.post?
      render json: { redirect_url: game_finish_path(@game, locale: I18n.locale.to_s) }
    else
      # No necesitas hacer nada especial para @resultado_del_juego en GET
    end

    # Limpiar las variables de sesión para reiniciar el juego
    session[:turn] = nil
    session[:start_time] = nil
    session[:matched_pairs] = nil
  end
  private

  def player_params
    params.permit(player1: [:first_name, :last_name, :email], player2: [:first_name, :last_name, :email])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    permitted = params.require(:game).permit(
      :code, :name, :header_color, :text_color, :background_color,
      :start_text, :during_text, :end_text, { images: [] }, :backside_image,:logo,:background_image
    )
    # Filtrar elementos vacíos del array de imágenes (si existen)
    if permitted[:images].present?
      permitted[:images] = permitted[:images].reject(&:blank?)
    end
    permitted
  end
end
