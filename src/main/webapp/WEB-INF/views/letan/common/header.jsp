<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<div class="top-header">
    <div>
        <h2>Quản Lý Nghiệp Vụ Lễ Tân</h2>
        <span class="sub">Hệ thống tiếp nhận phản ánh, giao việc & dịch vụ cư dân</span>
    </div>
    <div class="d-flex align-items-center gap-3">
        <span class="badge bg-light text-dark border py-2 px-3">
            📅 <span id="currentClock"></span>
        </span>
    </div>
</div>

<script>
    function updateClock() {
        const now = new Date();
        const str = now.toLocaleDateString('vi-VN') + ' ' + now.toLocaleTimeString('vi-VN', {hour: '2-digit', minute:'2-digit', second:'2-digit'});
        const el = document.getElementById('currentClock');
        if (el) el.innerText = str;
    }
    setInterval(updateClock, 1000);
    updateClock();
</script>
