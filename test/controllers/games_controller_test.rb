require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @game = games(:one)
  end

  test "should get index" do
    get games_url
    assert_response :success
  end

  test "should get new" do
    get new_game_url
    assert_response :success
  end

  test "should create game" do
    assert_difference("Game.count") do
      post games_url, params: { game: { admin_id: @game.admin_id, background_color: @game.background_color, code: @game.code, during_text: @game.during_text, end_text: @game.end_text, header_color: @game.header_color, name: @game.name, start_text: @game.start_text, text_color: @game.text_color } }
    end

    assert_redirected_to game_url(Game.last)
  end

  test "should show game" do
    get game_url(@game)
    assert_response :success
  end

  test "should get edit" do
    get edit_game_url(@game)
    assert_response :success
  end

  test "should update game" do
    patch game_url(@game), params: { game: { admin_id: @game.admin_id, background_color: @game.background_color, code: @game.code, during_text: @game.during_text, end_text: @game.end_text, header_color: @game.header_color, name: @game.name, start_text: @game.start_text, text_color: @game.text_color } }
    assert_redirected_to game_url(@game)
  end

  test "should destroy game" do
    assert_difference("Game.count", -1) do
      delete game_url(@game)
    end

    assert_redirected_to games_url
  end
end
