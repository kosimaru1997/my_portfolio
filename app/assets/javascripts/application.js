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

// $(function(){
//   $('.alert').fadeOut(4000);  //４秒かけて消えていく
// });


  // document.addEventListener("turbolinks:load", function () {
  //   const SITE_URL = document.getElementById("url_<%= post.id %>");
  //   console.log(SITE_URL);

  // if (SITE_URL != null) {
  //   const data = { key: 'f53cb9eed3ed4cebbaeb983ad7e3decb', q: SITE_URL.href };
  //   fetch('https://api.linkpreview.net', {
  //     method: 'POST',
  //     mode: 'cors',
  //     body: JSON.stringify(data),
  //   })
  //   .then(data => data.json())
  //   .then(json => {
  //     console.log(json);
  //     document.getElementById("h_<%= post.id%>").innerHTML = json.title;
  //     document.getElementById("img_<%= post.id %>").src = json.image
  //     document.getElementById("a_<%= post.id %>").href = json.url
  //   })
  // }
  // })