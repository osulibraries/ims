// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require jquery.nested-fields


// require turbolinks
//= require chosen-jquery
//= require owl.carousel
//= require js-routes
//
// Required by Blacklight
//= require blacklight/blacklight
//= require sufia
//= require osul-theme
//= require rails.validations
//= require_tree .


$(document).ready(function() {

  $('#material-fields').nestedFields();
  $('#measurement-fields').nestedFields();
  // $('#preservation-level-fields').nestedFields();

  //Loading indicator on mouse any time they move through the application
  window.onbeforeunload = function(e) {
    $("body").css("cursor", "progress");
  }

  // import preview carousel
  $(".owl-carousel").owlCarousel({
    navigation : true, // Show next and prev buttons
    itemsDesktop : [1199,3],
      itemsDesktopSmall : [979,3],
    singleItem:true
  });

  // using chosen gem for import field mappings (can select multiple)
  $('.chosen-select').chosen({
    allow_single_deselect: true,
    no_results_text: 'No results matched',
    disable_search_threshold: 8,
    width: '100%'
  });

  // using chosen gem import field mappings for image (can only select one)
  $('.chosen-select-max-1').chosen({
    allow_single_deselect: true,
    no_results_text: 'No results matched',
    max_selected_options: 1,
    width: '100%'
  });

  // Enable Bootstrap popovers
  $('[data-toggle="popover"]').popover();

  // autocomplete suggester for input fields
  $(function() {
 
    if (Routes.sufia_root_path  == '//'){
      prefix = '/';
    }
    else {
      prefix = Routes.sufia_root_path;
    }

    var selector = "input.generic_file_date_created";
    $(document).on('keydown.autocomplete', selector, function() {
        $(this).autocomplete({ source: prefix + "autocomplete/dateSuggester/" });
    });

    var selector = "input.generic_file_subject";
    $(document).on('keydown.autocomplete', selector, function() {
        $(this).autocomplete({ source: prefix + "autocomplete/subjectSuggester/" });
    });

    var selector = "input.generic_file_creator";
    $(document).on('keydown.autocomplete', selector, function() {
        $(this).autocomplete({ source: prefix + "autocomplete/creatorSuggester/" });
    });
    var selector = "input.generic_file_tag";
    $(document).on('keydown.autocomplete', selector, function() {
        $(this).autocomplete({ source: prefix + "autocomplete/tagSuggester/" });
    });
    var selector = "input.generic_file_part_of";
    $(document).on('keydown.autocomplete', selector, function() {
        $(this).autocomplete({ source: prefix + "autocomplete/part_ofSuggester/" });
    });
    var selector = "input.generic_file_temporal";
    $(document).on('keydown.autocomplete', selector, function() {
        $(this).autocomplete({ source: prefix + "autocomplete/temporalSuggester/" });
    });
    var selector = "input.generic_file_work_type";
    $(document).on('keydown.autocomplete', selector, function() {
        $(this).autocomplete({ source: prefix + "autocomplete/work_typeSuggester/" });
    });
    var selector = "input.generic_file_format";
    $(document).on('keydown.autocomplete', selector, function() {
        $(this).autocomplete({ source: prefix + "autocomplete/formatSuggester/" });
    });
    var selector = "input.generic_file_bibliographic_citation";
    $(document).on('keydown.autocomplete', selector, function() {
        $(this).autocomplete({ source: prefix + "autocomplete/bibliographic_citationSuggester/" });
    });
    var selector = "input.generic_file_spatial";
    $(document).on('keydown.autocomplete', selector, function() {
        $(this).autocomplete({ source: prefix + "autocomplete/spatialSuggester/" });
    });
    var selector = "input.generic_file_material";
    $(document).on('keydown.autocomplete', selector, function() {
        $(this).autocomplete({ source: prefix + "autocomplete/materialSuggester/" });
    });
    var selector = "input.generic_file_material_type";
    $(document).on('keydown.autocomplete', selector, function() {
        $(this).autocomplete({ source: prefix + "autocomplete/material_typeSuggester/" });
    });
    var selector = "input.generic_file_language";
    $(document).on('keydown.autocomplete', selector, function() {
        $(this).autocomplete({ source: prefix + "autocomplete/languageSuggester/" });
    });
    var selector = "input.generic_file_based_near";
    $(document).on('keydown.autocomplete', selector, function() {
        $(this).autocomplete({ source: prefix + "autocomplete/locationSuggester/" });
    });
    var selector = "input.generic_file_measurement_unit";
    $(document).on('keydown.autocomplete', selector, function() {
        $(this).autocomplete({ source: prefix + "autocomplete/measurement_unitSuggester/" });
    });
    var selector = "input.generic_file_measurement_type";
    $(document).on('keydown.autocomplete', selector, function() {
        $(this).autocomplete({ source: prefix + "autocomplete/measurement_typeSuggester/" });
    });
    // $( "#generic_file_date_created" ).autocomplete({
    //   source: '/date_suggest'
    // }); 
  });
});

function notify_update_link() {
  // NOTE: This is overridden from sufia.js to stop all the Mailboxer calls and logging.
}


