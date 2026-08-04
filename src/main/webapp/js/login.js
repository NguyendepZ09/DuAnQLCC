/* ==========================================================================
   POLYBUILDING - LOGIN PAGE SCRIPT (AJAX FETCH FOR JSP/SERVLET)
   ========================================================================== */

document.addEventListener('DOMContentLoaded', () => {
  initRoleTabs();
  initMethodTabs();
  initPasswordToggle();
  initDemoAccountFiller();
  initQRScannerSimulation();
  initAsideTowerMotif();
  initFormSubmission();
});

// Role data for 6 system roles
const roleConfig = {
  cudan: {
    headline: "Một mái nhà,<br>một lần đăng nhập.",
    subText: "Cư dân, nhân viên vận hành và ban quản lý cùng sử dụng một nền tảng — mỗi vai trò có không gian làm việc riêng.",
    formTitle: "Đăng nhập Cư dân",
    formLede: "Xem thông báo, gửi phản ánh sự cố, xem/thanh toán hóa đơn & đặt tiện ích công cộng.",
    placeholder: "cudan.p101",
    demoUser: "cudan.p101",
    demoPass: "123456",
    helpNote: 'Chưa có tài khoản? <b>Liên hệ Ban quản lý</b> tại quầy lễ tân để được cấp tài khoản.'
  },
  letan: {
    headline: "Tiếp nhận & Điều phối<br>dịch vụ tòa nhà.",
    subText: "Lễ tân tiếp nhận phản ánh, phân loại mức ưu tiên, giao việc kỹ thuật và quản lý hồ sơ cư dân / thẻ từ.",
    formTitle: "Đăng nhập Lễ tân",
    formLede: "Dành cho nhân viên lễ tân tiếp nhận & phân loại yêu cầu cư dân.",
    placeholder: "letan.thi",
    demoUser: "letan.thi",
    demoPass: "123456",
    helpNote: 'Quên tài khoản làm việc? <b>Liên hệ Ban quản lý</b> để khôi phục.'
  },
  kythuat: {
    headline: "Quản lý ca sửa chữa<br>& Nghiệm thu thực tế.",
    subText: "Kỹ thuật viên nhận nhiệm vụ điều phối, cập nhật trạng thái sửa chữa kèm hình ảnh đối chiếu trước/sau.",
    formTitle: "Đăng nhập Kỹ thuật",
    formLede: "Dành cho đội ngũ kỹ thuật viên quản lý ca sửa chữa sự cố tòa nhà.",
    placeholder: "kythuat.nam",
    demoUser: "kythuat.nam",
    demoPass: "123456",
    helpNote: 'Cần cấp lại phân quyền? <b>Liên hệ Quản trị hệ thống</b>.'
  },
  ketoan: {
    headline: "Quản lý tài chính,<br>chỉ số & Hóa đơn.",
    subText: "Nhập chỉ số điện nước, xuất hóa đơn hàng loạt, tạo mã QR thanh toán tự động và kiểm soát dòng tiền.",
    formTitle: "Đăng nhập Kế toán",
    formLede: "Dành cho bộ phận kế toán đối soát công nợ & xuất hóa đơn dịch vụ.",
    placeholder: "ketoan.lan",
    demoUser: "ketoan.lan",
    demoPass: "123456",
    helpNote: 'Cần hỗ trợ module tài chính? <b>Liên hệ Trưởng ban quản lý</b>.'
  },
  baove: {
    headline: "An ninh 24/7,<br>Tuần tra & Quét QR.",
    subText: "Tra cứu chủ xe qua biển số, quét mã QR các tầng khi tuần tra, báo cáo vi phạm và ghi nhật ký ca trực.",
    formTitle: "Đăng nhập Bảo vệ",
    formLede: "Dành cho nhân viên bảo vệ giám sát an ninh & nhật ký tuần tra.",
    placeholder: "baove.hung",
    demoUser: "baove.hung",
    demoPass: "123456",
    helpNote: 'Gặp sự cố hệ thống thẻ từ? <b>Liên hệ Kỹ thuật viên trực ca</b>.'
  },
  banquanly: {
    headline: "Bảng điều khiển tổng quan<br>& Sơ đồ 200 căn hộ.",
    subText: "Thống kê doanh thu, theo dõi hiệu suất vận hành, quản lý sơ đồ 25 tầng x 8 căn hộ và cấp quyền tài khoản.",
    formTitle: "Đăng nhập Ban quản lý",
    formLede: "Dành cho Quản trị viên (Admin) và Ban giám đốc điều hành tòa nhà.",
    placeholder: "bql.admin",
    demoUser: "bql.admin",
    demoPass: "123456",
    helpNote: 'Bảo mật hệ thống: Khóa/mở tài khoản nhanh khi có biến động nhân sự.'
  }
};

