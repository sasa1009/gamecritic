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
      $('.modal-'+index).find('.modal-close-'+index).on('click',function(){
        $('.modal-'+index).fadeOut();
        return false;
      });
    }
  });
});

// ゲーム詳細ページのゲーム概要のアコーディオン機能
var wrapper = document.getElementById("summary_first_wrapper");
var height = wrapper.clientHeight;
if (height > 210) {
  wrapper.className = "less_summary";
  var expand = document.createElement("a");
  expand.textContent = "全てを表示▼";
  expand.id = "expand"
  wrapper.parentNode.insertBefore(expand, wrapper.nextSibling); 
  var string = "summary"
  expand.addEventListener("click", () => {
    accordion2(wrapper, expand, "summary");
  });
}
// ゲーム詳細ページのレビューのアコーディオン機能
var wrappers = document.querySelectorAll("div.text_second_wrapper");
document.querySelectorAll("div.text_first_wrapper").forEach((wrapper, index) => {
  var height = wrapper.clientHeight;
  if (height > 100) {
    wrapper.className = "less_text";
    var expand = document.createElement("a");
    expand.textContent = "全てを表示▼";
    expand.className = "expand";
    wrapper.parentNode.insertBefore(expand, wrapper.nextSibling); 
    expand.addEventListener("click", () => {
      accordion2(wrapper, expand, "text");
    });
    text = "text";
  }
});
function accordion2(target, expand, string) {
  if (target.className === "less_" + string) {
    if (string === "summary") {
      target.className = "summary_first_wrapper";
    } else {
      target.className = "text_first_wrapper";
    }
    expand.textContent = "折りたたむ▲";
  } else {
    target.className = "less_" + string;
    expand.textContent = "全てを表示▼";
  }
}

