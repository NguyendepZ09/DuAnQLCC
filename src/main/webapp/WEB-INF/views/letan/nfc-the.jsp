<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <title>Ghi Thẻ NFC Đăng Nhập — Lễ Tân PolyBuilding</title>

    <style>
        body { background-color: #F4EFE4; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
    </style>
</head>
<body>

<div class="app-layout">
    <jsp:include page="/WEB-INF/views/letan/common/sidebar.jsp" />

    <div class="main-wrapper">
        <jsp:include page="/WEB-INF/views/letan/common/header.jsp" />

        <main class="content-body p-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h4 class="fw-bold mb-1" style="color: #1E3B34;">📱 Ghi Thẻ NFC Đăng Nhập Cho Cư Dân</h4>
                    <p class="text-muted small m-0">Copy URL định danh thẻ NFC để ghi vào chip bằng ứng dụng NFC Tools (Android / iOS)</p>
                </div>
            </div>

            <!-- Form cấu hình URL Base -->
            <div class="card shadow-sm border-0 mb-4 p-3" style="background: #FFFFFF; border-radius: 12px; border: 1px solid #EAE3D2;">
                <form method="GET" action="${pageContext.request.contextPath}/letan/nfc-the" class="row g-3 align-items-center">
                    <div class="col-md-8">
                        <label for="baseUrlInput" class="form-label fw-bold small text-dark mb-1">
                            Địa chỉ Base URL máy chủ (Nếu dùng điện thoại quét trong mạng Wi-Fi LAN, nhập IP ví dụ: <code>http://192.168.1.5:8080/chungcu</code>):
                        </label>
                        <input type="text" id="baseUrlInput" name="baseUrl" class="form-control" value="<c:out value="${baseUrl}" />" placeholder="http://192.168.1.X:8080/chungcu">
                    </div>
                    <div class="col-md-4 d-flex align-items-end">
                        <button type="submit" class="btn btn-outline-success w-100 fw-bold">
                            🔄 Cập Nhật Base URL
                        </button>
                    </div>
                </form>
            </div>

            <!-- Bảng danh sách thẻ NFC đang hoạt động -->
            <div class="card shadow-sm border-0" style="background: #FFFFFF; border-radius: 12px; border: 1px solid #EAE3D2;">
                <div class="card-header bg-white py-3 border-0">
                    <h5 class="fw-bold text-dark m-0">🪪 Danh Sách Thẻ Từ Đang Sử Dụng (<c:out value="${dsTheNFC.size()}" />)</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle m-0 table-custom">
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-3">Số Thẻ</th>
                                    <th>Căn Hộ</th>
                                    <th>Tên Cư Dân</th>
                                    <th>URL Đăng Nhập NFC</th>
                                    <th class="text-end pe-3">Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty dsTheNFC}">
                                        <c:forEach var="item" items="${dsTheNFC}">
                                            <tr>
                                                <td class="ps-3 fw-bold text-dark font-monospace"><c:out value="${item[0]}" /></td>
                                                <td><span class="badge bg-success bg-opacity-10 text-success fw-bold">Căn <c:out value="${item[1]}" /></span></td>
                                                <td class="fw-bold text-dark"><c:out value="${item[2]}" /></td>
                                                <td>
                                                    <input type="text" class="form-control form-control-sm font-monospace text-muted" value="<c:out value="${item[3]}" />" readonly style="max-width: 480px; background: #F8F9FA;">
                                                </td>
                                                <td class="text-end pe-3">
                                                    <button type="button" class="btn btn-sm btn-outline-primary btn-copy-url" data-url="<c:out value="${item[3]}" />">
                                                        📋 Copy Link
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="5" class="text-center py-4 text-muted">Không có thẻ từ nào đang hoạt động.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('.btn-copy-url').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var url = this.dataset.url;
            if (url) {
                navigator.clipboard.writeText(url).then(function() {
                    btn.classList.remove('btn-outline-primary');
                    btn.classList.add('btn-success');
                    btn.textContent = '✓ Đã Copy';
                    setTimeout(function() {
                        btn.classList.remove('btn-success');
                        btn.classList.add('btn-outline-primary');
                        btn.textContent = '📋 Copy Link';
                    }, 1800);
                });
            }
        });
    });
});
</script>
</body>
</html>
