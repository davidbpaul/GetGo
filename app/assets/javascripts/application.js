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
// 1. Routes 2. RouteVariant 3. Stops
// Add 2 more disabled select tags
// Client: On selectOneChange, API call to /routes/:id/trips
// Server: Takes Route id, loops through to find relevant data
// Server: Returns data
// Client: Receives array of data in done() method
// Client: Loop through array, appending <option> tags with data

// event listener for selectOne
var route = '';
var variant = '';
var fromStop = '';
var toStop = '';


function arrayObjectIndexOf(myArray, searchTerm, property) {
    for(var i = 0, len = myArray.length; i < len; i++) {
        if (myArray[i][property] === searchTerm) return i;
    }
    return -1;
}

function createTripElement (trip) {
  var $option = $('<option></option>').attr('value', trip['id']).text(trip['route_variant']);
  return $option;
}

function createStopElement (stop) {
  var $option = $('<option></option>').attr('value', stop['id']).text(stop['name']);
  return $option
}

$('#route_select').on('change', function (ev) {
  $.ajax({
    url: "http://localhost:3000/routes/" + this.value + "/trips",
    type: "GET"
  })
  .done(function (data) {
    var trips = data['trips'];
    $('#route_variant_select').empty();
    $('#route_variant_select').append($('<option></option>').text('Select a Route Number'));
    var variantList = [];
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

var stops = [];

$('#route_variant_select').on('change', function (ev) {
  $.ajax({
    url: "http://localhost:3000/trips/" + this.value + "/stops",
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
