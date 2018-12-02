// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require rails-ujs
//= require activestorage
//= require turbolinks

//= require jquery
//= require jquery.raty

//= require filterrific/filterrific-jquery


//ajax refresh for item profile user action buttons 

function ajax_user_action( user_id, item_id, req_on, from,url_index, url_method,element_id, due_date){
	var user_on_hold_items_url = "/users/" + user_id + "/on_hold_items";
	var user_on_hold_item_url = "/users/" + user_id + "/on_hold_items/" + item_id;
	var user_wish_lists_url = "/users/" + user_id + "/wish_lists";
	var user_wish_list_url = "/users/" + user_id + "/wish_lists/" + item_id;
	var url = [user_on_hold_items_url, user_on_hold_item_url, user_wish_lists_url, user_wish_list_url];
	//var date_obj = new Date();
  $.ajax({
    url: url[url_index],
    type: url_method,
    data: {
      user_id: user_id, 
      item_id: item_id, 
      req_on: req_on, 
      due_date: due_date,
      from: from
    },
    datatype: "json",
    success: function(data, textStatus, xhr){
    	$(element_id).html(data);
    },
    error: function(request, status, error){
      console.log(error);
    },
  });
}

//rating display with stars; runs after images are loaded
$('document').ready(function(){
  //config setup
  $('.rating-display').raty({
      readOnly: true,
      score: function() {
        return $(this).attr('data-score');
      },
      //path: '/assets/',
      size: 24
    });
  $('.rating-form-ild').raty({
      //path: '/assets/',
      scoreName: 'review_lender_and_item[rating]',
      size: 24
    });
  $('.rating-form-brw').raty({
      //path: '/assets/',
      scoreName: 'review_borrower[rating]',
      size: 24
    });
});