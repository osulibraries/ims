$(document).ready(function(){

  if($("#collection_id_for_stats").length > 0){
    get_admin_collection_stats()
  }
    

    table = $('#admin-sets-list').DataTable({
        paginate: false,
        "bFilter": false,
        "aoColumns": [
          { "bSortable": true },
          { "bSortable": true },
          { "bSortable": true },
          { "bSortable": true },
          { "bSortable": false }
        ]
    })



  });

function get_admin_collection_stats(){
  id = $('#collection_id_for_stats').val()
  $.ajax({
    url: APP_PATH + "calculate_admin_set_stats/" + id,

  }).success(function(data){
    $("#item-count").html(data.total_members)
    $("#byte-count").html(data.total_bytes)
  })
}