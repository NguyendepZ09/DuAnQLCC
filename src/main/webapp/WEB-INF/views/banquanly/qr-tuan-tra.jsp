<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <title>Mã QR Tuần Tra 25 Tầng — Ban Quản Lý</title>

    <style>
        body { background-color: #F4EFE4; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        
        .qr-card-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 20px;
        }

        .qr-card {
            background: #FFFFFF;
            border: 1px solid #EAE3D2;
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 4px 12px rgba(0,0,0,0.03);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .qr-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.08);
        }

        .qr-card img {
            width: 180px;
            height: 180px;
            object-fit: contain;
            border: 1px solid #EAE3D2;
            border-radius: 8px;
            padding: 6px;
            background: #FFFFFF;
        }

        .qr-card .floor-title {
            font-size: 1.3rem;
            font-weight: 800;
            color: #1E3B34;
            margin-top: 12px;
            margin-bottom: 4px;
        }

        .qr-card .sub-text {
            font-size: 0.78rem;
            color: #6C757D;
        }

        @media print {
            .sidebar, .top-header, .no-print {
                display: none !important;
            }
            .app-layout, .main-wrapper, .content-body {
                padding: 0 !important;
                margin: 0 !important;
                background: #FFFFFF !important;
            }
            body {
                background: #FFFFFF !important;
            }
            .qr-card-grid {
                grid-template-columns: repeat(3, 1fr) !important;
                gap: 15px !important;
            }
            .qr-card {
                border: 1px solid #CCCCCC !important;
                box-shadow: none !important;
                break-inside: avoid;
            }
        }
    </style>
</head>
<body>

<div class="app-layout">
    <jsp:include page="/WEB-INF/views/banquanly/common/sidebar.jsp" />

    <div class="main-wrapper">
        <jsp:include page="/WEB-INF/views/banquanly/common/header.jsp" />

        <main class="content-body p-4">
            <div class="d-flex justify-content-between align-items-center mb-4 no-print">
                <div>
                    <h4 class="fw-bold mb-1" style="color: #1E3B34;">📱 Danh Sách Mã QR Tuần Tra 25 Tầng</h4>
                    <p class="text-muted small m-0">In và dán mã QR tại từng tầng để Bảo vệ quét xác nhận khi tuần tra</p>
                </div>
                <div>
                    <button type="button" onclick="window.print()" class="btn btn-warning fw-bold px-3">
                        🖨️ In Mã QR Tuần Tra
                    </button>
                </div>
            </div>

            <!-- Form cấu hình URL mạng LAN / Domain -->
            <div class="card shadow-sm border-0 mb-4 p-3 no-print" style="background: #FFFFFF; border-radius: 12px; border: 1px solid #EAE3D2;">
                <form method="GET" action="${pageContext.request.contextPath}/banquanly/qr-tuan-tra" class="row g-3 align-items-center">
                    <div class="col-md-8">
                        <label for="baseUrlInput" class="form-label fw-bold small text-dark mb-1">
                            Địa chỉ Base URL (nếu dùng điện thoại quét qua Wi-Fi LAN, nhập IP máy chủ ví dụ: <code>http://192.168.1.5:8080/chungcu</code>):
                        </label>
                        <input type="text" id="baseUrlInput" name="baseUrl" class="form-control" value="<c:out value="${baseUrl}" />" placeholder="http://192.168.1.X:8080/chungcu">
                    </div>
                    <div class="col-md-4 d-flex align-items-end">
                        <button type="submit" class="btn btn-outline-success w-100 fw-bold">
                            🔄 Tạo Lại Mã QR
                        </button>
                    </div>
                </form>
            </div>

            <!-- Danh sách 25 Mã QR Tầng -->
            <div class="qr-card-grid">
                <c:forEach var="qr" items="${dsQR}">
                    <div class="qr-card">
                        <img src="<c:out value="${qr[1]}" />" alt="QR Tầng <c:out value="${qr[0]}" />">
                        <div class="floor-title">TẦNG <c:out value="${qr[0]}" /></div>
                        <div class="sub-text">Quét để ghi nhận tuần tra</div>
                    </div>
                </c:forEach>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
