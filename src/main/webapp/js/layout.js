/* ==========================================================================
   POLYBUILDING - MOBILE RESPONSIVE SIDEBAR TOGGLE SCRIPT
   ========================================================================== */

document.addEventListener('DOMContentLoaded', function () {
  var sidebar = document.querySelector('.sidebar');
  if (!sidebar) return;

  var brand = sidebar.querySelector('.sidebar-brand');
  if (brand && !brand.querySelector('.sidebar-toggle')) {
    var toggleBtn = document.createElement('button');
    toggleBtn.type = 'button';
    toggleBtn.className = 'sidebar-toggle';
    toggleBtn.setAttribute('aria-label', 'Toggle Navigation Menu');
    toggleBtn.innerHTML = '\u2630';
    brand.appendChild(toggleBtn);

    toggleBtn.addEventListener('click', function (e) {
      e.stopPropagation();
      sidebar.classList.toggle('open');
    });
  }

  // Close sidebar when clicking outside on mobile
  document.addEventListener('click', function (e) {
    if (sidebar.classList.contains('open') && !sidebar.contains(e.target)) {
      sidebar.classList.remove('open');
    }
  });

  // Close sidebar when clicking a nav item on mobile
  var navItems = sidebar.querySelectorAll('.nav-item, .sidebar-nav a, a.nav-link');
  navItems.forEach(function (item) {
    item.addEventListener('click', function () {
      if (window.innerWidth <= 768) {
        sidebar.classList.remove('open');
      }
    });
  });
});
