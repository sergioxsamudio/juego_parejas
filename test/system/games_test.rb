require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  setup do
    @game = games(:one)
  end

  test "visiting the index" do
    visit games_url
    assert_selector "h1", text: "Games"
  end

  test "should create game" do
    visit games_url
    click_on "New game"

    fill_in "Admin", with: @game.admin_id
    fill_in "Background color", with: @game.background_color
    fill_in "Code", with: @game.code
    fill_in "During text", with: @game.during_text
    fill_in "End text", with: @game.end_text
    fill_in "Header color", with: @game.header_color
    fill_in "Name", with: @game.name
    fill_in "Start text", with: @game.start_text
    fill_in "Text color", with: @game.text_color
    click_on "Create Game"

    assert_text "Game was successfully created"
    click_on "Back"
  end

  test "should update Game" do
    visit game_url(@game)
    click_on "Edit this game", match: :first

    fill_in "Admin", with: @game.admin_id
    fill_in "Background color", with: @game.background_color
    fill_in "Code", with: @game.code
    fill_in "During text", with: @game.during_text
    fill_in "End text", with: @game.end_text
    fill_in "Header color", with: @game.header_color
    fill_in "Name", with: @game.name
    fill_in "Start text", with: @game.start_text
    fill_in "Text color", with: @game.text_color
    click_on "Update Game"

    assert_text "Game was successfully updated"
    click_on "Back"
  end

  test "should destroy Game" do
    visit game_url(@game)
    accept_confirm { click_on "Destroy this game", match: :first }

    assert_text "Game was successfully destroyed"
  end
end
