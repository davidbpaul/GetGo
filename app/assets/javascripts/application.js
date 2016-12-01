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

function createVariantElement (variant) {
  var $option = $('<option></option>').attr('value', variant).text(variant);
  return $option
}

$('#route_select').on('change', function(ev) {
  $.ajax({
    url: "http://localhost:3000/routes/" + this.value + "/trips",
    type: "GET"
  })
  .done(function (data) {
    var trips = data['trips'];
    var variantsList = [];
    for (var i = 0; i < trips.length; i++) {
      var routeVariant = trips[i]['route_variant'];
      if (variantsList.indexOf(routeVariant) == -1) {
        variantsList.push(routeVariant);
      }
    }
    $('#route_variant_select').empty();
    $('#route_variant_select').append($('<option></option>').text('Select a Route Number'));
    variantsList.forEach(function (variant) {
      $('#route_variant_select').append(createVariantElement(variant));
    });
    $('#route_variant_select').prop("disabled", false);
  })
  .fail(function (err){
    console.log(err);
  });
});

$('#route_variant_select').on('change', function(ev) {
  $.ajax({
    url: "http://localhost:3000/trips/" + this.value + "/stops",
    type: "GET"
  })
  .done(function (data) {
    var stops = data['stops'];
    // var stopsList = [];
    // for (var i = 0; i < stops.length; i++) {
    //   var stopId = stops[i]['id'];
    //   var stopName = stops[i]['name'];
    // }
    $('#from_stop_select').empty();
    $('#from_stop_select').append($('<option></option>').text('Select a Starting Stop'));
  })
  .fail(function (err) {

  });
});

// in this file:
// create event listeners for selectTwo and selectThree
