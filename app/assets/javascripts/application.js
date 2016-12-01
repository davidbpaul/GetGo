/*!
 * Start Bootstrap - Grayscale Bootstrap Theme (http://startbootstrap.com)
 * Code licensed under the Apache License v2.0.
 * For details, see http://www.apache.org/licenses/LICENSE-2.0.
 */

//= require jquery
//= require jquery_ujs
//= require jquery.easing
//= require turbolinks
//= require_tree .
//= require bootstrap-sprockets

// jQuery to collapse the navbar on scroll
function collapseNavbar() {
    if ($(".navbar").offset().top > 50) {
        $(".navbar-fixed-top").addClass("top-nav-collapse");
    } else {
        $(".navbar-fixed-top").removeClass("top-nav-collapse");
    }
}

$(window).scroll(collapseNavbar);
$(document).ready(collapseNavbar);

// jQuery for page scrolling feature - requires jQuery Easing plugin
$(function() {
    $('a.page-scroll').bind('click', function(event) {
        var $anchor = $(this);
        $('html, body').stop().animate({
            scrollTop: $($anchor.attr('href')).offset().top
        }, 1500, 'easeInOutExpo');
        event.preventDefault();
    });
});

// Closes the Responsive Menu on Menu Item Click
// $('.navbar-collapse ul li a').click(function() {
//     $(this).closest('.collapse').collapse('toggle');
// });

$('.auth-form').find('input, textarea').on('keyup blur focus', function (e) {

  var $this = $(this),
      label = $this.prev('label');

	  if (e.type === 'keyup') {
			if ($this.val() === '') {
          label.removeClass('active highlight');
        } else {
          label.addClass('active highlight');
        }
    } else if (e.type === 'blur') {
    	if( $this.val() === '' ) {
    		label.removeClass('active highlight');
			} else {
		    label.removeClass('highlight');
			}
    } else if (e.type === 'focus') {

      if( $this.val() === '' ) {
    		label.removeClass('highlight');
			}
      else if( $this.val() !== '' ) {
		    label.addClass('highlight');
			}
    }

});

$('.tab a').on('click', function (e) {
  e.preventDefault();

  $(this).parent().addClass('active');
  $(this).parent().siblings().removeClass('active');

  target = $(this).attr('href');

  $('.tab-content > div').not(target).hide();

  $(target).fadeIn(600);

});

var fromStop = '';
var stops = [];
var variantList = [];
var root = "http://localhost:3000";

function arrayObjectIndexOf(myArray, searchTerm, property) {
    for(var i = 0, len = myArray.length; i < len; i++) {
        if (myArray[i][property] === searchTerm) return i;
    }
    return -1;
}

// function createRouteElement (route) {
//   var $option = $('<option></option>').attr('value', route['id']).text(route['name']);
// }

function createTripElement (trip) {
  var $option = $('<option></option>').attr('value', trip['route_variant']).text(trip['route_variant']);
  //var $option = $('<option></option>').attr({value: trip['route_variant'], trip_id: trip['id']}).text(trip['route_variant']);
  //var $option = $('<option></option>').attr('value', trip['route_variant']).data('trip-id', trip['id']).text(trip['route_variant']);
  return $option;
}

function createStopElement (stop) {
  var $option = $('<option></option>').attr('value', stop['id']).text(stop['name']);
  return $option
}

// $('#preference-button').on('click', function (ev) {
//   $.ajax({
//     url: `${root}/agencies/GO/routes`,
//     type: "GET"
//   })
//   .done(function (data) {
//     var routes = data['routes'];
//     $('#route_select').empty();
//     $('#route_select').append($('<option></option>').text('Select a Route'));
//     routes.forEach(function (route) {
//       $('#route_select').append(createRouteElement(route));
//     });
//   })
//   .fail(function (err) {
//     console.log(err);
//   })
// });

$('#route_select').on('change', function (ev) {
  $('#route_variant_select').prop("disabled", true);
  $('#from_stop_select').prop("disabled", true);
  $('#to_stop_select').prop("disabled", true);
  $.ajax({
    //url: "http://localhost:3000/routes/" + this.value + "/trips",
    url: `${root}/routes/${this.value}/trips`,
    type: "GET"
  })
  .done(function (data) {
    var trips = data['trips'];
    $('#route_variant_select').empty();
    $('#route_variant_select').append($('<option></option>').text('Select a Route Number'));
    variantList = [];
    trips.forEach(function (trip) {
      if (arrayObjectIndexOf(variantList, trip['route_variant'], 'route_variant') === -1) {
        variantList.push(trip);
        $('#route_variant_select').append(createTripElement(trip));
      }
    });
    $('#route_variant_select').prop("disabled", false);
  })
  .fail(function (err){
    console.log(err);
  });
});

$('#route_variant_select').on('change', function (ev) {
  $('#from_stop_select').prop("disabled", true);
  $('#to_stop_select').prop("disabled", true);
  var index = arrayObjectIndexOf(variantList, this.value, 'route_variant');
  var tripId = variantList[index]['id'];
  $.ajax({
    //url: "http://localhost:3000/trips/" + variantList[index]['id'] + "/stops",
    url: `${root}/trips/${tripId}/stops`,
    type: "GET"
  })
  .done(function (data) {
    stops = data['stops'];
    $('#from_stop_select').empty();
    $('#from_stop_select').append($('<option></option>').text('Select a Starting Stop'));
    stops.forEach(function (stop) {
      $('#from_stop_select').append(createStopElement(stop));
    });
    $('#from_stop_select').prop("disabled", false);
  })
  .fail(function (err) {
    console.log(err);
  });
});

$('#from_stop_select').on('change', function (ev) {
  $('#to_stop_select').prop("disabled", true);
  var from_stop = this.value;
  $('#to_stop_select').empty();
  $('#to_stop_select').append($('<option></option>').text('Select a Destination Stop'));
  stops.forEach(function (stop) {
    if (stop['id'] != from_stop) {
      $('#to_stop_select').append(createStopElement(stop));
    }
  });
  $('#to_stop_select').prop("disabled", false);
});
