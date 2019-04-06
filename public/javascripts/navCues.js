document.addEventListener('DOMContentLoaded', function() {

  const anchors = document.querySelectorAll('a');
  const topBorder = document.getElementsByClassName('border')[0];

  const toggleOverClassOnAnchor = (event) => {
    event.target.classList.contains('current') || event.target.classList.toggle('over');
  };

  const alterTopBorderColor = () => {
    topBorder && (topBorder.style.backgroundColor = 'rgba(255,0,0,1.0)');
  };

  anchors.forEach(function(a) {
    a.addEventListener('mouseenter', (e) => {
      toggleOverClassOnAnchor(e);
    });

    a.addEventListener('mouseleave', (e) => {
      toggleOverClassOnAnchor(e);
    });

    a.addEventListener('click', (e) => {
      alterTopBorderColor();
    });
  });
});
