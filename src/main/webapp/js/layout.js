/* ==========================================================================
   POLYBUILDING - MOBILE RESPONSIVE SIDEBAR & LAYOUT SCRIPT
   ========================================================================== */

document.addEventListener('DOMContentLoaded', () => {
  const sidebar = document.querySelector('.sidebar');
  if (!sidebar) return;

  const brand = sidebar.querySelector('.sidebar-brand');
  if (brand && !brand.querySelector('.sidebar-toggle')) {
    const toggleBtn = document.createElement('button');
    toggleBtn.type = 'button';
    toggleBtn.className = 'sidebar-toggle';
    toggleBtn.setAttribute('aria-label', 'Toggle Navigation Menu');
    toggleBtn.innerHTML = '☰';
    brand.appendChild(toggleBtn);

    toggleBtn.addEventListener('click', (e) => {
      e.stopPropagation();
      sidebar.classList.toggle('open');
    });
  }

  // Close sidebar on mobile when clicking outside
  document.addEventListener('click', (e) => {
    if (sidebar.classList.contains('open') && !sidebar.contains(e.target)) {
      sidebar.classList.remove('open');
    }
  });

  // Close sidebar when clicking any navigation link on mobile
  const navItems = sidebar.querySelectorAll('.nav-item, .sidebar-nav a');
  navItems.forEach(item => {
    item.addEventListener('click', () => {
      if (window.innerWidth <= 768) {
        sidebar.classList.remove('open');
      }
    });
  });
});
