$(function() {
  // フレンド募集の最後の投稿の直後にクリアフィックスを追加
  var clearfix = $('<div>', { class:'clearfix' });
  $(".index_recruitments").append(clearfix);
  // フレンド募集内でモーダルにアクセスするためのリンクを表示する
  // $("div.description_wrapper").each(function(index){
  //   var height = $(this).height(); 
  //   if (height > 120) {
  //     var modal_link = $('<a>', { text:"全てを表示",class:'modal_link' });
  //     modal_link.attr('data-toggle', 'modal');
  //     modal_link.attr('data-target', 'exampleModal');
  //     $(this).append(modal_link);
  //   }
  //   console.log(height);
  // });
});

// フレンド募集内でモーダルにアクセスするためのリンクを表示する
var descriptions = document.querySelectorAll("p.description");
document.querySelectorAll("div.description_wrapper").forEach((wrapper, index) => {
  if (wrapper.clientHeight > 120) {
    var modallink = document.createElement("a");
    modallink.textContent = "全てを表示";
    modallink.className = "modallink";
    modallink.setAttribute('data-toggle', 'modal');
    modallink.setAttribute('data-target', 'exampleModal');
    descriptions[index].parentNode.insertBefore(modallink, descriptions[index].nextSibling); 
  }
});
// games/showでのアコーディオン機能
var wrapper = document.getElementById("summary_first_wrapper");
var height = wrapper.clientHeight;
if (height > 222) {
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

