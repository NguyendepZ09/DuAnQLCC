/* ==========================================================================
   POLYBUILDING - INTRO PAGE SCRIPT (MVC COMPLIANT - AGGREGATED STATS ONLY)
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

/* Floor diagram 25 floors x 8 apartments — HIỂN THỊ TỔNG HỢP (KHÔNG LỘ SỐ PHÒNG) */
function initFloorDiagram() {
  const towerGrid = document.getElementById('towerGrid');
  if (!towerGrid) return;

  if (window.BUILDING_STATS && typeof window.BUILDING_STATS === 'object') {
    renderFloorGrid(towerGrid, window.BUILDING_STATS);
  } else {
    renderFloorGridFallback(towerGrid);
  }
}

function renderFloorGrid(towerGrid, stats) {
  const countOccupiedEl = document.getElementById('countOccupied');
  const countVacantEl = document.getElementById('countVacant');
  const countMaintEl = document.getElementById('countMaint');

  const dangO = stats.dangO != null ? stats.dangO : 150;
  const trong = stats.trong != null ? stats.trong : 40;
  const baoTri = stats.baoTri != null ? stats.baoTri : 10;

  if (countOccupiedEl) countOccupiedEl.textContent = dangO;
  if (countVacantEl) countVacantEl.textContent = trong;
  if (countMaintEl) countMaintEl.textContent = baoTri;

  towerGrid.innerHTML = '';

  // Tạo mảng 200 vị trí mô phỏng theo số liệu tổng hợp
  const totalBoxes = 200;
  const boxStatuses = new Array(totalBoxes);

  // Phân bổ trạng thái theo tỷ lệ tổng hợp (deterministic seed)
  let oCount = 0, mCount = 0, vCount = 0;

  for (let i = 0; i < totalBoxes; i++) {
    // Thuật toán rải đều 3 trạng thái theo chỉ số ô
    if ((i * 7 + 3) % 20 < (baoTri * 20 / totalBoxes) && mCount < baoTri) {
      boxStatuses[i] = 'maintenance';
      mCount++;
    } else if (oCount < dangO) {
      boxStatuses[i] = 'occupied';
      oCount++;
    } else {
      boxStatuses[i] = 'vacant';
      vCount++;
    }
  }

  let index = 0;

  // Render từ tầng 25 xuống tầng 1
  for (let floor = 25; floor >= 1; floor--) {
    const floorCol = document.createElement('div');
    floorCol.className = 'floor-column';

    const floorNum = document.createElement('div');
    floorNum.className = 'floor-number';
    floorNum.textContent = `T${floor}`;
    floorCol.appendChild(floorNum);

    // 8 căn mỗi tầng
    for (let aptIndex = 1; aptIndex <= 8; aptIndex++) {
      const aptBox = document.createElement('div');
      aptBox.className = 'apt-box';

      const st = boxStatuses[index++] || 'vacant';
      aptBox.classList.add(st);

      let statusText = 'Căn hộ trống (Sẵn sàng cho thuê)';
      if (st === 'occupied') statusText = 'Đã có cư dân ở';
      else if (st === 'maintenance') statusText = 'Đang bảo trì';

      const tooltip = document.createElement('div');
      tooltip.className = 'apt-tooltip';
      tooltip.innerHTML = `<strong>Tháp PolyBuilding — Tầng ${floor}</strong><br>${statusText}`;

      aptBox.appendChild(tooltip);
      floorCol.appendChild(aptBox);

      aptBox.addEventListener('click', () => {
        showToast(`Căn hộ Tầng ${floor}: ${statusText}`);
      });
    }

    towerGrid.appendChild(floorCol);
  }
}

/* Fallback nếu không có BUILDING_STATS */
function renderFloorGridFallback(towerGrid) {
  const countOccupiedEl = document.getElementById('countOccupied');
  const countVacantEl = document.getElementById('countVacant');
  const countMaintEl = document.getElementById('countMaint');

  if (countOccupiedEl) countOccupiedEl.textContent = '150';
  if (countVacantEl) countVacantEl.textContent = '40';
  if (countMaintEl) countMaintEl.textContent = '10';

  renderFloorGrid(towerGrid, { tongCan: 200, dangO: 150, trong: 40, baoTri: 10 });
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
