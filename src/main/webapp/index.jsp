<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>POLYBUILDING — Hệ Thống Quản Lý Chung Cư 25 Tầng Ven Sông</title>
  <meta name="description" content="Nền tảng quản lý vận hành chung cư thông minh Polybuilding. Kết nối cư dân, lễ tân, kỹ thuật, kế toán, bảo vệ và ban quản lý trong cùng một hệ thống.">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/intro.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <style>
    /* Custom Ultra-Thin & Sleek Scrollbar (Thanh cuộn siêu mỏng 4px) */
    html::-webkit-scrollbar,
    body::-webkit-scrollbar,
    ::-webkit-scrollbar {
      width: 4px !important;
      height: 4px !important;
    }
    html::-webkit-scrollbar-track,
    body::-webkit-scrollbar-track,
    ::-webkit-scrollbar-track {
      background: transparent !important;
    }
    html::-webkit-scrollbar-thumb,
    body::-webkit-scrollbar-thumb,
    ::-webkit-scrollbar-thumb {
      background: rgba(27, 67, 50, 0.35) !important;
      border-radius: 99px !important;
    }
    html::-webkit-scrollbar-thumb:hover,
    body::-webkit-scrollbar-thumb:hover,
    ::-webkit-scrollbar-thumb:hover {
      background: rgba(27, 67, 50, 0.75) !important;
    }
    * {
      scrollbar-width: thin !important;
      scrollbar-color: rgba(27, 67, 50, 0.35) transparent !important;
    }

    /* ===== APPLE BROWSER WINDOW SHELL MOCKUP SECTION ===== */
    .preview-section {
        padding: 80px 0;
        background: #fbf9f5;
        border-top: 1px solid rgba(22, 35, 31, 0.08);
        border-bottom: 1px solid rgba(22, 35, 31, 0.08);
    }
    .preview-shell {
        background: #ffffff;
        border: 1px solid rgba(22, 35, 31, 0.12);
        border-radius: 20px;
        overflow: hidden;
        box-shadow: 0 16px 45px rgba(22, 35, 31, 0.08);
        margin-top: 28px;
    }
    .preview-topbar {
        background: #f4efe4;
        border-bottom: 1px solid rgba(22, 35, 31, 0.10);
        padding: 12px 20px;
        display: flex;
        align-items: center;
        justify-content: space-between;
    }
    .topbar-dots {
        display: flex;
        gap: 8px;
    }
    .dot {
        width: 12px;
        height: 12px;
        border-radius: 50%;
        display: inline-block;
    }
    .dot-red { background: #e05244; }
    .dot-yellow { background: #f0b429; }
    .dot-green { background: #2e7d32; }

    .url-bar {
        background: #ffffff;
        border: 1px solid rgba(22, 35, 31, 0.12);
        border-radius: 8px;
        padding: 4px 18px;
        font-size: 0.78rem;
        color: #233731;
        display: flex;
        align-items: center;
        gap: 8px;
        font-family: inherit;
        font-weight: 500;
    }

    .preview-inner {
        display: grid;
        grid-template-columns: 240px 1fr;
        background: #ffffff;
    }

    .psb {
        background: #fbf9f5;
        border-right: 1px solid rgba(22, 35, 31, 0.08);
        padding: 18px 12px;
        display: flex;
        flex-direction: column;
        gap: 6px;
    }

    .psb-sect {
        font-size: 0.68rem;
        font-weight: 800;
        color: #6b7c76;
        letter-spacing: 0.06em;
        margin-bottom: 8px;
        padding-left: 8px;
        text-transform: uppercase;
    }

    .psb-item {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 10px 12px;
        border-radius: 10px;
        font-size: 0.83rem;
        font-weight: 600;
        color: #233731;
        background: transparent;
        border: none;
        cursor: pointer;
        text-align: left;
        transition: all 0.2s ease;
        font-family: inherit;
        width: 100%;
    }
    .psb-item:hover {
        background: #f4efe4;
        color: #16231f;
    }
    .psb-item.act {
        background: #1b4332;
        color: #ffffff;
        font-weight: 700;
        box-shadow: 0 4px 12px rgba(27, 67, 50, 0.18);
    }
    .psb-item.act i {
        color: #d9ae72;
    }

    .tab-panel {
        display: none;
        padding: 32px;
    }
    .tab-panel.active {
        display: block;
    }

    .pstats {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 12px;
        margin-bottom: 16px;
    }
    .pstat {
        background: #fbf9f5;
        border: 1px solid rgba(22, 35, 31, 0.08);
        border-radius: 12px;
        padding: 14px;
        text-align: center;
    }
    .pstat-val {
        font-size: 1.3rem;
        font-weight: 800;
        color: #1b4332;
    }
    .pstat-lbl {
        font-size: 0.72rem;
        color: #556b64;
        font-weight: 600;
    }

    .ptable {
        background: #fbf9f5;
        border: 1px solid rgba(22, 35, 31, 0.08);
        border-radius: 12px;
        padding: 18px;
    }
    .ptable-title {
        font-size: 0.88rem;
        font-weight: 800;
        color: #16231f;
        margin-bottom: 12px;
        display: flex;
        align-items: center;
        gap: 8px;
    }
    .prow {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 9px 0;
        border-bottom: 1px dashed rgba(22, 35, 31, 0.12);
        font-size: 0.82rem;
        color: #233731;
    }
    .prow:last-child {
        border-bottom: none;
    }
    .badge-demo {
        font-size: 0.68rem;
        font-weight: 700;
        padding: 3px 10px;
        border-radius: 99px;
        display: inline-block;
    }
    .badge-demo.green { background: #e8f5e9; color: #1b4332; border: 1px solid #c8e6c9; }
    .badge-demo.violet { background: #fff8e7; color: #8a6733; border: 1px solid #ffe0b2; }
    .badge-demo.cyan { background: #e0f2f1; color: #00695c; border: 1px solid #b2dfdb; }

    @media (max-width: 768px) {
        .preview-inner { grid-template-columns: 1fr; }
        .pstats { grid-template-columns: repeat(2, 1fr); }
    }
  </style>
</head>
<body>

  <!-- ===== NAVBAR ===== -->
  <header>
    <div class="container">
      <nav>
        <a href="${pageContext.request.contextPath}/" class="logo" id="navLogo">
          <span class="mark"></span>
          POLYBUILDING
        </a>
        <ul class="nav-links">
          <li><a href="#overview">Giới thiệu</a></li>
          <li><a href="#floorplan">Sơ đồ 25 Tầng</a></li>
          <li><a href="#roles">Các vai trò</a></li>
          <li><a href="#amenities">Tiện ích nội khu</a></li>
        </ul>
        <div class="nav-actions">
          <a href="${pageContext.request.contextPath}/dang-nhap" class="btn btn-outline" id="navLoginBtn">Đăng nhập ngay</a>
        </div>
      </nav>
    </div>
  </header>

  <!-- ===== HERO SECTION ===== -->
  <section class="hero" id="overview">
    <div class="container">
      <div class="hero-grid">
        <div class="hero-content">
          <div class="hero-badge">⚡ Nền tảng quản lý chung cư thế hệ mới 2026</div>
          <h1>Một mái nhà <span>an yên</span>,<br>Vận hành số chuẩn 5 sao.</h1>
          <p class="description">
            Polybuilding — Dự án chung cư cao cấp 25 tầng ven sông với 200 căn hộ. 
            Giải pháp số hóa toàn diện kết nối Cư dân, Đội ngũ vận hành và Ban quản lý trên duy nhất một nền tảng.
          </p>
          <div class="hero-cta">
            <a href="${pageContext.request.contextPath}/dang-nhap" class="btn btn-primary" id="heroLoginCta">
              Đăng nhập cổng thông tin
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M5 12h14M13 6l6 6-6 6"/>
              </svg>
            </a>
            <a href="#floorplan" class="btn btn-outline" id="heroExploreCta">Khám phá sơ đồ 200 căn hộ</a>
          </div>
          <div class="hero-stats">
            <div class="stat-item">
              <span class="num">25</span>
              <span class="label">Tầng tháp</span>
            </div>
            <div class="stat-item">
              <span class="num">200</span>
              <span class="label">Căn hộ</span>
            </div>
            <div class="stat-item">
              <span class="num">6</span>
              <span class="label">Vai trò vận hành</span>
            </div>
          </div>
        </div>
        <div class="hero-media">
          <div class="hero-img-wrap">
            <img src="${pageContext.request.contextPath}/assets/building.jpg" alt="Tòa tháp Polybuilding 25 tầng ven sông">
          </div>
          <div class="floating-pill pill-1">
            <div class="pill-icon">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
              </svg>
            </div>
            <div class="pill-text">
              <span class="val">Thẻ từ NFC & QR</span>
              <span class="lbl">An ninh tuần tra 24/7</span>
            </div>
          </div>
          <div class="floating-pill pill-2">
            <div class="pill-icon">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <rect x="3" y="4" width="18" height="16" rx="2"/><path d="M7 8h10M7 12h10M7 16h6"/>
              </svg>
            </div>
            <div class="pill-text">
              <span class="val">Thanh toán tự động</span>
              <span class="lbl">Quét VietQR hóa đơn</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- ===== FLOORPLAN DIAGRAM ===== -->
  <section class="building-overview" id="floorplan">
    <div class="container">
      <div class="section-header">
        <div class="eyebrow">Trực quan hóa sơ đồ tòa nhà</div>
        <h2>Sơ đồ 25 Tầng x 8 Căn Hộ (200 Căn)</h2>
        <p>Hiển thị màu sắc trạng thái thời gian thực: Căn có người ở, căn hộ trống và căn hộ đang bảo trì.</p>
      </div>

      <div class="diagram-container">
        <div class="diagram-filter">
          <div class="legend-items">
            <div class="legend-item">
              <span class="dot occupied"></span> Đã có cư dân ở (<strong id="countOccupied">150</strong>)
            </div>
            <div class="legend-item">
              <span class="dot vacant"></span> Căn trống (<strong id="countVacant">40</strong>)
            </div>
            <div class="legend-item">
              <span class="dot maintenance"></span> Đang sửa chữa (<strong id="countMaint">10</strong>)
            </div>
          </div>
          <span style="font-size:0.85rem; color:var(--ink-light);">* Nhấp vào ô vuông căn hộ để xem thông tin chi tiết</span>
        </div>

        <div class="tower-grid" id="towerGrid">
          <!-- Dynamically generated via js/intro.js -->
        </div>
      </div>
    </div>
  </section>

  <!-- ===== ROLES SHOWCASE ===== -->
  <section id="roles">
    <div class="container">
      <div class="section-header">
        <div class="eyebrow">Phân quyền đa vai trò</div>
        <h2>Hệ thống vận hành dành cho 6 đối tượng</h2>
        <p>Mỗi bộ phận được trang bị bảng làm việc chuyên biệt theo đúng chức năng nhiệm vụ.</p>
      </div>

      <div class="roles-grid">
        <!-- Role 1: Cư dân -->
        <div class="role-card">
          <div class="role-icon">
            <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/>
            </svg>
          </div>
          <h3>Cư Dân</h3>
          <p>Không gian cá nhân hóa giúp cư dân quản lý căn hộ, thanh toán phí và tương tác với tòa nhà.</p>
          <ul class="role-features">
            <li>Xem tin tức & bảo trì (điện/nước)</li>
            <li>Tham gia biểu quyết / bình chọn online</li>
            <li>Gửi phản ánh sự cố kèm hình ảnh</li>
            <li>Thanh toán hóa đơn qua VietQR tự động</li>
            <li>Đặt sân Tennis, Pickleball, Bể bơi, BBQ</li>
          </ul>
        </div>

        <!-- Role 2: Lễ tân -->
        <div class="role-card">
          <div class="role-icon">
            <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <rect x="3" y="4" width="18" height="16" rx="2"/><line x1="7" y1="8" x2="17" y2="8"/><line x1="7" y1="12" x2="13" y2="12"/>
            </svg>
          </div>
          <h3>Lễ Tân</h3>
          <p>Quầy dịch vụ khách hàng số, thu nhận khiếu nại và hỗ trợ thủ tục cư dân nhanh chóng.</p>
          <ul class="role-features">
            <li>Tiếp nhận & phân loại ưu tiên sự cố</li>
            <li>Điều phối (Assign task) cho kỹ thuật</li>
            <li>Quản lý hồ sơ cư dân & biến động hộ khẩu</li>
            <li>Kiểm tra trạng thái & hạn thẻ từ NFC</li>
          </ul>
        </div>

        <!-- Role 3: Kỹ thuật -->
        <div class="role-card">
          <div class="role-icon">
            <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M14.7 6.3a1 1 0 000 1.4l1.6 1.6a1 1 0 001.4 0l3.77-3.77a6 6 0 01-7.94 7.94l-6.91 6.91a2.12 2.12 0 01-3-3l6.91-6.91a6 6 0 017.94-7.94l-3.76 3.76z"/>
            </svg>
          </div>
          <h3>Kỹ Thuật</h3>
          <p>Quản lý ca làm việc, xử lý sự cố thiết bị và ghi nhận nghiệm thu thực tế.</p>
          <ul class="role-features">
            <li>Nhận danh sách ca sửa chữa từ Lễ tân</li>
            <li>Nghiệm thu ảnh chụp Trước & Sau khi sửa</li>
            <li>Ghi nhật ký vận hành máy móc tòa nhà</li>
          </ul>
        </div>

        <!-- Role 4: Kế toán -->
        <div class="role-card">
          <div class="role-icon">
            <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/>
            </svg>
          </div>
          <h3>Kế Toán</h3>
          <p>Số hóa toàn bộ quy trình thu phí, nhập chỉ số tiêu thụ và kiểm soát dòng tiền.</p>
          <ul class="role-features">
            <li>Nhập chỉ số điện, nước định kỳ hàng tháng</li>
            <li>Tự động xuất hóa đơn hàng loạt</li>
            <li>Đối soát trạng thái tiền về thời gian thực</li>
          </ul>
        </div>

        <!-- Role 5: Bảo vệ -->
        <div class="role-card">
          <div class="role-icon">
            <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
            </svg>
          </div>
          <h3>Bảo Vệ</h3>
          <p>Đảm bảo an ninh 24/7, ứng dụng quét QR Code tại từng tầng trong ca tuần tra.</p>
          <ul class="role-features">
            <li>Tra cứu chủ xe nhanh qua biển số hầm gửi xe</li>
            <li>Quét QR Code xác nhận điểm tuần tra từng tầng</li>
            <li>Lập Lệnh cảnh báo vi phạm trực tiếp trên web</li>
            <li>Nhật ký bàn giao ca trực điện tử</li>
          </ul>
        </div>

        <!-- Role 6: Ban quản lý -->
        <div class="role-card">
          <div class="role-icon">
            <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M18 20V10M12 20V4M6 20v-6"/>
            </svg>
          </div>
          <h3>Ban Quản Lý</h3>
          <p>Bảng điều khiển Trung tâm (Dashboard) điều hành toàn diện hoạt động chung cư.</p>
          <ul class="role-features">
            <li>Biểu đồ thống kê dòng tiền & công nợ</li>
            <li>Giám sát hiệu suất xử lý sự cố của nhân viên</li>
            <li>Cấp / Khóa tài khoản cư dân và nhân viên</li>
            <li>Phát hành thông báo khẩn toàn tòa nhà</li>
          </ul>
        </div>
      </div>
    </div>
  </section>

  <!-- ===== BENTO GRID MOCKUP PREVIEW CỬA SỔ APPLE ===== -->
  <section class="preview-section" id="previewSection">
    <div class="container">
        
        <div class="section-header" style="text-align:center;margin-bottom:24px;">
            <div class="eyebrow" style="display:inline-block;padding:4px 14px;background:#eff6ff;color:#2563eb;border-radius:99px;font-size:0.75rem;font-weight:700;letter-spacing:0.04em;text-transform:uppercase;margin-bottom:10px;">
                TRẢI NGHIỆM HỆ THỐNG
            </div>
            <h2 style="font-size:2rem;font-weight:800;color:#0f172a;letter-spacing:-0.03em;margin-bottom:8px;">
                Thông Tin Nổi Bật Hệ Thống PolyBuilding
            </h2>
            <p style="color:#64748b;font-size:0.95rem;max-width:580px;margin:0 auto;">
                Khám phá các tính năng quản lý vận hành tòa nhà trực quan theo thời gian thực bên dưới.
            </p>
        </div>

        <!-- MOCKUP FRAME (APPLE BROWSER WINDOW) -->
        <div class="preview-shell">
            <div class="preview-topbar">
                <div class="topbar-dots">
                    <span class="dot dot-red"></span>
                    <span class="dot dot-yellow"></span>
                    <span class="dot dot-green"></span>
                </div>
                <div class="url-bar">
                    <i class="fa-solid fa-lock" style="font-size:0.7rem;color:#16a34a;"></i>
                    <span id="previewUrlText">polybuilding.local/overview</span>
                </div>
                <div style="width:52px;"></div>
            </div>

            <!-- PREVIEW BODY INSIDE MOCKUP -->
            <div class="preview-inner">
                <!-- SIDEBAR BÊN TRÁI MOCKUP -->
                <div class="psb">
                    <div class="psb-sect">THÔNG TIN NỔI BẬT</div>
                    <button type="button" onclick="switchPreviewTab('tongquan', 'polybuilding.local/overview', this)" class="psb-item act">
                        <i class="fa-solid fa-building"></i> Tổng quan Chung cư
                    </button>
                    <button type="button" onclick="switchPreviewTab('thongbao', 'polybuilding.local/announcements', this)" class="psb-item">
                        <i class="fa-solid fa-bullhorn"></i> Thông báo Vận hành
                    </button>
                    <button type="button" onclick="switchPreviewTab('tienich', 'polybuilding.local/amenities', this)" class="psb-item">
                        <i class="fa-solid fa-water"></i> Tiện ích Nội khu
                    </button>
                    <button type="button" onclick="switchPreviewTab('quytrinh', 'polybuilding.local/workflow', this)" class="psb-item">
                        <i class="fa-solid fa-route"></i> Quy trình Hỗ trợ Cư dân
                    </button>
                    <button type="button" onclick="switchPreviewTab('hotline', 'polybuilding.local/contact', this)" class="psb-item">
                        <i class="fa-solid fa-headset"></i> Hotline &amp; Ban Quản Lý
                    </button>
                </div>

                <!-- MAIN DISPLAY AREA BÊN PHẢI MOCKUP -->
                <div style="position:relative;min-height:360px;">
                    <!-- TAB 1: TỔNG QUAN -->
                    <div id="tab-tongquan" class="tab-panel active">
                        <div style="display:inline-block;font-size:0.7rem;font-weight:800;color:#2563eb;letter-spacing:0.06em;text-transform:uppercase;margin-bottom:6px;">KHÔNG GIAN SỐNG HÀNG ĐẦU</div>
                        <h3 style="font-size:1.35rem;font-weight:800;color:#0f172a;margin-bottom:8px;">Tổ Hợp Chung Cư Cao Cấp PolyBuilding</h3>
                        <p style="font-size:0.83rem;color:#475569;line-height:1.6;margin-bottom:20px;">
                            PolyBuilding là dự án chung cư cao cấp 25 tầng ven sông với 200 căn hộ kết nối đồng bộ cùng hệ thống ban quản lý vận hành số chuẩn 5 sao.
                        </p>
                        <div class="pstats">
                            <div class="pstat">
                                <div class="pstat-val">200</div>
                                <div class="pstat-lbl">Căn hộ cao cấp</div>
                            </div>
                            <div class="pstat">
                                <div class="pstat-val">25 Tầng</div>
                                <div class="pstat-lbl">Tháp ven sông</div>
                            </div>
                            <div class="pstat">
                                <div class="pstat-val">24/7</div>
                                <div class="pstat-lbl">An ninh &amp; Trực ban</div>
                            </div>
                            <div class="pstat">
                                <div class="pstat-val">100%</div>
                                <div class="pstat-lbl">Số hóa vận hành</div>
                            </div>
                        </div>
                        <div class="ptable" style="margin-top:16px;">
                            <div class="ptable-title"><i class="fa-solid fa-shield-halved" style="color:#2563eb;"></i> Điểm Nổi Bật Tòa Nhà</div>
                            <div class="prow"><span>• Hệ thống thẻ từ, xe từ thông minh nhận diện nhanh dưới 0.5s</span> <span class="badge-demo green">Tự động</span></div>
                            <div class="prow"><span>• Bể bơi vô cực, phòng Gym, khu nướng BBQ ngoài trời free</span> <span class="badge-demo violet">Tiện ích 5★</span></div>
                            <div class="prow"><span>• Tổng đài tiếp nhận phản ánh sự cố &amp; cử kỹ thuật xử lý tức thì</span> <span class="badge-demo cyan">Hỗ trợ 24/7</span></div>
                        </div>
                    </div>

                    <!-- TAB 2: THÔNG BÁO -->
                    <div id="tab-thongbao" class="tab-panel">
                        <div style="display:inline-block;font-size:0.7rem;font-weight:800;color:#7c3aed;letter-spacing:0.06em;text-transform:uppercase;margin-bottom:6px;">THÔNG TIN BẢO TRÌ &amp; VẬN HÀNH</div>
                        <h3 style="font-size:1.35rem;font-weight:800;color:#0f172a;margin-bottom:8px;">Bảng Thông Báo Ban Quản Lý Tòa Nhà</h3>
                        <p style="font-size:0.83rem;color:#475569;line-height:1.6;margin-bottom:20px;">
                            Mọi thông tin lịch bảo dưỡng thang máy, lịch phun khử khuẩn hay các quy định cư dân mới đều được cập nhật minh bạch.
                        </p>
                        <div class="ptable">
                            <div class="ptable-title"><i class="fa-solid fa-bullhorn" style="color:#7c3aed;"></i> Thông Báo Mới Nhất</div>
                            <div class="prow"><span>• Thông báo lịch kiểm tra &amp; bảo dưỡng thang máy Tháp A</span> <span class="badge-demo green">Hôm nay</span></div>
                            <div class="prow"><span>• Đăng ký thẻ từ ra vào &amp; biển số xe mới tại quầy Lễ Tân</span> <span class="badge-demo cyan">Hướng dẫn</span></div>
                            <div class="prow"><span>• Phun thuốc khử khuẩn định kỳ khu vực hầm xe &amp; sảnh chung</span> <span class="badge-demo violet">Định kỳ</span></div>
                        </div>
                    </div>

                    <!-- TAB 3: TIỆN ÍCH -->
                    <div id="tab-tienich" class="tab-panel">
                        <div style="display:inline-block;font-size:0.7rem;font-weight:800;color:#16a34a;letter-spacing:0.06em;text-transform:uppercase;margin-bottom:6px;">ĐẮNG CẤP SỐNG XANH &amp; TIỆN NGHI</div>
                        <h3 style="font-size:1.35rem;font-weight:800;color:#0f172a;margin-bottom:8px;">Hệ Thống Tiện Ích Nội Khu 5 Sao</h3>
                        <p style="font-size:0.83rem;color:#475569;line-height:1.6;margin-bottom:20px;">
                            Cư dân PolyBuilding được tận hưởng trọn vẹn các dịch vụ thể thao, thư giãn và giải trí ngay trong khuôn viên chung cư.
                        </p>
                        <div class="ptable">
                            <div class="ptable-title"><i class="fa-solid fa-water" style="color:#16a34a;"></i> Danh Mục Tiện Ích Đặt Trước</div>
                            <div class="prow"><span>• Bể Bơi Vô Cực Rooftop (Mở cửa 06:00 - 21:00)</span> <span class="badge-demo green">Miễn phí</span></div>
                            <div class="prow"><span>• Sân Thể Thao Pickleball &amp; Tennis ngoài trời</span> <span class="badge-demo violet">Đặt trước</span></div>
                            <div class="prow"><span>• Vườn BBQ nướng ngoài trời cho tiệc gia đình cuối tuần</span> <span class="badge-demo cyan">Đặt trước</span></div>
                        </div>
                    </div>

                    <!-- TAB 4: QUY TRÌNH -->
                    <div id="tab-quytrinh" class="tab-panel">
                        <div style="display:inline-block;font-size:0.7rem;font-weight:800;color:#0891b2;letter-spacing:0.06em;text-transform:uppercase;margin-bottom:6px;">QUY TRÌNH HỖ TRỢ NHANH CHÓNG</div>
                        <h3 style="font-size:1.35rem;font-weight:800;color:#0f172a;margin-bottom:8px;">3 Bước Xử Lý Sự Cố Cư Dân</h3>
                        <p style="font-size:0.83rem;color:#475569;line-height:1.6;margin-bottom:20px;">
                            Quy trình phản ánh và khắc phục sự cố kỹ thuật được tự động hóa từ khâu tiếp nhận đến khi hoàn tất nghiệm thu.
                        </p>
                        <div class="ptable">
                            <div class="ptable-title"><i class="fa-solid fa-route" style="color:#0891b2;"></i> Tiến Trình Xử Lý Sự Cố</div>
                            <div class="prow"><span>Bước 1: Cư dân hoặc Lễ tân gửi phản ánh sự cố lên hệ thống</span> <span class="badge-demo cyan">Ghi nhận</span></div>
                            <div class="prow"><span>Bước 2: Hệ thống tự động phân công Kỹ thuật ca trực kiểm tra</span> <span class="badge-demo violet">Phân công</span></div>
                            <div class="prow"><span>Bước 3: Kỹ thuật hoàn tất sửa chữa, đăng tải ảnh nghiệm thu</span> <span class="badge-demo green">Hoàn tất</span></div>
                        </div>
                    </div>

                    <!-- TAB 5: HOTLINE -->
                    <div id="tab-hotline" class="tab-panel">
                        <div style="display:inline-block;font-size:0.7rem;font-weight:800;color:#dc2626;letter-spacing:0.06em;text-transform:uppercase;margin-bottom:6px;">KÊNH TRỰC BAN KHẨN CẤP</div>
                        <h3 style="font-size:1.35rem;font-weight:800;color:#0f172a;margin-bottom:8px;">Liên Hệ Ban Quản Lý &amp; Trực Ban</h3>
                        <p style="font-size:0.83rem;color:#475569;line-height:1.6;margin-bottom:20px;">
                            Chúng tôi luôn túc trực 24/7 tại văn phòng Ban quản lý tầng trệt để hỗ trợ cư dân mọi lúc mọi nơi.
                        </p>
                        <div class="ptable">
                            <div class="ptable-title"><i class="fa-solid fa-headset" style="color:#dc2626;"></i> Hotline Trực Ban 24/7</div>
                            <div class="prow"><span>• Hotline An ninh &amp; Bảo vệ khẩn cấp: <strong>1900 1234 (Phím 1)</strong></span> <span class="badge-demo green">24/7</span></div>
                            <div class="prow"><span>• Văn phòng Lễ tân tòa nhà: <strong>Sảnh chính Tháp A (07:30 - 21:00)</strong></span> <span class="badge-demo cyan">Trực tiếp</span></div>
                            <div class="prow"><span>• Hỗ trợ Kỹ thuật &amp; Điện nước: <strong>1900 1234 (Phím 2)</strong></span> <span class="badge-demo violet">24/7</span></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
  </section>

  <!-- ===== AMENITIES SECTION ===== -->
  <section class="amenities-section" id="amenities">
    <div class="container">
      <div class="section-header">
        <div class="eyebrow">Không gian sống đẳng cấp</div>
        <h2>Tiện Ích Nội Khu Đặt Lịch Trực Tuyến</h2>
        <p>Cư dân đăng nhập để giữ chỗ sử dụng các tiện ích độc quyền tại Polybuilding.</p>
      </div>

      <div class="amenities-grid">
        <div class="amenity-card">
          <div class="amenity-img">
            <img src="${pageContext.request.contextPath}/assets/pool.jpg" alt="Bể bơi vô cực Polybuilding">
          </div>
          <div class="amenity-body">
            <h3>Bể Bơi Vô Cực Rooftop</h3>
            <p>Hồ bơi nước mặn tầm nhìn 360 độ ngắm trọn toàn cảnh thành phố và dòng sông.</p>
          </div>
        </div>

        <div class="amenity-card">
          <div class="amenity-img">
            <img src="${pageContext.request.contextPath}/assets/sports.jpg" alt="Sân Pickleball & Tennis Polybuilding">
          </div>
          <div class="amenity-body">
            <h3>Sân Pickleball & Tennis</h3>
            <p>Sân thể thao đạt chuẩn quốc tế trang bị hệ thống chiếu sáng ban đêm hiện đại.</p>
          </div>
        </div>

        <div class="amenity-card">
          <div class="amenity-img">
            <img src="${pageContext.request.contextPath}/assets/lobby.jpg" alt="Sảnh đón 5 sao Polybuilding">
          </div>
          <div class="amenity-body">
            <h3>Sảnh Lễ Tân 5 Sao</h3>
            <p>Sảnh đón sang trọng với lễ tân túc trực 24/7, khu vực tiếp khách và trà chiều.</p>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- ===== CTA SECTION ===== -->
  <section>
    <div class="container">
      <div class="cta-banner">
        <h2>Trải nghiệm ngay Cổng thông tin Polybuilding</h2>
        <p>Vui lòng đăng nhập với tài khoản được cấp để truy cập đúng tính năng tương ứng với vai trò của bạn.</p>
        <a href="${pageContext.request.contextPath}/dang-nhap" class="btn btn-forest" id="ctaBannerBtn">Đăng nhập vào hệ thống ngay</a>
      </div>
    </div>
  </section>

  <!-- ===== FOOTER ===== -->
  <footer>
    <div class="container">
      <div class="footer-grid">
        <div class="footer-brand">
          <a href="${pageContext.request.contextPath}/" class="logo">
            <span class="mark"></span>
            POLYBUILDING
          </a>
          <p>Chung cư 25 tầng ven sông với 200 căn hộ cao cấp. Hệ thống quản lý vận hành số chuẩn mực và hiện đại nhất 2026.</p>
        </div>
        <div class="footer-col">
          <h4>Vận Hành</h4>
          <ul>
            <li><a href="#overview">Tổng quan tòa nhà</a></li>
            <li><a href="#floorplan">Sơ đồ 25 tầng</a></li>
            <li><a href="#roles">6 Phân quyền</a></li>
          </ul>
        </div>
        <div class="footer-col">
          <h4>Tiện Ích</h4>
          <ul>
            <li><a href="#amenities">Bể bơi vô cực</a></li>
            <li><a href="#amenities">Sân Pickleball</a></li>
            <li><a href="#amenities">Sảnh 5 sao</a></li>
          </ul>
        </div>
        <div class="footer-col">
          <h4>Hệ Thống</h4>
          <ul>
            <li><a href="${pageContext.request.contextPath}/dang-nhap">Cổng Đăng Nhập</a></li>
            <li><a href="${pageContext.request.contextPath}/dang-nhap">Quét mã thẻ NFC</a></li>
            <li><a href="${pageContext.request.contextPath}/dang-nhap">Hỗ trợ kỹ thuật</a></li>
          </ul>
        </div>
      </div>
      <div class="footer-bottom">
        © 2026 Polybuilding — Đồ án Quản Lý Chung Cư
      </div>
    </div>
  </footer>

  <script>
    window.APP_CONTEXT_PATH = "${pageContext.request.contextPath}";
    window.BUILDING_STATS = {
      tongCan: ${not empty tongCan ? tongCan : 200},
      dangO: ${not empty dangO ? dangO : 150},
      trong: ${not empty trong ? trong : 40},
      baoTri: ${not empty baoTri ? baoTri : 10}
    };
  </script>
  <script src="${pageContext.request.contextPath}/js/intro.js"></script>
  <script>
    function switchPreviewTab(tabId, urlText, btnElement) {
        document.querySelectorAll('.psb-item').forEach(item => item.classList.remove('act'));
        if (btnElement) {
            btnElement.classList.add('act');
        }
        
        const urlEl = document.getElementById('previewUrlText');
        if (urlEl) urlEl.textContent = urlText;

        const currentActive = document.querySelector('.tab-panel.active');
        const targetPanel = document.getElementById('tab-' + tabId);

        if (targetPanel && targetPanel !== currentActive) {
            if (currentActive) {
                currentActive.classList.remove('active');
            }
            targetPanel.classList.add('active');
        }
    }
  </script>
</body>
</html>
