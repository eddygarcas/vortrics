`
    function TimeToFirstResponse(data) {
        document.getElementById('bars-first-response-loader').innerHTML = "";

        graph_f = new Rickshaw.Graph({
            element: document.getElementById('bars-first-response'),
            height: 220,
            renderer: 'multi',
            series: [
                {
                    name: 'Time First Response',
                    renderer: 'bar',
                    color: '#90caf9',
                    data: data[2]
                }

            ]
        });

        var format = function (n) {
            if (data[1][n] === undefined) {
                return;
            }
            return data[1][n].y;
        }

        var legend = new Rickshaw.Graph.Legend({
            graph: graph_f,
            element: document.getElementById('bars-first-response-legend')

        });

        new Rickshaw.Graph.Behavior.Series.Highlight({
            graph: graph_f,
            legend: legend,
            disabledColor: function () {
                return 'rgba(0, 0, 0, 0.2)'
            }
        });

        new Rickshaw.Graph.Behavior.Series.Toggle({
            graph: graph_f,
            legend: legend
        })

        new Rickshaw.Graph.ClickDetail({
            graph: graph_f,
            clickHandler: function (value) {
                window.open('/issues/' + $(".id_team_story").text(),"_self")
            }
        });

        new Rickshaw.Graph.Axis.X({
            graph: graph_f,
            orientation: 'bottom',
            element: document.getElementById('bars-first-response-x_axis'),
            pixelsPerTick: 100,
            tickFormat: format
        });

        new Rickshaw.Graph.Axis.Y({
            element: document.getElementById('bars-first-response-y_axis1'),
            graph: graph_f,
            orientation: 'left',
            scale: d3.scale.linear().domain([0, 100]),
            pixelsPerTick: 20,
            tickFormat: Rickshaw.Fixtures.Number.formatKMBT
        });

        graph_f.render();

        new Rickshaw.Graph.HoverDetail({
            onShow: function (event) {
                $('#key')[0].value = $(".key_bug_sprint").text();
            },
            graph: graph_f,
            formatter: function (series, x, y) {
                var sprint = '<span class="date key_bug_sprint">' + data[0][x].y + '</span><span class="date"> created on ' + data[1][x].y + '</span>';

                var content = series.name + " " + parseInt(y) + ' Hours<br>' + sprint;
                if (series.name === 'Time First Response') return content;
                return content;
            }
        });

        $(window).on('resize', function () {
            graph_f.configure({
                width: $('#bars-first-response').parent('.panel-body').width(),
                height: 220
            });
            graph_f.render();
        });
    }
`

class Teams
  boards = this
  constructor: ->
    @setup()

  setup: ->
    $("[data-behaviour='team_project_change']").on "change", @handleChange
    $("[data-behaviour='team_board_id_change']").on "change", @handleBoardChange
    @handleFirstResponse()
    @handleCycleTime()

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
    $("[data-behaviour='board_type']").val(boards[$('select#team_board_id option:selected').index()-1].type)

  handleFirstResponse: (e) ->
    return if $('#teamid').val() == undefined
    return if $('#bars-first-response')[0] == undefined
    return if ($('#bars-first-response')[0].dataset.behaviour != 'chart_first_response')
    $.ajax(
      url: "/teams/" + $('#teamid')[0].value + "/graph_time_first_response/"
      type: "JSON"
      method: "GET"
      success: (data) ->
        if (data != undefined)
          TimeToFirstResponse(data);
    )

  handleCycleTime: (e) ->
    return if $('#bars-cycle-time')[0] == undefined
    return if ($('#bars-cycle-time')[0].dataset.behaviour != 'chart_cycle_time')
    InitializeCycleTimeGraphTeam()
    InitializeAverageStoriesGraph()

ready = ->
  jQuery ->
    new Teams

$(document).on('turbolinks:load', ready)