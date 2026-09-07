<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Tạo hồ sơ Thực tập sinh — HR</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --sidebar-w: 250px;
            --sidebar-bg: #0c1f3f;
            --accent: #0ea5e9;
            --page-bg: #f0f6ff;
            --card-bg: #fff;
            --text-primary: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
        }
        body { font-family: 'Inter', sans-serif; background: var(--page-bg); display: flex; min-height: 100vh; }

        /* ── Sidebar ── */
        .sidebar {
            width: var(--sidebar-w); background: var(--sidebar-bg);
            display: flex; flex-direction: column; flex-shrink: 0;
            position: fixed; height: 100vh; overflow-y: auto; z-index: 100;
        }
        .sidebar-brand { padding: 28px 22px 20px; border-bottom: 1px solid rgba(255,255,255,.08); }
        .sidebar-brand .brand-icon {
            width: 40px; height: 40px; border-radius: 10px;
            background: linear-gradient(135deg, #0ea5e9, #38bdf8);
            display: flex; align-items: center; justify-content: center;
            font-size: 1.15rem; color: #fff; margin-bottom: 10px;
        }
        .sidebar-brand h1 { color: #fff; font-size: .95rem; font-weight: 700; line-height: 1.3; }
        .sidebar-section-label { padding: 18px 22px 6px; font-size: .67rem; font-weight: 700; text-transform: uppercase; letter-spacing: .8px; color: rgba(255,255,255,.3); }
        .sidebar-nav { list-style: none; padding: 0 12px; }
        .sidebar-nav li a {
            display: flex; align-items: center; gap: 10px;
            padding: 10px 12px; border-radius: 8px; margin-bottom: 2px;
            text-decoration: none; color: rgba(255,255,255,.65); font-size: .84rem; font-weight: 500;
            transition: background .15s, color .15s;
        }
        .sidebar-nav li a:hover { background: rgba(255,255,255,.07); color: #fff; }
        .sidebar-nav li a.active { background: rgba(14,165,233,.2); color: #fff; border-left: 3px solid var(--accent); }
        .sidebar-nav li a i { font-size: 1rem; width: 20px; }
        .sidebar-footer { margin-top: auto; padding: 16px 22px; border-top: 1px solid rgba(255,255,255,.08); }
        .sidebar-user { display: flex; align-items: center; gap: 10px; }
        .avatar { width: 34px; height: 34px; border-radius: 50%; background: linear-gradient(135deg, #0ea5e9, #38bdf8); display: flex; align-items: center; justify-content: center; font-size: .85rem; color: #fff; font-weight: 700; flex-shrink: 0; }
        .sidebar-user-info { flex: 1; min-width: 0; }
        .sidebar-user-name { color: #fff; font-size: .82rem; font-weight: 600; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .sidebar-user-role { color: rgba(255,255,255,.4); font-size: .7rem; }
        .logout-btn { color: rgba(255,255,255,.4); font-size: 1rem; text-decoration: none; transition: color .15s; }
        .logout-btn:hover { color: #f87171; }

        /* ── Main ── */
        .main { margin-left: var(--sidebar-w); flex: 1; display: flex; flex-direction: column; }
        .topbar {
            background: var(--card-bg); padding: 16px 32px;
            border-bottom: 1px solid var(--border);
            display: flex; align-items: center; gap: 14px;
            position: sticky; top: 0; z-index: 50;
            box-shadow: 0 1px 4px rgba(0,0,0,.06);
        }
        .topbar-back {
            display: flex; align-items: center; gap: 6px;
            padding: 7px 14px; border-radius: 8px; border: 1.5px solid var(--border);
            background: #fff; color: var(--text-muted); text-decoration: none;
            font-size: .82rem; font-weight: 600; transition: all .15s;
        }
        .topbar-back:hover { background: #f8fafc; border-color: var(--accent); color: var(--accent); }
        .page-title { font-size: 1.2rem; font-weight: 700; color: var(--text-primary); }
        .page-sub   { font-size: .8rem; color: var(--text-muted); margin-top: 1px; }
        .content { padding: 32px; flex: 1; display: flex; justify-content: center; }

        /* ── Form Card ── */
        .form-card {
            background: var(--card-bg); border-radius: 16px;
            border: 1px solid var(--border); padding: 36px 40px;
            width: 100%; max-width: 720px;
            box-shadow: 0 2px 16px rgba(0,0,0,.06);
        }
        .form-card-header { margin-bottom: 28px; }
        .form-card-title { font-size: 1.15rem; font-weight: 700; color: var(--text-primary); display: flex; align-items: center; gap: 10px; }
        .form-card-title .icon { width: 38px; height: 38px; border-radius: 10px; background: linear-gradient(135deg, #0ea5e9, #38bdf8); display: flex; align-items: center; justify-content: center; color: #fff; font-size: 1.05rem; }
        .form-card-sub { font-size: .83rem; color: var(--text-muted); margin-top: 4px; }

        .section-label {
            font-size: .71rem; font-weight: 700; text-transform: uppercase;
            letter-spacing: .5px; color: var(--accent);
            margin: 26px 0 14px; padding-bottom: 8px;
            border-bottom: 1.5px solid #e0f4fe;
            display: flex; align-items: center; gap: 7px;
        }
        .section-label:first-of-type { margin-top: 0; }

        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .form-grid .full { grid-column: 1/-1; }
        .form-group { display: flex; flex-direction: column; gap: 5px; }
        .form-label { font-size: .78rem; font-weight: 600; color: #374151; }
        .required { color: #ef4444; font-weight: 700; }
        .input-wrap { position: relative; }
        .input-icon { position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: #94a3b8; font-size: .95rem; pointer-events: none; }
        .form-input, .form-select {
            width: 100%; padding: 10px 12px 10px 36px;
            border: 1.5px solid var(--border); border-radius: 9px;
            font-family: 'Inter', sans-serif; font-size: .85rem; color: var(--text-primary);
            background: #fff; outline: none; transition: border-color .2s, box-shadow .2s;
        }
        .form-input:focus, .form-select:focus { border-color: var(--accent); box-shadow: 0 0 0 3px rgba(14,165,233,.12); }

        .alert-error {
            background: #fef2f2; border: 1px solid #fecaca; border-radius: 10px;
            padding: 12px 16px; display: flex; align-items: center; gap: 10px;
            color: #dc2626; font-size: .85rem; margin-bottom: 20px;
        }
        .form-actions {
            display: flex; align-items: center; justify-content: flex-end; gap: 12px;
            margin-top: 32px; padding-top: 20px; border-top: 1px solid var(--border);
        }
        .btn-cancel {
            padding: 10px 22px; border-radius: 9px; border: 1.5px solid var(--border);
            background: #fff; color: var(--text-muted); font-family: 'Inter', sans-serif;
            font-size: .85rem; font-weight: 600; cursor: pointer; text-decoration: none;
            display: flex; align-items: center; gap: 5px; transition: all .15s;
        }
        .btn-cancel:hover { background: #f8fafc; border-color: #cbd5e1; color: var(--text-primary); }
        .btn-save {
            padding: 10px 24px; border-radius: 9px; border: none;
            background: linear-gradient(135deg, #0ea5e9, #38bdf8);
            color: #fff; font-family: 'Inter', sans-serif;
            font-size: .85rem; font-weight: 600; cursor: pointer;
            display: flex; align-items: center; gap: 6px;
            box-shadow: 0 2px 10px rgba(14,165,233,.3); transition: opacity .15s, transform .15s;
        }
        .btn-save:hover { opacity: .9; transform: translateY(-1px); }
        .btn-save:active { transform: translateY(0); }

        .pw-toggle {
            position: absolute; right: 10px; top: 50%; transform: translateY(-50%);
            background: none; border: none; cursor: pointer; color: #94a3b8; font-size: .9rem; padding: 0;
        }

        @media (max-width: 650px) {
            .form-grid { grid-template-columns: 1fr; }
            .form-card { padding: 24px 20px; }
        }
    </style>
</head>
<body>

<%-- ── Sidebar ── --%>
<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-icon"><i class="bi bi-building"></i></div>
        <h1>Nhân sự (HR)</h1>
    </div>

    <div class="sidebar-section-label">Quản lý</div>
    <ul class="sidebar-nav">
        <li><a href="${pageContext.request.contextPath}/hr/dashboard"><i class="bi bi-grid"></i> Tổng quan</a></li>
        <li><a href="${pageContext.request.contextPath}/hr/mentors"><i class="bi bi-mortarboard"></i> Mentor</a></li>
        <li><a href="${pageContext.request.contextPath}/hr/applications"><i class="bi bi-clipboard-check"></i> Đơn xét tuyển</a></li>
        <li><a href="${pageContext.request.contextPath}/hr/contracts"><i class="bi bi-file-earmark-text"></i> Hợp đồng</a></li>
        <li><a href="${pageContext.request.contextPath}/hr/documents"><i class="bi bi-folder-check"></i> Duyệt tài liệu</a></li>
    </ul>

    <div class="sidebar-footer">
        <div class="sidebar-user">
            <div class="avatar">${fn:substring(sessionScope.currentUser.fullName, 0, 1)}</div>
            <div class="sidebar-user-info">
                <div class="sidebar-user-name">${sessionScope.currentUser.fullName}</div>
                <div class="sidebar-user-role">Nhân sự</div>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn" title="Đăng xuất"><i class="bi bi-box-arrow-right"></i></a>
        </div>
    </div>
</aside>

<%-- ── Main ── --%>
<div class="main">
    <div class="topbar">
        <a href="${pageContext.request.contextPath}/hr/dashboard" class="topbar-back">
            <i class="bi bi-arrow-left"></i> Quay lại Tổng quan
        </a>
        <div style="border-left:1px solid var(--border);height:24px"></div>
        <div>
            <div class="page-title">Thêm hồ sơ Thực tập sinh</div>
            <div class="page-sub">Tạo mới hồ sơ thực tập sinh vào hệ thống</div>
        </div>
    </div>

    <div class="content">
        <div class="form-card">
            <div class="form-card-header">
                <div class="form-card-title">
                    <div class="icon"><i class="bi bi-person-plus-fill"></i></div>
                    Tạo hồ sơ Thực tập sinh
                </div>
                <div class="form-card-sub">Tất cả các trường đánh dấu (*) là bắt buộc.</div>
            </div>

            <c:if test="${not empty error}">
                <div class="alert-error"><i class="bi bi-exclamation-circle-fill"></i> ${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/hr/interns/create" method="post" id="internForm">

                <%-- 1. Personal Information --%>
                <div class="section-label"><i class="bi bi-person-fill"></i> 1. Thông tin cá nhân</div>
                <div class="form-grid">
                    <div class="form-group full">
                        <label class="form-label">Họ và tên <span class="required">*</span></label>
                        <div class="input-wrap">
                            <i class="bi bi-person-fill input-icon"></i>
                            <input type="text" name="fullName" class="form-input" value="${intern.fullName}" required placeholder="VD: Nguyễn Văn A">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Email <span class="required">*</span></label>
                        <div class="input-wrap">
                            <i class="bi bi-envelope input-icon"></i>
                            <input type="email" name="email" class="form-input" value="${intern.email}" required placeholder="intern@example.com">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Số điện thoại <span class="required">*</span></label>
                        <div class="input-wrap">
                            <i class="bi bi-phone input-icon"></i>
                            <input type="tel" name="phone" class="form-input" value="${intern.phone}" required placeholder="0901234567">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Ngày sinh</label>
                        <div class="input-wrap">
                            <i class="bi bi-calendar3 input-icon"></i>
                            <input type="date" name="dateOfBirth" class="form-input" value="${intern.dateOfBirth}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Giới tính <span class="required">*</span></label>
                        <div class="input-wrap">
                            <i class="bi bi-gender-ambiguous input-icon"></i>
                            <select name="gender" class="form-select" required>
                                <option value="">-- Chọn --</option>
                                <option value="MALE"   ${intern.gender == 'MALE'   ? 'selected' : ''}>Nam</option>
                                <option value="FEMALE" ${intern.gender == 'FEMALE' ? 'selected' : ''}>Nữ</option>
                                <option value="OTHER"  ${intern.gender == 'OTHER'  ? 'selected' : ''}>Khác</option>
                            </select>
                        </div>
                    </div>
                </div>

                <%-- 2. Academic Details --%>
                <div class="section-label"><i class="bi bi-mortarboard"></i> 2. Thông tin học vấn</div>
                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label">Mã sinh viên</label>
                        <div class="input-wrap">
                            <i class="bi bi-card-text input-icon"></i>
                            <input type="text" name="studentCode" class="form-input" value="${intern.studentCode}" placeholder="VD: SV001">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Trạng thái</label>
                        <div class="input-wrap">
                            <i class="bi bi-flag input-icon"></i>
                            <select name="status" class="form-select">
                                <option value="PENDING"   ${intern.status == 'PENDING'   ? 'selected' : ''}>Chờ duyệt</option>
                                <option value="APPROVED"  ${intern.status == 'APPROVED'  ? 'selected' : ''}>Đã duyệt</option>
                                <option value="REJECTED"  ${intern.status == 'REJECTED'  ? 'selected' : ''}>Từ chối</option>
                                <option value="INTERNING" ${intern.status == 'INTERNING' ? 'selected' : ''}>Đang thực tập</option>
                                <option value="COMPLETED" ${intern.status == 'COMPLETED' ? 'selected' : ''}>Hoàn thành</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group full">
                        <label class="form-label">Trường đại học <span class="required">*</span></label>
                        <div class="input-wrap">
                            <i class="bi bi-building input-icon"></i>
                            <input type="text" name="university" class="form-input" value="${intern.university}" required placeholder="VD: Đại học Bách Khoa Hà Nội">
                        </div>
                    </div>
                    <div class="form-group full">
                        <label class="form-label">Chuyên ngành <span class="required">*</span></label>
                        <div class="input-wrap">
                            <i class="bi bi-book input-icon"></i>
                            <input type="text" name="major" class="form-input" value="${intern.major}" required placeholder="VD: Công nghệ thông tin">
                        </div>
                    </div>
                </div>

                <%-- 3. Login Credentials --%>
                <div class="section-label"><i class="bi bi-shield-lock"></i> 3. Thông tin đăng nhập</div>
                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label">Tên đăng nhập <span class="required">*</span></label>
                        <div class="input-wrap">
                            <i class="bi bi-at input-icon"></i>
                            <input type="text" name="username" class="form-input" value="${param.username}" required placeholder="VD: intern03" autocomplete="off">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Mật khẩu <span class="required">*</span></label>
                        <div class="input-wrap">
                            <i class="bi bi-lock input-icon"></i>
                            <input type="password" name="password" id="pwField" class="form-input" required placeholder="Tối thiểu 6 ký tự" autocomplete="new-password" style="padding-right:40px;">
                            <button type="button" class="pw-toggle" onclick="togglePw()">
                                <i class="bi bi-eye" id="pwEye"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/hr/dashboard" class="btn-cancel">
                        <i class="bi bi-x"></i> Hủy
                    </a>
                    <button type="submit" class="btn-save" id="submitBtn">
                        <i class="bi bi-check-lg"></i> Tạo hồ sơ
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function togglePw() {
        var f = document.getElementById('pwField');
        var eye = document.getElementById('pwEye');
        if (f.type === 'password') { f.type = 'text'; eye.className = 'bi bi-eye-slash'; }
        else { f.type = 'password'; eye.className = 'bi bi-eye'; }
    }
    document.getElementById('internForm').addEventListener('submit', function () {
        var btn = document.getElementById('submitBtn');
        btn.disabled = true;
        btn.innerHTML = '<i class="bi bi-arrow-repeat"></i> Đang lưu...';
    });
</script>
</body>
</html>
