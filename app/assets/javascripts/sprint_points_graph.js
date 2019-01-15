
$(document).on('turbolinks:load', function () {
    InitializePointsGraph();
    InitializeClosedByDayGraph();
    InitializeReleaseTimeGraphTeam();
    InitializeReleaseTimeBugsGraphTeam();
    InitializeOpenClosedBugsGraphTeam();
    //InitializeCycleTimeGraphTeam();

    $("#sgraph_noestimate").on("click", function () {
        if ($("#sgraph_noestimate")[0].checked) {
            InitializeNoEstimatesGraph();
        }else{
            if ($("#sgraph")[0].checked) {
                InitializeGrpahStories();
            } else {
                InitializePointsGraph();
            }
        }
    });

    $("#sgraph").on("click", function () {
        $("#sgraph_noestimate")[0].checked = false
        if ($("#sgraph")[0].checked) {
            InitializeGrpahStories();
        } else {
            InitializePointsGraph();
        }
    });

});





