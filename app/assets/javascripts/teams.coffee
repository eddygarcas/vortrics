class Teams
  boards = this
  constructor: ->
    @setup()

  setup: ->
    $("[id='team_project']").on "change", @handleChange
    $("[id='team_board_id']").on "change", @handleBoardChange

  handleChange: (e) ->
    $.ajax(
      url: "/teams/full_project_details/" + $('#team_project').val()
      type: "JSON"
      method: "GET"
      success: (data) ->
        console.log(data)
        $("#project_image")[0].src = data.avatarUrls["32x32"]
    )
    $.ajax(
      url: "/teams/boards_by_team/" + $('#team_project').val()
      type: "JSON"
      method: "GET"
      contentType: "application/json"
      success: (data) ->
        boards = data
        $('#team_board_id').empty()
        data.map (board) ->
          $('#team_board_id').append($('<option>', {value: board['id'], text: board['name']}))
    )
  handleBoardChange: (e) ->
    console.log(boards)
    $("[data-behaviour='board_type']").html(boards[$('select#team_board_id option:selected').index()].type)

jQuery ->
  new Teams
['name']