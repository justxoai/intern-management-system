<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Hợp đồng Thực tập — HR</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root { --sidebar-w:250px; --sidebar-bg:#0c1f3f; --accent:#0ea5e9; --page-bg:#f0f6ff; --card-bg:#fff; --text-primary:#0f172a; --text-muted:#64748b; --border:#e2e8f0; }
        body { font-family:'Inter',sans-serif; background:var(--page-bg); display:flex; min-height:100vh; }

        .sidebar { width:var(--sidebar-w); background:var(--sidebar-bg); display:flex; flex-direction:column; flex-shrink:0; position:fixed; height:100vh; overflow-y:auto; z-index:100; }
        .sidebar-brand { padding:28px 22px 20px; border-bottom:1px solid rgba(255,255,255,.08); }
        .sidebar-brand .brand-icon { width:40px;height:40px;border-radius:10px;background:linear-gradient(135deg,#0ea5e9,#38bdf8);display:flex;align-items:center;justify-content:center;font-size:1.15rem;color:#fff;margin-bottom:10px; }
        .sidebar-brand h1 { color:#fff;font-size:.95rem;font-weight:700;line-height:1.3; }
        .sidebar-brand span { color:rgba(255,255,255,.4);font-size:.72rem; }
        .sidebar-section-label { padding:18px 22px 6px;font-size:.67rem;font-weight:700;text-transform:uppercase;letter-spacing:.8px;color:rgba(255,255,255,.3); }
        .sidebar-nav { list-style:none; padding:0 12px; }
        .sidebar-nav li a { display:flex;align-items:center;gap:10px;padding:10px 12px;border-radius:8px;margin-bottom:2px;text-decoration:none;color:rgba(255,255,255,.65);font-size:.84rem;font-weight:500;transition:background .15s,color .15s; }
        .sidebar-nav li a:hover { background:rgba(255,255,255,.07);color:#fff; }
        .sidebar-nav li a.active { background:rgba(14,165,233,.2);color:#fff;border-left:3px solid var(--accent); }
        .sidebar-nav li a i { font-size:1rem;width:20px; }
        .sidebar-footer { margin-top:auto;padding:16px 22px;border-top:1px solid rgba(255,255,255,.08); }
        .sidebar-user { display:flex;align-items:center;gap:10px; }
        .avatar { width:34px;height:34px;border-radius:50%;background:linear-gradient(135deg,#0ea5e9,#38bdf8);display:flex;align-items:center;justify-content:center;font-size:.85rem;color:#fff;font-weight:700;flex-shrink:0; }
        .sidebar-user-info { flex:1;min-width:0; }
        .sidebar-user-name { color:#fff;font-size:.82rem;font-weight:600;white-space:nowrap;overflow:hidden;text-overflow:ellipsis; }
        .sidebar-user-role { color:rgba(255,255,255,.4);font-size:.7rem; }
        .logout-btn { color:rgba(255,255,255,.4);font-size:1rem;text-decoration:none;transition:color .15s; }
        .logout-btn:hover { color:#f87171; }

        .main { margin-left:var(--sidebar-w);flex:1;display:flex;flex-direction:column; }
        .topbar { background:var(--card-bg);padding:16px 32px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;position:sticky;top:0;z-index:50;box-shadow:0 1px 4px rgba(0,0,0,.06); }
        .page-title { font-size:1.2rem;font-weight:700;color:var(--text-primary); }
        .page-sub { font-size:.8rem;color:var(--text-muted);margin-top:1px; }
        .content { padding:28px 32px;flex:1; }

        .alert { display:flex;align-items:center;gap:10px;padding:12px 16px;border-radius:10px;font-size:.86rem;font-weight:500;margin-bottom:20px; }
        .alert-success { background:#f0fdf4;color:#15803d;border:1px solid #bbf7d0; }
        .alert-error   { background:#fef2f2;color:#dc2626;border:1px solid #fecaca; }

        /* Upload form card */
        .upload-card { background:var(--card-bg);border-radius:16px;border:1px solid var(--border);padding:28px 28px;margin-bottom:24px;box-shadow:0 1px 6px rgba(0,0,0,.05); }
        .upload-card-title { font-size:1rem;font-weight:700;color:var(--text-primary);margin-bottom:20px;display:flex;align-items:center;gap:8px; }
        .upload-card-title i { color:var(--accent); }
        .form-grid { display:grid;grid-template-columns:1fr 1fr 1fr;gap:14px; }
        .form-grid .full { grid-column:1/-1; }
        .form-group { display:flex;flex-direction:column;gap:5px; }
        .form-label { font-size:.75rem;font-weight:700;color:var(--text-muted);text-transform:uppercase;letter-spacing:.4px; }
        .form-input,.form-select { padding:9px 12px;border:1.5px solid var(--border);border-radius:9px;font-family:'Inter',sans-serif;font-size:.84rem;color:var(--text-primary);background:#fff;outline:none;transition:border-color .2s; }
        .form-input:focus,.form-select:focus { border-color:var(--accent); }
        .file-label { display:flex;align-items:center;gap:8px;padding:9px 14px;border:1.5px dashed var(--accent);border-radius:9px;cursor:pointer;font-size:.84rem;font-weight:500;color:var(--accent);background:#f0f9ff;transition:background .15s; }
        .file-label:hover { background:#e0f2fe; }
        .file-input { display:none; }
        .selected-name { font-size:.78rem;color:var(--text-muted);margin-top:4px; }
        .btn-submit { padding:10px 26px;border-radius:9px;border:none;cursor:pointer;font-family:'Inter',sans-serif;font-size:.87rem;font-weight:700;background:linear-gradient(135deg,#0ea5e9,#38bdf8);color:#fff;box-shadow:0 2px 12px rgba(14,165,233,.35);transition:opacity .15s; }
        .btn-submit:hover { opacity:.88; }

        /* Table */
        .sec-card { background:var(--card-bg);border-radius:16px;border:1px solid var(--border);overflow:hidden;box-shadow:0 1px 6px rgba(0,0,0,.05); }
        .sec-header { padding:16px 22px;display:flex;align-items:center;gap:10px;border-bottom:1px solid var(--border); }
        .sec-icon { width:36px;height:36px;border-radius:9px;background:#eff6ff;color:var(--accent);display:flex;align-items:center;justify-content:center;font-size:.95rem; }
        .sec-title { font-size:.95rem;font-weight:700;color:var(--text-primary);flex:1; }
        .sec-count { background:#eff6ff;color:var(--accent);font-size:.72rem;font-weight:600;padding:3px 10px;border-radius:20px; }

        .filter-bar { background:#f8fafc;padding:12px 22px;border-bottom:1px solid var(--border);display:flex;align-items:flex-end;gap:10px; }
        .filter-group { display:flex;flex-direction:column;gap:4px; }
        .filter-label { font-size:.68rem;font-weight:700;color:var(--text-muted);text-transform:uppercase;letter-spacing:.4px; }
        .filter-select { padding:7px 10px;border:1.5px solid var(--border);border-radius:8px;font-family:'Inter',sans-serif;font-size:.81rem;color:var(--text-primary);background:#fff;outline:none;min-width:150px; }
        .btn-filter { padding:7px 16px;border-radius:8px;border:none;cursor:pointer;font-family:'Inter',sans-serif;font-size:.81rem;font-weight:600;display:flex;align-items:center;gap:5px;transition:opacity .15s; }
        .btn-filter.blue { background:var(--accent);color:#fff; }
        .btn-filter.ghost { background:var(--border);color:var(--text-muted);text-decoration:none; }
        .btn-filter:hover { opacity:.85; }

        .data-table { width:100%;border-collapse:collapse; }
        .data-table thead th { padding:11px 16px;text-align:left;font-size:.7rem;font-weight:700;text-transform:uppercase;letter-spacing:.5px;color:var(--text-muted);background:#f8fafc;border-bottom:1px solid var(--border); }
        .data-table tbody td { padding:13px 16px;font-size:.85rem;color:var(--text-primary);border-bottom:1px solid #f1f5f9;vertical-align:middle; }
        .data-table tbody tr:last-child td { border-bottom:none; }
        .data-table tbody tr:hover td { background:#f0f9ff; }

        .intern-cell { display:flex;align-items:center;gap:9px; }
        .intern-avatar { width:30px;height:30px;border-radius:50%;background:linear-gradient(135deg,#0ea5e9,#38bdf8);display:flex;align-items:center;justify-content:center;font-size:.75rem;font-weight:700;color:#fff;flex-shrink:0; }

        .badge { display:inline-flex;align-items:center;gap:4px;padding:4px 11px;border-radius:20px;font-size:.7rem;font-weight:600; }
        .badge-pending   { background:#fefce8;color:#a16207; }
        .badge-confirmed { background:#f0fdf4;color:#16a34a; }
        .badge-cancelled { background:#f1f5f9;color:#475569; }

        .btn-view   { display:inline-flex;align-items:center;gap:5px;padding:5px 12px;border-radius:7px;text-decoration:none;font-size:.78rem;font-weight:600;background:#eff6ff;color:var(--accent);border:1px solid #bfdbfe;transition:all .15s; }
        .btn-view:hover { background:var(--accent);color:#fff; }
        .btn-cancel { padding:5px 12px;border-radius:7px;border:1px solid #fecaca;background:#fef2f2;color:#dc2626;font-size:.78rem;font-weight:600;cursor:pointer;font-family:'Inter',sans-serif;transition:all .15s; }
        .btn-cancel:hover { background:#dc2626;color:#fff; }
        .empty-state { padding:48px;text-align:center;color:var(--text-muted); }
        .empty-state i { font-size:2rem;display:block;margin-bottom:10px;opacity:.35; }
    </style>
</head>
<body>
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
        <li><a href="${pageContext.request.contextPath}/hr/contracts" class="active"><i class="bi bi-file-earmark-text"></i> Hợp đồng</a></li>
        <li><a href="${pageContext.request.contextPath}/hr/documents"><i class="bi bi-folder-check"></i> Duyệt tài liệu</a></li>
    </ul>
    <div class="sidebar-footer">
        <div class="sidebar-user">
            <div class="avatar">${fn:substring(sessionScope.currentUser.fullName,0,1)}</div>
            <div class="sidebar-user-info">
                <div class="sidebar-user-name">${sessionScope.currentUser.fullName}</div>
                <div class="sidebar-user-role">Nhân sự</div>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn" title="Đăng xuất"><i class="bi bi-box-arrow-right"></i></a>
        </div>
    </div>
</aside>

<div class="main">
    <div class="topbar">
        <div>
            <div class="page-title">Hợp đồng Thực tập</div>
            <div class="page-sub">Tải lên và quản lý hợp đồng thực tập</div>
        </div>
    </div>

    <div class="content">
        <c:if test="${not empty param.success}">
            <div class="alert alert-success"><i class="bi bi-check-circle-fill"></i>${param.success}</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-error"><i class="bi bi-exclamation-circle-fill"></i>${param.error}</div>
        </c:if>

        <%-- Upload form --%>
        <div class="upload-card">
            <div class="upload-card-title"><i class="bi bi-cloud-upload"></i>Tải lên hợp đồng mới</div>
            <form method="post" action="${pageContext.request.contextPath}/hr/contracts/upload" enctype="multipart/form-data" id="uploadForm">
                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label">Thực tập sinh <span style="color:#ef4444">*</span></label>
                        <select name="internId" class="form-select" required>
                            <option value="">— Chọn thực tập sinh —</option>
                            <c:forEach var="i" items="${interns}">
                                <option value="${i.id}">${i.studentCode} — ${not empty i.fullName ? i.fullName : i.email}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Ngày bắt đầu <span style="color:#ef4444">*</span></label>
                        <input type="date" name="startDate" class="form-input" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Ngày kết thúc <span style="color:#ef4444">*</span></label>
                        <input type="date" name="endDate" class="form-input" required>
                    </div>
                    <div class="form-group full">
                        <label class="form-label">Tệp hợp đồng (PDF/DOC) <span style="color:#ef4444">*</span></label>
                        <label class="file-label" for="contractFile">
                            <i class="bi bi-paperclip"></i>
                            <span id="fileLabel">Nhấp để chọn tệp…</span>
                        </label>
                        <input type="file" id="contractFile" name="file" class="file-input" accept=".pdf,.doc,.docx" required
                               onchange="document.getElementById('fileLabel').textContent = this.files[0].name">
                    </div>
                </div>
                <div style="margin-top:16px">
                    <button type="submit" class="btn-submit"><i class="bi bi-send me-1"></i>Tải lên hợp đồng</button>
                </div>
            </form>
        </div>

        <%-- Contract list --%>
        <div class="sec-card">
            <div class="sec-header">
                <div class="sec-icon"><i class="bi bi-file-earmark-text"></i></div>
                <span class="sec-title">Tất cả hợp đồng</span>
                <span class="sec-count">${fn:length(contracts)}</span>
            </div>
            <form class="filter-bar" method="get" action="${pageContext.request.contextPath}/hr/contracts">
                <div class="filter-group">
                    <span class="filter-label">Trạng thái</span>
                    <select class="filter-select" name="status">
                        <option value="">Tất cả</option>
                        <option value="PENDING"   ${statusFilter == 'PENDING'   ? 'selected':''}>Chờ xác nhận</option>
                        <option value="CONFIRMED" ${statusFilter == 'CONFIRMED' ? 'selected':''}>Đã xác nhận</option>
                        <option value="CANCELLED" ${statusFilter == 'CANCELLED' ? 'selected':''}>Đã hủy</option>
                    </select>
                </div>
                <button type="submit" class="btn-filter blue"><i class="bi bi-funnel"></i>Lọc</button>
                <a href="${pageContext.request.contextPath}/hr/contracts" class="btn-filter ghost">Xóa lọc</a>
            </form>
            <table class="data-table">
                <thead><tr>
                    <th>Thực tập sinh</th><th>Thời hạn</th><th>Tệp tin</th><th>Trạng thái</th><th>Ngày xác nhận</th><th>Thao tác</th>
                </tr></thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty contracts}">
                            <tr><td colspan="6"><div class="empty-state"><i class="bi bi-inbox"></i>Chưa có hợp đồng nào.</div></td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="c" items="${contracts}">
                                <tr>
                                    <td>
                                        <div class="intern-cell">
                                            <div class="intern-avatar">${fn:substring(c.internName,0,1)}</div>
                                            <div>
                                                <div style="font-weight:600">${c.internName}</div>
                                                <div style="font-size:.75rem;color:var(--text-muted)">${c.studentCode}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td style="font-size:.82rem">
                                        <c:if test="${not empty c.startDate}">${c.startDate} → ${c.endDate}</c:if>
                                        <c:if test="${empty c.startDate}">—</c:if>
                                    </td>
                                    <td>
                                        <c:if test="${not empty c.filePath}">
                                            <a href="${pageContext.request.contextPath}${c.filePath}" class="btn-view" target="_blank"><i class="bi bi-eye"></i>Xem</a>
                                        </c:if>
                                        <c:if test="${empty c.filePath}"><span style="color:var(--text-muted);font-size:.8rem">Không có tệp</span></c:if>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${c.status == 'CONFIRMED'}"><span class="badge badge-confirmed"><i class="bi bi-check-circle-fill" style="font-size:.6rem"></i>Đã xác nhận</span></c:when>
                                            <c:when test="${c.status == 'CANCELLED'}"><span class="badge badge-cancelled"><i class="bi bi-dash-circle-fill" style="font-size:.6rem"></i>Đã hủy</span></c:when>
                                            <c:otherwise><span class="badge badge-pending"><i class="bi bi-clock-fill" style="font-size:.6rem"></i>Chờ xác nhận</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="color:var(--text-muted);font-size:.78rem">
                                        <c:choose>
                                            <c:when test="${not empty c.confirmedAt}">${c.confirmedAt}</c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:if test="${c.status == 'PENDING'}">
                                            <form method="post" action="${pageContext.request.contextPath}/hr/contracts/cancel" style="display:inline" onsubmit="return confirm('Hủy hợp đồng này?')">
                                                <input type="hidden" name="id" value="${c.id}">
                                                <button type="submit" class="btn-cancel"><i class="bi bi-x"></i>Hủy</button>
                                            </form>
                                        </c:if>
                                        <c:if test="${c.status != 'PENDING'}">
                                            <span style="color:var(--text-muted);font-size:.78rem;font-style:italic">—</span>
                                        </c:if>
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
</body>
</html>
