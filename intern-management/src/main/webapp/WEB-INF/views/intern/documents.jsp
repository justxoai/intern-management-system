<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Tài liệu của tôi — Cổng TTS</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --sidebar-w: 250px;
            --sidebar-bg: #1a0533;
            --accent: #8b5cf6;
            --accent2: #a78bfa;
            --page-bg: #faf5ff;
            --card-bg: #fff;
            --text-primary: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
        }
        body { font-family: 'Inter', sans-serif; background: var(--page-bg); display: flex; min-height: 100vh; }

        /* Sidebar */
        .sidebar { width: var(--sidebar-w); background: var(--sidebar-bg); display: flex; flex-direction: column; flex-shrink: 0; position: fixed; height: 100vh; overflow-y: auto; z-index: 100; }
        .sidebar-brand { padding: 28px 22px 20px; border-bottom: 1px solid rgba(255,255,255,.08); }
        .sidebar-brand .brand-icon { width: 40px; height: 40px; border-radius: 10px; background: linear-gradient(135deg, #8b5cf6, #a78bfa); display: flex; align-items: center; justify-content: center; font-size: 1.15rem; color: #fff; margin-bottom: 10px; }
        .sidebar-brand h1 { color: #fff; font-size: .95rem; font-weight: 700; line-height: 1.3; }
        .sidebar-brand span { color: rgba(255,255,255,.4); font-size: .72rem; }
        .sidebar-section-label { padding: 18px 22px 6px; font-size: .67rem; font-weight: 700; text-transform: uppercase; letter-spacing: .8px; color: rgba(255,255,255,.3); }
        .sidebar-nav { list-style: none; padding: 0 12px; }
        .sidebar-nav li a { display: flex; align-items: center; gap: 10px; padding: 10px 12px; border-radius: 8px; margin-bottom: 2px; text-decoration: none; color: rgba(255,255,255,.65); font-size: .84rem; font-weight: 500; transition: background .15s, color .15s; }
        .sidebar-nav li a:hover { background: rgba(255,255,255,.07); color: #fff; }
        .sidebar-nav li a.active { background: rgba(139,92,246,.25); color: #fff; border-left: 3px solid var(--accent); }
        .sidebar-nav li a i { font-size: 1rem; width: 20px; }
        .sidebar-footer { margin-top: auto; padding: 16px 22px; border-top: 1px solid rgba(255,255,255,.08); }
        .sidebar-user { display: flex; align-items: center; gap: 10px; }
        .avatar { width: 34px; height: 34px; border-radius: 50%; background: linear-gradient(135deg, #8b5cf6, #a78bfa); display: flex; align-items: center; justify-content: center; font-size: .85rem; color: #fff; font-weight: 700; flex-shrink: 0; }
        .sidebar-user-info { flex: 1; min-width: 0; }
        .sidebar-user-name { color: #fff; font-size: .82rem; font-weight: 600; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .sidebar-user-role { color: rgba(255,255,255,.4); font-size: .7rem; }
        .logout-btn { color: rgba(255,255,255,.4); font-size: 1rem; text-decoration: none; transition: color .15s; }
        .logout-btn:hover { color: #f87171; }

        /* Main */
        .main { margin-left: var(--sidebar-w); flex: 1; display: flex; flex-direction: column; }
        .topbar { background: var(--card-bg); padding: 16px 32px; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; position: sticky; top: 0; z-index: 50; box-shadow: 0 1px 4px rgba(0,0,0,.06); }
        .page-title { font-size: 1.2rem; font-weight: 700; color: var(--text-primary); }
        .page-sub { font-size: .8rem; color: var(--text-muted); margin-top: 1px; }
        .content { padding: 28px 32px; flex: 1; }

        /* Alert */
        .alert { display: flex; align-items: center; gap: 10px; padding: 14px 18px; border-radius: 12px; font-size: .87rem; font-weight: 500; margin-bottom: 22px; }
        .alert-success { background: #f0fdf4; color: #15803d; border: 1px solid #bbf7d0; }
        .alert-error   { background: #fef2f2; color: #dc2626; border: 1px solid #fecaca; }

        /* Upload cards */
        .upload-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; margin-bottom: 28px; }
        .upload-card { background: var(--card-bg); border: 2px dashed var(--border); border-radius: 16px; padding: 28px 24px; text-align: center; transition: border-color .2s, box-shadow .2s; cursor: pointer; }
        .upload-card:hover { border-color: var(--accent); box-shadow: 0 4px 20px rgba(139,92,246,.12); }
        .upload-card.drag-over { border-color: var(--accent); background: #faf5ff; }
        .upload-icon { width: 56px; height: 56px; border-radius: 14px; margin: 0 auto 14px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; }
        .ui-cv   { background: linear-gradient(135deg, #8b5cf6, #a78bfa); color: #fff; box-shadow: 0 4px 14px rgba(139,92,246,.3); }
        .ui-app  { background: linear-gradient(135deg, #0ea5e9, #38bdf8); color: #fff; box-shadow: 0 4px 14px rgba(14,165,233,.3); }
        .upload-title { font-weight: 700; font-size: .95rem; color: var(--text-primary); margin-bottom: 6px; }
        .upload-desc  { font-size: .78rem; color: var(--text-muted); margin-bottom: 16px; line-height: 1.5; }
        .upload-hint  { font-size: .72rem; color: var(--text-muted); margin-top: 10px; }
        .file-input-wrap { position: relative; }
        .file-input-wrap input[type="file"] { position: absolute; inset: 0; opacity: 0; cursor: pointer; width: 100%; }
        .btn-upload { display: inline-flex; align-items: center; gap: 7px; padding: 9px 22px; border-radius: 9px; border: none; font-family: 'Inter', sans-serif; font-size: .84rem; font-weight: 600; cursor: pointer; transition: opacity .15s; }
        .btn-cv  { background: linear-gradient(135deg, #8b5cf6, #a78bfa); color: #fff; box-shadow: 0 2px 10px rgba(139,92,246,.3); }
        .btn-app { background: linear-gradient(135deg, #0ea5e9, #38bdf8); color: #fff; box-shadow: 0 2px 10px rgba(14,165,233,.3); }
        .btn-upload:hover { opacity: .88; }
        .selected-file { font-size: .76rem; color: var(--accent); margin-top: 8px; font-weight: 500; display: none; }

        /* Document list */
        .sec-card { background: var(--card-bg); border-radius: 16px; border: 1px solid var(--border); overflow: hidden; box-shadow: 0 1px 6px rgba(0,0,0,.05); }
        .sec-header { padding: 16px 22px; display: flex; align-items: center; gap: 10px; border-bottom: 1px solid var(--border); }
        .sec-icon { width: 36px; height: 36px; border-radius: 9px; background: #f5f3ff; color: var(--accent); display: flex; align-items: center; justify-content: center; font-size: .95rem; }
        .sec-title { font-size: .95rem; font-weight: 700; color: var(--text-primary); flex: 1; }
        .sec-count { background: #f5f3ff; color: var(--accent); font-size: .72rem; font-weight: 600; padding: 3px 10px; border-radius: 20px; }

        .data-table { width: 100%; border-collapse: collapse; }
        .data-table thead th { padding: 11px 16px; text-align: left; font-size: .7rem; font-weight: 700; text-transform: uppercase; letter-spacing: .5px; color: var(--text-muted); background: #faf5ff; border-bottom: 1px solid var(--border); }
        .data-table tbody td { padding: 14px 16px; font-size: .85rem; color: var(--text-primary); border-bottom: 1px solid #f1f5f9; vertical-align: middle; }
        .data-table tbody tr:last-child td { border-bottom: none; }
        .data-table tbody tr:hover td { background: #faf5ff; }

        .doc-type-badge { display: inline-flex; align-items: center; gap: 5px; padding: 4px 11px; border-radius: 8px; font-size: .75rem; font-weight: 600; }
        .dt-cv   { background: #f5f3ff; color: #7c3aed; }
        .dt-app  { background: #eff6ff; color: #1d4ed8; }
        .dt-contract { background: #f0fdf4; color: #16a34a; }

        .badge { display: inline-flex; align-items: center; gap: 4px; padding: 4px 11px; border-radius: 20px; font-size: .7rem; font-weight: 600; }
        .badge-pending  { background: #fefce8; color: #a16207; }
        .badge-approved { background: #f0fdf4; color: #16a34a; }
        .badge-rejected { background: #fef2f2; color: #dc2626; }

        .btn-download { display: inline-flex; align-items: center; gap: 5px; padding: 5px 12px; border-radius: 7px; text-decoration: none; font-size: .78rem; font-weight: 600; background: #f5f3ff; color: var(--accent); border: 1px solid #ddd6fe; transition: all .15s; }
        .btn-download:hover { background: var(--accent); color: #fff; }
        .btn-delete { display: inline-flex; align-items: center; gap: 5px; padding: 5px 10px; border-radius: 7px; border: 1px solid #fecaca; background: #fef2f2; color: #dc2626; font-size: .78rem; font-weight: 600; cursor: pointer; font-family: 'Inter', sans-serif; transition: all .15s; }
        .btn-delete:hover { background: #dc2626; color: #fff; }

        .empty-state { padding: 48px; text-align: center; color: var(--text-muted); }
        .empty-state i { font-size: 2.5rem; margin-bottom: 12px; display: block; opacity: .35; }
        .empty-state p { font-size: .9rem; }

        /* Profile info card */
        .profile-card { background: linear-gradient(135deg, #1a0533, #3b0764); border-radius: 16px; padding: 24px 28px; margin-bottom: 24px; display: flex; align-items: center; gap: 20px; }
        .profile-avatar { width: 56px; height: 56px; border-radius: 50%; background: rgba(255,255,255,.15); border: 2px solid rgba(255,255,255,.3); display: flex; align-items: center; justify-content: center; font-size: 1.4rem; color: #fff; font-weight: 700; flex-shrink: 0; }
        .profile-info h2 { color: #fff; font-size: 1.1rem; font-weight: 700; margin-bottom: 4px; }
        .profile-info p  { color: rgba(255,255,255,.7); font-size: .82rem; }
        .profile-code { margin-left: auto; background: rgba(255,255,255,.12); border-radius: 10px; padding: 10px 18px; text-align: center; }
        .profile-code .code { color: #fff; font-size: 1.2rem; font-weight: 800; font-family: monospace; }
        .profile-code .label { color: rgba(255,255,255,.6); font-size: .7rem; margin-top: 2px; }
    </style>
</head>
<body>

<!-- Sidebar -->
<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-icon"><i class="bi bi-person-workspace"></i></div>
        <h1>Cổng thông tin<br>Thực tập sinh</h1>
        <span>Hồ sơ của tôi</span>
    </div>
    <div class="sidebar-section-label">Không gian của tôi</div>
    <ul class="sidebar-nav">
        <li><a href="${pageContext.request.contextPath}/intern/documents" class="active">
            <i class="bi bi-folder2-open"></i> Tài liệu của tôi
        </a></li>
        <li><a href="${pageContext.request.contextPath}/intern/contracts">
            <i class="bi bi-file-earmark-check"></i> Hợp đồng của tôi
        </a></li>
        <li><a href="${pageContext.request.contextPath}/intern/tasks">
            <i class="bi bi-list-task"></i> Nhiệm vụ của tôi
        </a></li>
        <li><a href="${pageContext.request.contextPath}/intern/reports">
            <i class="bi bi-journal-text"></i> Báo cáo tuần
        </a></li>
    </ul>
    <div class="sidebar-footer">
        <div class="sidebar-user">
            <div class="avatar">${fn:substring(sessionScope.currentUser.fullName, 0, 1)}</div>
            <div class="sidebar-user-info">
                <div class="sidebar-user-name">${sessionScope.currentUser.fullName}</div>
                <div class="sidebar-user-role">Thực tập sinh</div>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn" title="Đăng xuất">
                <i class="bi bi-box-arrow-right"></i>
            </a>
        </div>
    </div>
</aside>

<!-- Main -->
<div class="main">
    <div class="topbar">
        <div>
            <div class="page-title">Tài liệu của tôi</div>
            <div class="page-sub">Tải lên và theo dõi tài liệu thực tập của bạn</div>
        </div>
    </div>

    <div class="content">

        <%-- Flash messages --%>
        <c:if test="${not empty param.success}">
            <div class="alert alert-success"><i class="bi bi-check-circle-fill"></i>${param.success}</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-error"><i class="bi bi-exclamation-circle-fill"></i>${param.error}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error"><i class="bi bi-exclamation-circle-fill"></i>${error}</div>
        </c:if>

        <%-- Profile info strip --%>
        <c:if test="${not empty intern}">
            <div class="profile-card">
                <div class="profile-avatar">${fn:substring(sessionScope.currentUser.fullName, 0, 1)}</div>
                <div class="profile-info">
                    <h2>${sessionScope.currentUser.fullName}</h2>
                    <p>${intern.major} · ${intern.university}</p>
                </div>
                <div class="profile-code">
                    <div class="code">${intern.studentCode}</div>
                    <div class="label">Mã sinh viên</div>
                </div>
            </div>
        </c:if>

        <%-- Upload Cards --%>
        <c:if test="${not empty intern}">
            <div class="upload-grid">
                <%-- CV Upload --%>
                <div class="upload-card" id="cvCard">
                    <div class="upload-icon ui-cv"><i class="bi bi-file-person"></i></div>
                    <div class="upload-title">Sơ yếu lý lịch (CV)</div>
                    <div class="upload-desc">Tải lên CV để thể hiện kỹ năng, học vấn và kinh nghiệm với phòng Nhân sự.</div>
                    <form method="post" action="${pageContext.request.contextPath}/intern/documents/upload" enctype="multipart/form-data" id="cvForm">
                        <input type="hidden" name="documentType" value="CV">
                        <div class="file-input-wrap">
                            <button type="button" class="btn-upload btn-cv" onclick="document.getElementById('cvFile').click()">
                                <i class="bi bi-cloud-upload"></i> Chọn tệp
                            </button>
                            <input type="file" id="cvFile" name="file" accept=".pdf,.doc,.docx" onchange="showSelected(this,'cvSelected','cvForm')">
                        </div>
                        <div class="selected-file" id="cvSelected"></div>
                        <div class="upload-hint">PDF, DOC, DOCX · tối đa 10 MB</div>
                    </form>
                </div>

                <%-- Internship Application Upload --%>
                <div class="upload-card" id="appCard">
                    <div class="upload-icon ui-app"><i class="bi bi-file-earmark-text"></i></div>
                    <div class="upload-title">Đơn xin thực tập</div>
                    <div class="upload-desc">Tải lên đơn xin thực tập có chữ ký để hoàn thiện hồ sơ của bạn.</div>
                    <form method="post" action="${pageContext.request.contextPath}/intern/documents/upload" enctype="multipart/form-data" id="appForm">
                        <input type="hidden" name="documentType" value="INTERNSHIP_APPLICATION">
                        <div class="file-input-wrap">
                            <button type="button" class="btn-upload btn-app" onclick="document.getElementById('appFile').click()">
                                <i class="bi bi-cloud-upload"></i> Chọn tệp
                            </button>
                            <input type="file" id="appFile" name="file" accept=".pdf,.doc,.docx" onchange="showSelected(this,'appSelected','appForm')">
                        </div>
                        <div class="selected-file" id="appSelected"></div>
                        <div class="upload-hint">PDF, DOC, DOCX · tối đa 10 MB</div>
                    </form>
                </div>
            </div>
        </c:if>

        <%-- Document list --%>
        <div class="sec-card">
            <div class="sec-header">
                <div class="sec-icon"><i class="bi bi-files"></i></div>
                <span class="sec-title">Tài liệu đã tải lên</span>
                <span class="sec-count">${fn:length(documents)}</span>
            </div>
            <table class="data-table">
                <thead><tr>
                    <th>Loại tài liệu</th><th>Tên tệp</th><th>Ngày tải</th><th>Trạng thái</th><th>Thao tác</th>
                </tr></thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty documents}">
                            <tr><td colspan="5">
                                <div class="empty-state">
                                    <i class="bi bi-folder2"></i>
                                    <p>Chưa có tài liệu nào được tải lên.<br>Sử dụng các khung tải lên phía trên để bắt đầu.</p>
                                </div>
                            </td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="d" items="${documents}">
                                <tr>
                                    <td>
                                        <c:choose>
                                            <c:when test="${d.documentType == 'CV'}">
                                                <span class="doc-type-badge dt-cv"><i class="bi bi-file-person"></i>CV</span>
                                            </c:when>
                                            <c:when test="${d.documentType == 'INTERNSHIP_APPLICATION'}">
                                                <span class="doc-type-badge dt-app"><i class="bi bi-file-earmark-text"></i>Đơn xin TT</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="doc-type-badge dt-contract"><i class="bi bi-file-earmark-check"></i>Hợp đồng</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="font-weight:500">${d.fileName}</td>
                                    <td style="color:var(--text-muted);font-size:.8rem">${d.uploadedAt}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${d.status == 'APPROVED'}">
                                                <span class="badge badge-approved"><i class="bi bi-check-circle-fill" style="font-size:.6rem"></i>Đã duyệt</span>
                                            </c:when>
                                            <c:when test="${d.status == 'REJECTED'}">
                                                <span class="badge badge-rejected"><i class="bi bi-x-circle-fill" style="font-size:.6rem"></i>Bị từ chối</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-pending"><i class="bi bi-clock-fill" style="font-size:.6rem"></i>Chờ xét duyệt</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div style="display:flex;gap:6px;align-items:center">
                                            <a href="${pageContext.request.contextPath}${d.filePath}" class="btn-download" target="_blank">
                                                <i class="bi bi-download"></i> Xem
                                            </a>
                                            <c:if test="${d.status == 'PENDING'}">
                                                <form method="post" action="${pageContext.request.contextPath}/intern/documents/delete" style="display:inline"
                                                      onsubmit="return confirm('Xóa tài liệu này?')">
                                                    <input type="hidden" name="id" value="${d.id}">
                                                    <button type="submit" class="btn-delete"><i class="bi bi-trash"></i></button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

    </div>
</div>

<script>
    function showSelected(input, labelId, formId) {
        var label = document.getElementById(labelId);
        if (input.files && input.files[0]) {
            label.textContent = '✓ ' + input.files[0].name;
            label.style.display = 'block';
            // Auto-submit
            document.getElementById(formId).submit();
        }
    }

    // Drag & drop visual
    ['cvCard','appCard'].forEach(function(id) {
        var card = document.getElementById(id);
        if (!card) return;
        card.addEventListener('dragover', function(e) { e.preventDefault(); card.classList.add('drag-over'); });
        card.addEventListener('dragleave', function() { card.classList.remove('drag-over'); });
        card.addEventListener('drop', function(e) {
            e.preventDefault(); card.classList.remove('drag-over');
        });
    });
</script>
</body>
</html>
