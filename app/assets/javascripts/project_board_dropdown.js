/**
 * Created by eduard.garcia on 13/10/2018.
 */
$(document).on('turbolinks:load', function () {

    $('select#team_project').on('change', function (event) {
        var selected_id = $(this).val();
        $.ajax({
            type: 'GET',
            url: '/teams/boards_by_team/' + selected_id,
            success: function (items) {
                $('#team_board_id').empty()
                $.each(items, function (name, item) {
                    $('#team_board_id').append($('<option>', {value: item, text: name}));
                })
            }
        })

    });

});
