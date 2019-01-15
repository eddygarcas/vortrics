//= require dresssed/fastclick
//= require dresssed/slimscroll
//= require dresssed/metis_menu
//= require dresssed/bootstrap
//= require dresssed/sheets
//= require dresssed/header
//= require dresssed/maps
//= require dresssed/flot
//= require dresssed/morris
//= require dresssed/prettify
//= require dresssed/rickshaw

// The following requires are all just for the initial demo animations on the
// dashboard layout - you can safely remove

//= require generators/data_generator
//= require demo/flot_helper
//= require demo/maps_helper

var sweetAlertConfirmConfig = {
    title: 'Are you sure?',
    type: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#DD6B55',
    confirmButtonText: 'Ok'
};

function InitializeDresssed() {
    if (Modernizr.touch) {
        FastClick.attach(document.body);
    }

    // Required for the SideNav dropdown nav-side-menu
    $('.nav-side-menu').metisMenu();

    $('[data-toggle="popover"]').popover({
        container: 'body'
    });

    $('[data-toggle="tooltip"]').tooltip({
        container: 'body'
    });

    var width = document.body.clientWidth;

    if (!Modernizr.touch && width > 1025) {
        $('#menu-content').slimScroll({
            height: 'auto'
        });
    } else {
        $('#menu-content').height(0);
        $('#menu-content').slimScroll({
            destroy: 'true'
        });
    }

    $(window).on('resize', function () {
        if (Modernizr.touch) return;

        width = document.body.clientWidth;

        if (width < 1025) {
            $('#menu-content').height(0);
            $('#menu-content').slimScroll({
                destroy: 'true'
            });
        } else {
            $('#menu-content').slimScroll({
                destroy: 'true'
            });
            $('#menu-content').slimScroll({
                height: '100%'
            });
        }

        try {
            sizeiframe(width);
        } catch (e) {
        }
    });

}

if (typeof window.turbolinksTurbolinks === 'object') {
    $(document).on('turbolinks:load', function () {
        InitializeDresssed();
    });
} else {
    $(document).ready(function () {
        InitializeDresssed();
    });
}

