$(document).ready(function(){
    table = $('#groups-list').DataTable({
        paginate: false,
        "bFilter": false,
        "aoColumns": [
          { "bSortable": true },
          { "bSortable": true },
          { "bSortable": false },
          { "bSortable": false },
          { "bSortable": false }
        ]
    })
  });