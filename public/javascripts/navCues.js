document.addEventListener('DOMContentLoaded', function() {
  let anchors = document.querySelectorAll('a');

  anchors.forEach(function(a) {
    a.addEventListener('mouseenter', function(e) {
      e.target.classList.toggle("over");
      // setTimeout( () => e.target.classList.remove("over"), 375);
    });

    a.addEventListener('mouseleave', function(e) {
      e.target.classList.toggle("over");
    });

    // a.addEventListener('hover', function(e) {
    //   e.target.style.color = "red";
    // });
  });
});
