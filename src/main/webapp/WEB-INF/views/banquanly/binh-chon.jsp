<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tạo Bình Chọn / Khảo Sát — Ban Quản Lý</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background-color: #F4EFE4; font-family: 'Be Vietnam Pro', sans-serif; }
        .app-layout { display: flex; min-height: 100vh; }
        .sidebar { width: 260px; background: #1E3B34; color: #FFF; padding: 24px; flex-shrink: 0; }
        .sidebar-brand { font-family: 'Fraunces', serif; font-size: 1.15rem; font-weight: 700; color: #D9AE72; margin-bottom: 30px; display: flex; align-items: center; gap: 8px; }
        .sidebar-brand .mark { width: 10px; height: 10px; background: #D9AE72; transform: rotate(45deg); display: inline-block; }
        .sidebar-user { display: flex; align-items: center; gap: 12px; padding: 12px; background: rgba(255,255,255,0.08); border-radius: 8px; margin-bottom: 24px; }
        .sidebar-user .avatar { width: 38px; height: 38px; background: #B98A46; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.8rem; }
        .sidebar-user .name { font-size: 0.9rem; font-weight: 600; display: block; }
        .sidebar-user .role { font-size: 0.75rem; color: rgba(255,255,255,0.6); }
        .sidebar-nav { display: flex; flex-direction: column; gap: 6px; }
        .nav-item { display: flex; align-items: center; gap: 12px; padding: 12px 16px; color: rgba(255,255,255,0.75); text-decoration: none; border-radius: 6px; font-size: 0.9rem; font-weight: 500; transition: all 0.2s; }
        .nav-item:hover, .nav-item.active { background: #B98A46; color: #FFF; }
        .nav-divider { height: 1px; background: rgba(255,255,255,0.1); margin: 12px 0; }
        .main-wrapper { flex-grow: 1; display: flex; flex-direction: column; overflow-x: hidden; }
        .top-header { background: #FFF; padding: 18px 32px; border-bottom: 1px solid #DCE6E0; display: flex; justify-content: space-between; align-items: center; }
        .top-header h2 { font-family: 'Fraunces', serif; font-size: 1.4rem; color: #1E3B34; margin: 0; }
        .top-header .sub { font-size: 0.82rem; color: #6C757D; }
        .content-body { padding: 32px; }
        .card-custom { background: #FFF; border-radius: 12px; padding: 24px; border: 1px solid #DCE6E0; box-shadow: 0 4px 12px rgba(0,0,0,0.03); }
    </style>
</head>
<body>

<div class="app-layout">
    <%@ include file="/WEB-INF/views/banquanly/common/sidebar.jsp" %>

    <div class="main-wrapper">
        <%@ include file="/WEB-INF/views/banquanly/common/header.jsp" %>

        <div class="content-body">
            <h4 class="text-dark fw-bold mb-4">🗳️ Quản Lý Bình Chọn & Khảo Sát Ý Kiến Cư Dân</h4>

            <div class="row g-4">
                <!-- Create Poll Form -->
                <div class="col-md-5">
                    <div class="card-custom">
                        <h5 class="fw-bold mb-3 text-dark">✍️ Tạo Cuộc Bình Chọn Mới</h5>
                        <form action="${pageContext.request.contextPath}/banquanly/binh-chon" method="post">
                            <div class="mb-3">
                                <label class="form-label font-semibold">Câu Hỏi Bình Chọn / Khảo Sát</label>
                                <input type="text" name="cauHoi" class="form-control" placeholder="vd: Bạn đồng ý mở rộng sân Pickleball không?" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label font-semibold">Mã Thông Báo Liên Quan</label>
                                <input type="number" name="maThongBao" class="form-control" placeholder="vd: 1" value="1">
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label font-semibold d-flex justify-content-between">
                                    <span>Danh Sách Phương Án Lựa Chọn</span>
                                    <button type="button" class="btn btn-sm btn-outline-success py-0" onclick="addOption()">+ Thêm phương án</button>
                                </label>
                                <div id="optionsContainer">
                                    <input type="text" name="phuongAn" class="form-control mb-2" placeholder="Phương án 1 (vd: Đồng ý)" required>
                                    <input type="text" name="phuongAn" class="form-control mb-2" placeholder="Phương án 2 (vd: Không đồng ý)" required>
                                </div>
                            </div>
                            
                            <button type="submit" class="btn btn-warning w-100 fw-bold py-2 text-dark">🚀 Mở Bình Chọn Trực Tuyến</button>
                        </form>
                    </div>
                </div>

                <!-- Existing Polls List -->
                <div class="col-md-7">
                    <div class="card-custom">
                        <h5 class="fw-bold mb-3 text-dark">📊 Danh Sách Các Cuộc Bình Chọn</h5>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th>ID</th>
                                        <th>Câu Hỏi Khảo Sát</th>
                                        <th>Tỷ Lệ Túc Số</th>
                                        <th>Trạng Thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="bc" items="${danhSachBinhChon}">
                                        <tr>
                                            <td>${bc.id}</td>
                                            <td><strong>${bc.cauHoi}</strong></td>
                                            <td><span class="badge bg-info text-dark">${bc.tyLeTucSo}% cư dân tham gia</span></td>
                                            <td>
                                                <span class="badge ${bc.trangThai == 'Mở' || bc.trangThai == 'DangMo' ? 'bg-success' : 'bg-secondary'}">
                                                    ${bc.trangThai}
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<script>
    function addOption() {
        const container = document.getElementById('optionsContainer');
        const count = container.children.length + 1;
        const input = document.createElement('input');
        input.type = 'text';
        input.name = 'phuongAn';
        input.className = 'form-control mb-2';
        input.placeholder = `Phương án ${count}`;
        container.appendChild(input);
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
