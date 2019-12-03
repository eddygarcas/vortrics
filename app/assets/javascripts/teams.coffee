class Teams
  boards = this
  constructor: ->
    @setup()

  setup: ->
    $("[data-behaviour='team_project_change']").on "change", @handleChange
    $("[data-behaviour='team_board_id_change']").on "change", @handleBoardChange

  handleChange: (e) ->
    return if $('#team_project').val() == undefined
    $.ajax(
      url: "/teams/full_project_details/" + $('#team_project').val()
      type: "JSON"
      method: "GET"
      success: (data) ->
        if (data != undefined)
          $("#project_image")[0].src = data.avatarUrls["32x32"]
        else
          $("[data-behaviour='board_type']").html("Error")

    )
    $.ajax(
      url: "/teams/boards_by_team/" + $('#team_project').val()
      type: "JSON"
      method: "GET"
      contentType: "application/json"
      success: (data) ->
        boards = data
        $('#team_board_id').empty()
        $('#team_board_id').append($('<option>', {value: '', text: 'Select board...'}))
        data.map (board) ->
          $('#team_board_id').append($('<option>', {value: board['id'], text: board['name']}))
    )
  handleBoardChange: (e) ->
    $("[data-behaviour='board_type']").val(boards[$('select#team_board_id option:selected').index()].type)


ready = ->
  jQuery ->
    new Teams

$(document).ready(ready)
$(document).on('turbolinks:load', ready)