//= require openseadragon/openseadragon
//= require openseadragon/jquery

// Override OpenSeaDragon Rails integration to add loading indicator
(function($) {
  function initOpenSeadragon() {
    var $spinner = $('<div class="osd-loading"></div>'),
        $picture = $('picture[data-openseadragon]');

    // Add spinner markup to viewer
    $picture.append($spinner).openseadragon();
    var viewer = $picture.data('osdViewer');

    if (viewer) {
      // Monkey patch the showMessage method to display generic error message
      var originalShowMessage = viewer._showMessage;
      viewer._showMessage = function(text) {
        return originalShowMessage.apply(this, ['There was a problem loading this image. Please try again later.']);
      }

      // Callback to remove loading indicator
      var removeSpinner = function(evt) {
        viewer.removeHandler(removeSpinner);
        $spinner.remove();
      };

      // Remove loading indicator after loading the first tile or failing to open
      // image source
      viewer.addHandler('tile-drawing', removeSpinner);
      viewer.addHandler('open-failed', removeSpinner);
    }
  }

  $(document).on('page:load', initOpenSeadragon);
  $(document).ready(initOpenSeadragon);
})(jQuery);

