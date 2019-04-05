document.addEventListener('DOMContentLoaded', function() {
  let anchors = document.querySelectorAll('a');
  let topBorder = document.getElementsByClassName('border')[0];

  anchors.forEach(function(a) {
    a.addEventListener('mouseenter', function(e) {
      if (!e.target.classList.contains('current')) {
          e.target.classList.toggle('over');
      }
    });

    a.addEventListener('mouseleave', function(e) {
      if (!e.target.classList.contains('current')) {
        e.target.classList.toggle('over');
      }
    });

    a.addEventListener('click', function(e) {
      topBorder.style.backgroundColor = 'rgba(255,0,0,1.0)';
    });
  });
});
