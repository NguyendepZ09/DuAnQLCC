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
</head>
<body>

  <!-- ===== NAVBAR ===== -->
  <header>
    <div class="container">
      <nav>
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo" id="navLogo">
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
          <a href="${pageContext.request.contextPath}/dang-nhap.jsp" class="btn btn-outline" id="navLoginBtn">Đăng nhập ngay</a>
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
            <a href="${pageContext.request.contextPath}/dang-nhap.jsp" class="btn btn-primary" id="heroLoginCta">
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
        <a href="${pageContext.request.contextPath}/dang-nhap.jsp" class="btn btn-forest" id="ctaBannerBtn">Đăng nhập vào hệ thống ngay</a>
      </div>
    </div>
  </section>

  <!-- ===== FOOTER ===== -->
  <footer>
    <div class="container">
      <div class="footer-grid">
        <div class="footer-brand">
          <a href="${pageContext.request.contextPath}/index.jsp" class="logo">
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
            <li><a href="${pageContext.request.contextPath}/dang-nhap.jsp">Cổng Đăng Nhập</a></li>
            <li><a href="${pageContext.request.contextPath}/dang-nhap.jsp">Quét mã thẻ NFC</a></li>
            <li><a href="${pageContext.request.contextPath}/dang-nhap.jsp">Hỗ trợ kỹ thuật</a></li>
          </ul>
        </div>
      </div>
      <div class="footer-bottom">
        © 2026 Polybuilding — Đồ án Quản Lý Chung Cư
      </div>
    </div>
  </footer>

  <script src="${pageContext.request.contextPath}/js/intro.js"></script>
</body>
</html>
