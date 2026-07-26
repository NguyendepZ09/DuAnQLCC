/* ==========================================================================
   POLYBUILDING - INTRO PAGE SCRIPT
   ========================================================================== */

document.addEventListener('DOMContentLoaded', () => {
  initNavbarScroll();
  initFloorDiagram();
  initSmoothScroll();
});

/* Navbar scroll effect */
function initNavbarScroll() {
  const header = document.querySelector('header');
  if (!header) return;

  const checkScroll = () => {
    if (window.scrollY > 40) {
      header.classList.add('scrolled');
    } else {
      header.classList.remove('scrolled');
    }
  };

  window.addEventListener('scroll', checkScroll);
  checkScroll();
}

/* Floor diagram 25 floors x 8 apartments */
function initFloorDiagram() {
  const towerGrid = document.getElementById('towerGrid');
  const countOccupiedEl = document.getElementById('countOccupied');
  const countVacantEl = document.getElementById('countVacant');
  const countMaintEl = document.getElementById('countMaint');

  if (!towerGrid) return;

  let occupiedCount = 0;
  let vacantCount = 0;
  let maintCount = 0;

  // Render 25 floors
  for (let floor = 25; floor >= 1; floor--) {
    const floorCol = document.createElement('div');
    floorCol.className = 'floor-column';

    const floorNum = document.createElement('div');
    floorNum.className = 'floor-number';
    floorNum.textContent = `T${floor}`;
    floorCol.appendChild(floorNum);

    // 8 apartments per floor
    for (let aptIndex = 1; aptIndex <= 8; aptIndex++) {
      const aptBox = document.createElement('div');
      aptBox.className = 'apt-box';

      // Determine status pseudo-randomly for realistic view
      const rand = Math.random();
      let status = 'occupied';
      let statusText = 'Đã có chủ ở';
      let residentName = `Hộ gia đình P.${floor}0${aptIndex}`;

      if (rand < 0.22) {
        status = 'vacant';
        statusText = 'Căn hộ trống (Sẵn sàng bán/cho thuê)';
        residentName = 'Đang trống';
        vacantCount++;
      } else if (rand < 0.27) {
        status = 'maintenance';
        statusText = 'Đang bảo trì / Sửa chữa';
        residentName = 'Đang sửa chữa';
        maintCount++;
      } else {
        occupiedCount++;
      }

      aptBox.classList.add(status);

      const aptCode = `P.${floor}${aptIndex < 10 ? '0' + aptIndex : aptIndex}`;
      const area = 65 + (aptIndex % 4) * 15; // 65m², 80m², 95m², 110m²

      const tooltip = document.createElement('div');
      tooltip.className = 'apt-tooltip';
      tooltip.innerHTML = `<strong>${aptCode}</strong> (${area}m²)<br>${statusText}`;

      aptBox.appendChild(tooltip);
      floorCol.appendChild(aptBox);

      aptBox.addEventListener('click', () => {
        showToast(`Căn hộ ${aptCode}: ${statusText} | Diện tích: ${area}m²`);
      });
    }

    towerGrid.appendChild(floorCol);
  }

  if (countOccupiedEl) countOccupiedEl.textContent = occupiedCount;
  if (countVacantEl) countVacantEl.textContent = vacantCount;
  if (countMaintEl) countMaintEl.textContent = maintCount;
}

/* Smooth Scrolling */
function initSmoothScroll() {
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function(e) {
      const targetId = this.getAttribute('href');
      if (targetId === '#') return;
      
      const targetEl = document.querySelector(targetId);
      if (targetEl) {
        e.preventDefault();
        const headerOffset = 80;
        const elementPosition = targetEl.getBoundingClientRect().top;
        const offsetPosition = elementPosition + window.pageYOffset - headerOffset;

        window.scrollTo({
          top: offsetPosition,
          behavior: 'smooth'
        });
      }
    });
  });
}

/* Toast Utility */
function showToast(message, type = 'info') {
  let container = document.querySelector('.toast-container');
  if (!container) {
    container = document.createElement('div');
    container.className = 'toast-container';
    document.body.appendChild(container);
  }

  const toast = document.createElement('div');
  toast.className = `toast ${type}`;
  toast.innerHTML = `
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
      <circle cx="12" cy="12" r="10"/><path d="M12 16v-4M12 8h.01"/>
    </svg>
    <span>${message}</span>
  `;

  container.appendChild(toast);

  setTimeout(() => toast.classList.add('show'), 10);
  setTimeout(() => {
    toast.classList.remove('show');
    setTimeout(() => toast.remove(), 400);
  }, 3500);
}