let currentRole = 'cudan';

/* Role Switcher Logic */
function initRoleTabs() {
  const roleTabs = document.querySelectorAll('.role-tab');
  const asideH1 = document.getElementById('asideHeadline');
  const asideSub = document.getElementById('asideSub');
  const formTitle = document.getElementById('formTitle');
  const formLede = document.getElementById('formLede');
  const usernameInput = document.getElementById('username');
  const helpNote = document.getElementById('helpNote');
  const banner = document.getElementById('errorBanner');

  roleTabs.forEach(tab => {
    tab.addEventListener('click', () => {
      roleTabs.forEach(t => t.classList.remove('active'));
      tab.classList.add('active');

      currentRole = tab.dataset.role;
      const config = roleConfig[currentRole] || roleConfig['cudan'];

      [asideH1, formTitle, formLede, helpNote].forEach(el => {
        if (el) el.style.opacity = 0;
      });

      setTimeout(() => {
        if (asideH1) asideH1.innerHTML = config.headline;
        if (asideSub) asideSub.textContent = config.subText;
        if (formTitle) formTitle.textContent = config.formTitle;
        if (formLede) formLede.textContent = config.formLede;
        if (usernameInput) usernameInput.placeholder = `vd: ${config.placeholder}`;
        if (helpNote) helpNote.innerHTML = config.helpNote;

        [asideH1, formTitle, formLede, helpNote].forEach(el => {
          if (el) el.style.opacity = 1;
        });
      }, 150);

      if (banner) banner.classList.remove('show');
    });
  });
}

/* Password vs QR Method Tabs */
function initMethodTabs() {
  const methodTabs = document.querySelectorAll('.method-tab');
  const passwordForm = document.getElementById('passwordForm');
  const qrPanel = document.getElementById('qrPanel');
  const banner = document.getElementById('errorBanner');

  methodTabs.forEach(tab => {
    tab.addEventListener('click', () => {
      methodTabs.forEach(t => t.classList.remove('active'));
      tab.classList.add('active');

      const isQr = tab.dataset.method === 'qr';
      if (passwordForm) passwordForm.style.display = isQr ? 'none' : 'block';
      if (qrPanel) qrPanel.classList.toggle('active', isQr);

      if (banner) banner.classList.remove('show');
    });
  });
}

/* Password Eye Toggle */
function initPasswordToggle() {
  const eyeToggle = document.getElementById('eyeToggle');
  const passwordInput = document.getElementById('password');

  if (!eyeToggle || !passwordInput) return;

  eyeToggle.addEventListener('click', () => {
    const isPass = passwordInput.type === 'password';
    passwordInput.type = isPass ? 'text' : 'password';
    eyeToggle.innerHTML = isPass
      ? `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><path d="M3 3l18 18M10.6 10.6a3 3 0 004.2 4.2M9.9 5.1A11 11 0 0123 12s-1.5 2.6-4.2 4.6M6.1 6.1C3.9 7.6 2 9.9 1 12c0 0 4 7 11 7 1.4 0 2.7-.3 3.9-.8"/></svg>`
      : `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7-11-7-11-7z"/><circle cx="12" cy="12" r="3"/></svg>`;
  });
}

