// games/indexでのアコーディオン機能
var wrappers = document.querySelectorAll("div.summary_second_wrapper");
document.querySelectorAll("div.summary_first_wrapper").forEach((wrapper) => {
  var height = wrapper.clientHeight;
  if (height > 100) {
    wrapper.className = "less_summary";
    var expand = document.createElement("a");
    expand.textContent = "全てを表示▼";
    expand.className = "expand";
    wrapper.parentNode.insertBefore(expand, wrapper.nextSibling); 
    expand.addEventListener("click", () => {
      accordion1(wrapper, expand);
    });
  }
});
function accordion1(target, expand) {
  if (target.className === "less_summary") {
    target.className = "summary_first_wrapper";
    expand.textContent = "折りたたむ▲";
  } else {
    target.className = "less_summary";
    expand.textContent = "全てを表示▼";
  }
}
