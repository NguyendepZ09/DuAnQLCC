<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Đăng Nhập — POLYBUILDING</title>
  <meta name="description" content="Cổng đăng nhập hệ thống quản lý chung cư Polybuilding dành cho Cư dân, Lễ tân, Kỹ thuật, Kế toán, Bảo vệ và Ban quản lý.">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
  <style>
    html::-webkit-scrollbar, body::-webkit-scrollbar, ::-webkit-scrollbar {
      width: 4px !important; height: 4px !important;
    }
    html::-webkit-scrollbar-track, body::-webkit-scrollbar-track, ::-webkit-scrollbar-track {
      background: transparent !important;
    }
    html::-webkit-scrollbar-thumb, body::-webkit-scrollbar-thumb, ::-webkit-scrollbar-thumb {
      background: rgba(27, 67, 50, 0.35) !important; border-radius: 99px !important;
    }
    html::-webkit-scrollbar-thumb:hover, body::-webkit-scrollbar-thumb:hover, ::-webkit-scrollbar-thumb:hover {
      background: rgba(27, 67, 50, 0.75) !important;
    }
    * {
      scrollbar-width: thin !important;
      scrollbar-color: rgba(27, 67, 50, 0.35) transparent !important;
    }
  </style>
</head>
<body>

<div class="shell">

  <!-- ===== LEFT / BRAND ASIDE ===== -->
  <aside class="aside">
    <div>
      <a href="${pageContext.request.contextPath}/" class="brand" id="asideBrand">
        <span class="mark"></span>POLYBUILDING
      </a>
      <a href="${pageContext.request.contextPath}/" class="back-link" id="asideBackLink">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5M11 6l-6 6 6 6"/></svg>
        Về trang giới thiệu
      </a>
    </div>

    <div class="aside-mid">
      <div class="aside-eyebrow">Cổng đăng nhập hệ thống</div>
      <h1 id="asideHeadline">Một mái nhà,<br>một lần đăng nhập.</h1>
      <p class="sub" id="asideSub">Cư dân, nhân viên vận hành và ban quản lý cùng sử dụng một nền tảng — mỗi vai trò có không gian làm việc riêng ngay sau khi đăng nhập.</p>

      <div class="aside-stats">
        <div class="stat"><span class="num">25</span><span class="lbl">Tầng tháp</span></div>
        <div class="stat"><span class="num">200</span><span class="lbl">Căn hộ</span></div>
        <div class="stat"><span class="num">6</span><span class="lbl">Vai trò</span></div>
      </div>
      <div class="aside-tower" id="asideTower"></div>
    </div>

    <div class="aside-foot">© 2026 Polybuilding — Đồ án Quản Lý Chung Cư</div>
  </aside>

  <!-- ===== RIGHT / FORM MAIN ===== -->
  <main class="main">
    <div class="login-card">
      <div class="eyebrow">Đăng nhập cổng thông tin</div>
      <h2 id="formTitle">Đăng nhập Cư dân</h2>
      <p class="lede" id="formLede">Xem thông báo, gửi phản ánh sự cố, xem/thanh toán hóa đơn & đặt tiện ích công cộng.</p>

      <!-- 6 Role Selection Tabs -->
      <div class="role-tabs-6">
        <div class="role-tab active" data-role="cudan" id="roleCudan">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
          Cư dân
        </div>
        <div class="role-tab" data-role="letan" id="roleLetan">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="3" y="4" width="18" height="16" rx="2"/><line x1="7" y1="8" x2="17" y2="8"/><line x1="7" y1="12" x2="13" y2="12"/></svg>
          Lễ tân
        </div>
        <div class="role-tab" data-role="kythuat" id="roleKythuat">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M14.7 6.3a1 1 0 000 1.4l1.6 1.6a1 1 0 001.4 0l3.77-3.77a6 6 0 01-7.94 7.94l-6.91 6.91a2.12 2.12 0 01-3-3l6.91-6.91a6 6 0 017.94-7.94l-3.76 3.76z"/></svg>
          Kỹ thuật
        </div>
        <div class="role-tab" data-role="ketoan" id="roleKetoan">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/></svg>
          Kế toán
        </div>
        <div class="role-tab" data-role="baove" id="roleBaove">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
          Bảo vệ
        </div>
        <div class="role-tab" data-role="banquanly" id="roleBanquanly">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M18 20V10M12 20V4M6 20v-6"/></svg>
          Ban quản lý
        </div>
      </div>

      <!-- Quick Demo Credentials Helper -->
      <div class="quick-fill">
        <span class="quick-fill-label">⚡ Tài khoản demo có sẵn</span>
        <button type="button" class="btn-demo-acc" id="btnFillDemo">Tự động điền mẫu</button>
      </div>

      <!-- Method selection (Password vs QR) -->
      <div class="method-tabs">
        <div class="method-tab active" data-method="password" id="methodPassword">Mật khẩu</div>
        <div class="method-tab" data-method="qr" id="methodQr">Quét mã thẻ cư dân / QR</div>
      </div>

      <!-- Alert Banner -->
      <div class="error-banner" id="errorBanner">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="9"/><path d="M12 8v5M12 16h.01"/></svg>
        <span>Tên đăng nhập hoặc mật khẩu chưa đúng. Vui lòng thử lại.</span>
      </div>

      <!-- Form 1: Password Form -->
      <form id="passwordForm" action="${pageContext.request.contextPath}/login" method="post">
        <div class="field">
          <label for="username">Tên đăng nhập</label>
          <input type="text" id="username" name="username" placeholder="vd: cudan.p101" autocomplete="username">
        </div>
        <div class="field">
          <label for="password">Mật khẩu</label>
          <div class="input-wrap">
            <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" autocomplete="current-password">
            <button type="button" class="eye-toggle" id="eyeToggle" aria-label="Hiện mật khẩu">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7-11-7-11-7z"/><circle cx="12" cy="12" r="3"/></svg>
            </button>
          </div>
        </div>
        <div class="row-between">
          <label class="remember">
            <input type="checkbox" id="remember" name="remember">
            <span class="checkbox"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><path d="M4 12l5 5L20 6"/></svg></span>
            Ghi nhớ đăng nhập
          </label>
          <a href="#" class="forgot">Quên mật khẩu?</a>
        </div>
        <button type="submit" class="btn-submit" id="btnSubmitLogin">
          Đăng nhập ngay
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 12h14M13 6l6 6-6 6"/></svg>
        </button>
      </form>

      <!-- Panel 2: QR Code Camera Scanner Simulation -->
      <div class="qr-panel" id="qrPanel">
        <div class="qr-frame">
          <div class="grid-mini" id="qrGrid"></div>
          <span class="corner tl"></span><span class="corner tr"></span><span class="corner bl"></span><span class="corner br"></span>
          <div class="scan-line"></div>
        </div>
        <h3>Đưa thẻ cư dân vào khung quét</h3>
        <p>Hệ thống tự động đọc mã chip NFC / QR Code trên thẻ cư dân để đăng nhập trực tiếp mà không cần mật khẩu.</p>
        <button type="button" class="btn-simulate-qr" id="btnSimulateQr">Quét thử mã thẻ cư dân</button>
      </div>

      <div class="divider">hoặc</div>
      <p class="help-note" id="helpNote">Chưa có tài khoản? <b>Liên hệ Ban quản lý</b> tại quầy lễ tân để được cấp tài khoản.</p>
    </div>
  </main>

</div>

<script src="${pageContext.request.contextPath}/js/login.js"></script>
</body>
</html>
