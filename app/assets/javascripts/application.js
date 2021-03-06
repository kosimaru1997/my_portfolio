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


//= require jquery3
//= require popper
//= require bootstrap-sprockets

//= require rails-ujs
//= require jquery.jscroll.min.js
//= require activestorage
//= require turbolinks
//= require_tree .

// 無限スクロール
$(window).on('scroll', function() {
  scrollHeight = $(document).height();
  scrollPosition = $(window).height() + $(window).scrollTop();
  if ( (scrollHeight - scrollPosition) / scrollHeight <= 0.5) {
    $('.jscroll').jscroll({
      contentSelector: '.scroll-list',
      nextSelector: 'span.next:last a'
    });
  }
});

// チャットページのみスクロール位置の固定
$(document).on('turbolinks:load',function scrollToEnd() {
  if(document.URL.match(/rooms\/\d+/)){
    messagesArea = document.getElementById('scroll-inner');
    messagesArea.scrollTop = messagesArea.scrollHeight;
 }});


document.addEventListener("turbolinks:load", function () {
  SITE_URL = document.getElementById("url");

  if (SITE_URL != null) {
    console.log(SITE_URL);
    data = { key: 'f53cb9eed3ed4cebbaeb983ad7e3decb', q: SITE_URL.href };
    fetch('https://api.linkpreview.net', {
      method: 'POST',
      mode: 'cors',
      body: JSON.stringify(data),
    })
    .then(res => res.json())
    .then(response => {
      console.log(response)
      document.getElementById("h_url").innerHTML = response.title;
      document.getElementById("img_url").src = response.image;
      document.getElementById("a_url").href = response.url;
    })
  }
  })
  
  $(function() {
  $('#preview').on('click',function() {
    text = $('#md-textarea').val()
    $.ajax({  
      url: '/site/preview',
      type: 'GET',
      dataType: 'script',
      data: { body: text }
    });
  });
});

$(function() {
  $('#markdown').on('click',function() {
    $("#preview-area").addClass('d-none');
    $("#md-textarea").removeClass('d-none');
    $('#preview').addClass('bg-light-grey events-auto');
    $('#preview').removeClass('bg-white');
    $('#markdown').addClass('bg-white events-none');
    $('#markdown').removeClass('events-auto');
  });
});