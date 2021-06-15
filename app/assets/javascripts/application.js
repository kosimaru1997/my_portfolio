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
  if ( (scrollHeight - scrollPosition) / scrollHeight <= 0.05) {
    $('.jscroll').jscroll({
      contentSelector: '.scroll-list',
      nextSelector: 'span.next:last a'
    });
  }
});

// チャットページのみスクロール位置の固定
$(document).on('turbolinks:load',function scrollToEnd() {
  if(document.URL.match(/\d+\/chats/)){
    messagesArea = document.getElementById('scroll-inner');
    messagesArea.scrollTop = messagesArea.scrollHeight;
 }});
