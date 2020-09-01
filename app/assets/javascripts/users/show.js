$(function() {
  // フレンド募集の最後の投稿の直後にクリアフィックスを追加
  var clearfix = $('<div>', { class:'clearfix' });
  $(".index_recruitments").append(clearfix);
  // モーダルそれぞれに個別のidを付ける
  $('div.js-modal').each(function(index){
    $(this).addClass('modal-'+index);
    $(this).find('.js-modal-close').addClass('modal-close-'+index);
  });
  var modals = $('div.js-modal');
  // フレンド募集内でモーダルにアクセスするためのリンクを表示する
  $('div.description_first_wrapper').each(function(index){
    if ($(this).height() > 125) {
      $(this).css({'height':'125','overflow':'hidden'});
      $(this).parent().css({'position':'relative'});
      var modal_link = $('<a>', { text:'全てを表示',type:'button',class:'modal_link js-modal-open-'+index });
      modal_link.css({'position':'absolute','bottom':'0','right':'10px'});
      $(this).parent().append(modal_link);
      modal_link.on('click',function(){
        $('.modal-'+index).fadeIn();
        return false;
      });
      $('.modal-close-'+index).on('click',function(){
        $('.modal-'+index).fadeOut();
        return false;
      });
    }
  });
});

// ユーザープロフィールページの自己紹介のアコーディオン機能
var wrapper = document.querySelector("div.self_introduction_first_wrapper");
var height = wrapper.clientHeight;
if (height > 210) {
  wrapper.classList.add("less_introduction");
  var expand1 = document.createElement("a");
  expand1.textContent = "全てを表示▼";
  expand1.className = "expand";
  wrapper.parentNode.appendChild(expand1);
  expand1.addEventListener("click", () => {
    accordion(wrapper, expand1);
  });
}
function accordion(target, expand1) {
  if (target.className === "self_introduction_first_wrapper less_introduction") {
    target.classList.remove("less_introduction");
    expand1.textContent = "折りたたむ▲";
  } else {
    target.classList.add("less_introduction");
    expand1.textContent = "全てを表示▼";
  }
}
// ユーザープロフィールページのレビューのアコーディオン機能
var wrappers = document.querySelectorAll("div.text_second_wrapper");
document.querySelectorAll("div.text_first_wrapper").forEach((wrapper, index) => {
  var height = wrapper.clientHeight;
  if (height > 100) {
    wrapper.className = "less_text";
    var expand2 = document.createElement("a");
    expand2.textContent = "全てを表示▼";
    expand2.className = "expand";
    wrapper.parentNode.insertBefore(expand2, wrapper.nextSibling); 
    expand2.addEventListener("click", () => {
      accordion2(wrapper, expand2);
    });
  }
});
function accordion2(target, expand2) {
  if (target.className === "less_text") {
    target.className = "text_first_wrapper";
    expand2.textContent = "折りたたむ▲";
  } else {
    target.className = "less_text";
    expand2.textContent = "全てを表示▼";
  }
}
