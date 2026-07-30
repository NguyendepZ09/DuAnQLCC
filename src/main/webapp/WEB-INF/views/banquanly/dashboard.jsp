<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="util.DisplayUtil" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <title>Bảng Thống Kê & Hiệu Suất — Ban Quản Lý</title>

    <style>
body { background-color: #F4EFE4; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .stat-card { background: #FFF; border-radius: 12px; padding: 24px; border: 1px solid #EAE3D2; box-shadow: 0 4px 12px rgba(0,0,0,0.03); height: 100%; }
        .stat-card .title { font-size: 0.85rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; color: #6C757D; margin-bottom: 12px; }
        .stat-card .value { font-size: 1.6rem; color: #1E3B34; font-weight: 700; margin-bottom: 8px; }
        .chart-container { position: relative; height: 260px; width: 100%; }
    </style>
</head>
<body>

<div class="app-layout">
    <jsp:include page="/WEB-INF/views/banquanly/common/sidebar.jsp" />

    <div class="main-wrapper">
        <jsp:include page="/WEB-INF/views/banquanly/common/header.jsp" />

        <div class="content-body">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="text-dark fw-bold m-0">📊 Báo Cáo Thống Kê & Doanh Thu Tòa Nhà</h4>

                <!-- Filter Form by Month/Year -->
                <form action="${pageContext.request.contextPath}/banquanly/dashboard" method="get" class="d-flex align-items-center gap-2 m-0">
                    <label class="fw-bold text-dark small me-1">📅 Kỳ thu phí:</label>
                    <select name="thang" class="form-select form-select-sm" style="width: 110px;">
                        <c:forEach var="m" begin="1" end="12">
                            <option value="${m}" ${m == thangChon ? 'selected' : ''}>Tháng ${m}</option>
                        </c:forEach>
                    </select>
                    <select name="nam" class="form-select form-select-sm" style="width: 110px;">
                        <c:forEach var="y" begin="2024" end="2028">
                            <option value="${y}" ${y == namChon ? 'selected' : ''}>Năm ${y}</option>
                        </c:forEach>
                    </select>
                    <button type="submit" class="btn btn-sm btn-primary">🔍 Lọc</button>
                </form>
            </div>

            <!-- Top Summary Cards -->
            <div class="row g-4 mb-4">
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="title">Phải Thu (Kỳ T${thangChon}/${namChon})</div>
                        <div class="value text-dark">${DisplayUtil.formatTienDouble(thongKeKy.tongPhaiThu)}</div>
                        <span class="badge bg-secondary">Tổng hóa đơn</span>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="title">Đã Thu Thực Tế (Giao Dịch)</div>
                        <div class="value text-success">${DisplayUtil.formatTienDouble(thongKeKy.tongDaThu)}</div>
                        <span class="badge bg-success">Đạt ${thongKeKy.tyLeDaThuFormatted}%</span>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="title">Còn Nợ</div>
                        <div class="value text-danger">${DisplayUtil.formatTienDouble(thongKeKy.tongConNo)}</div>
                        <span class="badge bg-danger">Chưa thu hết</span>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="title">Top Nhân Viên Xuất Sắc</div>
                        <div class="value fs-6 text-warning font-monospace fw-bold">${topNhanVien}</div>
                        <span class="badge bg-warning text-dark">⭐ Xử lý sự cố</span>
                    </div>
                </div>
            </div>

            <!-- 3 CHARTS ROW -->
            <div class="row g-4 mb-4">
                <!-- CHART 1A: Doughnut Thu Phi Theo Ky -->
                <div class="col-md-4">
                    <div class="stat-card">
                        <h6 class="fw-bold text-dark mb-3">🍩 Tình Hình Thu Phí (Kỳ T${thangChon}/${namChon})</h6>
                        <c:choose>
                            <c:when test="${thongKeKy.hasData == true}">
                                <div class="chart-container">
                                    <canvas id="chartThuPhi"></canvas>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="p-5 text-center text-muted border rounded bg-light my-3">
                                    ⚠️ Chưa có dữ liệu cho kỳ này
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- CHART 1B: Doanh Thu 6 Thang Gan Nhat -->
                <div class="col-md-8">
                    <div class="stat-card">
                        <h6 class="fw-bold text-dark mb-3">📈 Doanh Thu 6 Tháng Gần Nhất (Phải Thu vs Đã Thu)</h6>
                        <div class="chart-container">
                            <canvas id="chartDoanhThu6Thang"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row g-4">
                <!-- CHART 1C: Hieu Suat Xu Ly Su Co (Horizontal Bar) -->
                <div class="col-md-6">
                    <div class="stat-card">
                        <h6 class="fw-bold text-dark mb-3">🛠️ Hiệu Suất Xử Lý Sự Cố Theo Trạng Thái</h6>
                        <div class="chart-container">
                            <canvas id="chartSuCo"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Incident Summary Table -->
                <div class="col-md-6">
                    <div class="stat-card">
                        <h6 class="fw-bold text-dark mb-3">📋 Tổng Kết Trạng Thái Phản Ánh Sự Cố</h6>
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Trạng Thái</th>
                                    <th>Số Lượng Phản Ánh</th>
                                    <th>Mô Tả Xử Lý</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><span class="badge bg-warning text-dark">Chờ tiếp nhận</span></td>
                                    <td><strong>${suCoDetailed.MoiTiepNhan}</strong> ca</td>
                                    <td><span class="text-muted small">Đang chờ Lễ tân tiếp nhận</span></td>
                                </tr>
                                <tr>
                                    <td><span class="badge bg-info text-dark">Đang xử lý</span></td>
                                    <td><strong>${suCoDetailed.DangXuLy}</strong> ca</td>
                                    <td><span class="text-muted small">Kỹ thuật viên đang khắc phục</span></td>
                                </tr>
                                <tr>
                                    <td><span class="badge bg-success">Đã hoàn thành</span></td>
                                    <td><strong>${suCoDetailed.HoanThanh}</strong> ca</td>
                                    <td><span class="text-muted small">Đã nghiệm thu xong</span></td>
                                </tr>
                                <tr>
                                    <td><span class="badge bg-secondary">Đã hủy</span></td>
                                    <td><strong>${suCoDetailed.DaHuy}</strong> ca</td>
                                    <td><span class="text-muted small">Phản ánh bị hủy / trùng</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<!-- Render JSON data via data-attributes to prevent JS injection -->
<div id="chartDataContainer"
     data-dathuthang="${thongKeKy.tongDaThu}"
     data-connothang="${thongKeKy.tongConNo}"
     data-dathuthangfmt="${DisplayUtil.formatTienDouble(thongKeKy.tongDaThu)}"
     data-connothangfmt="${DisplayUtil.formatTienDouble(thongKeKy.tongConNo)}"
     data-hasdatathang="${thongKeKy.hasData}">
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const container = document.getElementById('chartDataContainer');

        // --- 1A. DOUGHNUT CHART (Thu Phi Theo Ky) ---
        const elThuPhi = document.getElementById('chartThuPhi');
        if (elThuPhi && container.getAttribute('data-hasdatathang') === 'true') {
            const daThu = parseFloat(container.getAttribute('data-dathuthang')) || 0;
            const conNo = parseFloat(container.getAttribute('data-connothang')) || 0;
            const daThuFmt = container.getAttribute('data-dathuthangfmt');
            const conNoFmt = container.getAttribute('data-connothangfmt');

            new Chart(elThuPhi, {
                type: 'doughnut',
                data: {
                    labels: ['Đã thu (' + daThuFmt + ')', 'Còn nợ (' + conNoFmt + ')'],
                    datasets: [{
                        data: [daThu, conNo],
                        backgroundColor: ['#1E3B34', '#DC3545'],
                        borderWidth: 2
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { position: 'bottom' },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    const val = context.raw || 0;
                                    const total = daThu + conNo;
                                    const pct = total > 0 ? ((val / total) * 100).toFixed(1) : 0;
                                    return context.label.split(' (')[0] + ': ' + new Intl.NumberFormat('vi-VN').format(val) + 'đ (' + pct + '%)';
                                }
                            }
                        }
                    }
                }
            });
        }

        // --- 1B. BAR CHART (Doanh Thu 6 Thang Gan Nhat) ---
        const el6Thang = document.getElementById('chartDoanhThu6Thang');
        if (el6Thang) {
            const labels6M = [
                <c:forEach var="item" items="${doanhThu6Thang}" varStatus="st">
                    '${item.label}'${!st.last ? ',' : ''}
                </c:forEach>
            ];
            const phaiThu6M = [
                <c:forEach var="item" items="${doanhThu6Thang}" varStatus="st">
                    ${item.tongPhaiThu}${!st.last ? ',' : ''}
                </c:forEach>
            ];
            const daThu6M = [
                <c:forEach var="item" items="${doanhThu6Thang}" varStatus="st">
                    ${item.tongDaThu}${!st.last ? ',' : ''}
                </c:forEach>
            ];

            new Chart(el6Thang, {
                type: 'bar',
                data: {
                    labels: labels6M,
                    datasets: [
                        {
                            label: 'Phải thu (VNĐ)',
                            data: phaiThu6M,
                            backgroundColor: '#B98A46'
                        },
                        {
                            label: 'Đã thu thực tế (VNĐ)',
                            data: daThu6M,
                            backgroundColor: '#1E3B34'
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            ticks: {
                                callback: function(val) {
                                    return (val / 1000000).toFixed(0) + ' Trđ';
                                }
                            }
                        }
                    }
                }
            });
        }

        // --- 1C. HORIZONTAL BAR CHART (Hieu Suat Xu Ly Su Co) ---
        const elSuCo = document.getElementById('chartSuCo');
        if (elSuCo) {
            new Chart(elSuCo, {
                type: 'bar',
                data: {
                    labels: ['Chờ tiếp nhận', 'Đang xử lý', 'Đã hoàn thành', 'Đã hủy'],
                    datasets: [{
                        label: 'Số lượng ca',
                        data: [
                            ${suCoDetailed.MoiTiepNhan},
                            ${suCoDetailed.DangXuLy},
                            ${suCoDetailed.HoanThanh},
                            ${suCoDetailed.DaHuy}
                        ],
                        backgroundColor: ['#FFC107', '#0D6EFD', '#198754', '#6C757D']
                    }]
                },
                options: {
                    indexAxis: 'y',
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false }
                    }
                }
            });
        }
    });
</script>
</body>
</html>