/* Quick Fill Demo Account */
function initDemoAccountFiller() {
  const btnFillDemo = document.getElementById('btnFillDemo');
  const usernameInput = document.getElementById('username');
  const passwordInput = document.getElementById('password');

  if (!btnFillDemo || !usernameInput || !passwordInput) return;

  btnFillDemo.addEventListener('click', () => {
    const config = roleConfig[currentRole] || roleConfig['cudan'];
    usernameInput.value = config.demoUser;
    passwordInput.value = config.demoPass;

    showBannerSuccess(`Đã điền tài khoản mẫu [${config.formTitle}]: ${config.demoUser}`);
  });
}

/* QR / NFC Scanner Guidance */
function initQRScannerSimulation() {
  const qrGrid = document.getElementById('qrGrid');

  if (qrGrid) {
    qrGrid.innerHTML = Array.from({ length: 36 }).map(() => '<div></div>').join('');
  }
}

/* Tower Motif on Left Aside */
function initAsideTowerMotif() {
  const asideTower = document.getElementById('asideTower');
  if (!asideTower) return;

  asideTower.innerHTML = Array.from({ length: 25 * 4 }).map(() => {
    const lit = Math.random() < 0.38;
    return `<div class="${lit ? 'lit' : ''}"></div>`;
  }).join('');
}

/* Form Submission Handler with AJAX FETCH to LoginServlet */
function initFormSubmission() {
  const passwordForm = document.getElementById('passwordForm');
  const usernameInput = document.getElementById('username');
  const passwordInput = document.getElementById('password');
  const btnSubmit = document.getElementById('btnSubmitLogin');

  if (!passwordForm) return;

  passwordForm.addEventListener('submit', (e) => {
    e.preventDefault();

    const username = usernameInput.value.trim();
    const password = passwordInput.value.trim();

    if (!username || !password) {
      showBannerError('Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu.');
      return;
    }

    // Disable button while processing
    if (btnSubmit) {
      btnSubmit.disabled = true;
      btnSubmit.style.opacity = '0.7';
    }

    const params = new URLSearchParams();
    params.append('tenDangNhap', username);
    params.append('matKhau', password);
    params.append('vaiTro', currentRole);

    // Call LoginServlet @WebServlet("/login")
    fetch('login', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
      },
      body: params.toString()
    })
    .then(response => {
      if (!response.ok) {
        throw new Error('Lỗi kết nối máy chủ (' + response.status + ')');
      }
      return response.json();
    })
    .then(data => {
      if (btnSubmit) {
        btnSubmit.disabled = false;
        btnSubmit.style.opacity = '1';
      }

      if (data.success) {
        showBannerSuccess(data.message + ' Chào mừng ' + (data.hoTen || username) + '!');
        setTimeout(() => {
          if (data.redirectUrl) {
            window.location.href = data.redirectUrl;
          }
        }, 1000);
      } else {
        showBannerError(data.message || 'Đăng nhập không thành công.');
      }
    })
    .catch(err => {
      if (btnSubmit) {
        btnSubmit.disabled = false;
        btnSubmit.style.opacity = '1';
      }
      console.warn('Backend server response check:', err);
      showBannerError('Không kết nối được Server hoặc Server chưa khởi chạy Tomcat.');
    });
  });
}

function showBannerError(msg) {
  const banner = document.getElementById('errorBanner');
  if (!banner) return;
  banner.classList.remove('success-mode');
  banner.querySelector('span').textContent = msg;
  banner.classList.add('show');
}

function showBannerSuccess(msg) {
  const banner = document.getElementById('errorBanner');
  if (!banner) return;
  banner.classList.add('success-mode');
  banner.querySelector('span').textContent = msg;
  banner.classList.add('show');
}
