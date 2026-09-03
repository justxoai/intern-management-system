<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Hợp đồng của tôi — Cổng TTS</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root { --sidebar-w:250px;--sidebar-bg:#1a0533;--accent:#8b5cf6;--page-bg:#faf5ff;--card-bg:#fff;--text-primary:#0f172a;--text-muted:#64748b;--border:#e2e8f0; }
        body { font-family:'Inter',sans-serif;background:var(--page-bg);display:flex;min-height:100vh; }

        .sidebar { width:var(--sidebar-w);background:var(--sidebar-bg);display:flex;flex-direction:column;flex-shrink:0;position:fixed;height:100vh;overflow-y:auto;z-index:100; }
        .sidebar-brand { padding:28px 22px 20px;border-bottom:1px solid rgba(255,255,255,.08); }
        .sidebar-brand .brand-icon { width:40px;height:40px;border-radius:10px;background:linear-gradient(135deg,#8b5cf6,#a78bfa);display:flex;align-items:center;justify-content:center;font-size:1.15rem;color:#fff;margin-bottom:10px; }
        .sidebar-brand h1 { color:#fff;font-size:.95rem;font-weight:700;line-height:1.3; }
        .sidebar-brand span { color:rgba(255,255,255,.4);font-size:.72rem; }
        .sidebar-section-label { padding:18px 22px 6px;font-size:.67rem;font-weight:700;text-transform:uppercase;letter-spacing:.8px;color:rgba(255,255,255,.3); }
        .sidebar-nav { list-style:none;padding:0 12px; }
        .sidebar-nav li a { display:flex;align-items:center;gap:10px;padding:10px 12px;border-radius:8px;margin-bottom:2px;text-decoration:none;color:rgba(255,255,255,.65);font-size:.84rem;font-weight:500;transition:background .15s,color .15s; }
        .sidebar-nav li a:hover { background:rgba(255,255,255,.07);color:#fff; }
        .sidebar-nav li a.active { background:rgba(139,92,246,.25);color:#fff;border-left:3px solid var(--accent); }
        .sidebar-nav li a i { font-size:1rem;width:20px; }
        .sidebar-footer { margin-top:auto;padding:16px 22px;border-top:1px solid rgba(255,255,255,.08); }
        .sidebar-user { display:flex;align-items:center;gap:10px; }
        .avatar { width:34px;height:34px;border-radius:50%;background:linear-gradient(135deg,#8b5cf6,#a78bfa);display:flex;align-items:center;justify-content:center;font-size:.85rem;color:#fff;font-weight:700;flex-shrink:0; }
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

        /* Contract card */
        .contract-card { background:var(--card-bg);border-radius:16px;border:1px solid var(--border);margin-bottom:18px;overflow:hidden;box-shadow:0 1px 8px rgba(0,0,0,.06);transition:box-shadow .2s,transform .2s; }
        .contract-card:hover { box-shadow:0 6px 24px rgba(0,0,0,.10);transform:translateY(-2px); }
        .contract-card.confirmed { border-left:4px solid #10b981; }
        .contract-card.pending   { border-left:4px solid #f59e0b; }
        .contract-card.cancelled { border-left:4px solid #94a3b8; }

        .cc-header { padding:20px 24px;display:flex;align-items:center;justify-content:space-between; }
        .cc-icon { width:44px;height:44px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:1.2rem;flex-shrink:0;margin-right:14px; }
        .ci-pending   { background:linear-gradient(135deg,#f59e0b,#fbbf24);color:#fff;box-shadow:0 4px 12px rgba(245,158,11,.3); }
        .ci-confirmed { background:linear-gradient(135deg,#10b981,#34d399);color:#fff;box-shadow:0 4px 12px rgba(16,185,129,.3); }
        .ci-cancelled { background:#f1f5f9;color:#94a3b8; }
        .cc-info { flex:1; }
        .cc-title { font-size:1rem;font-weight:700;color:var(--text-primary);margin-bottom:4px; }
        .cc-period { font-size:.82rem;color:var(--text-muted); }

        .cc-body { padding:0 24px 20px;display:flex;align-items:center;gap:14px;flex-wrap:wrap; }
        .cc-meta { background:#f8fafc;border-radius:8px;padding:8px 14px;font-size:.8rem; }
        .cc-meta .label { color:var(--text-muted);font-size:.7rem;text-transform:uppercase;letter-spacing:.3px;margin-bottom:2px; }
        .cc-meta .value { font-weight:600;color:var(--text-primary); }

        .badge { display:inline-flex;align-items:center;gap:4px;padding:4px 12px;border-radius:20px;font-size:.72rem;font-weight:600; }
        .badge-pending   { background:#fefce8;color:#a16207; }
        .badge-confirmed { background:#f0fdf4;color:#16a34a; }
        .badge-cancelled { background:#f1f5f9;color:#475569; }

        .btn-confirm { padding:9px 22px;border-radius:9px;border:none;cursor:pointer;font-family:'Inter',sans-serif;font-size:.87rem;font-weight:700;background:linear-gradient(135deg,#8b5cf6,#a78bfa);color:#fff;box-shadow:0 3px 12px rgba(139,92,246,.35);transition:opacity .15s,transform .15s; }
        .btn-confirm:hover { opacity:.88;transform:translateY(-1px); }
        .btn-view   { display:inline-flex;align-items:center;gap:5px;padding:8px 16px;border-radius:9px;text-decoration:none;font-size:.84rem;font-weight:600;background:#f5f3ff;color:var(--accent);border:1px solid #ddd6fe;transition:all .15s; }
        .btn-view:hover { background:var(--accent);color:#fff; }

        .empty-state { padding:60px;text-align:center;color:var(--text-muted); }
        .empty-state i { font-size:3rem;display:block;margin-bottom:14px;opacity:.3; }
        .empty-state p { font-size:.9rem;line-height:1.6; }

        .info-banner { background:linear-gradient(135deg,#1a0533,#3b0764);border-radius:14px;padding:20px 24px;margin-bottom:24px;display:flex;align-items:center;gap:16px; }
        .info-banner i { font-size:1.8rem;color:rgba(255,255,255,.7); }
        .info-banner p { color:rgba(255,255,255,.85);font-size:.87rem;line-height:1.6; }
        .info-banner strong { color:#fff; }
    </style>
</head>
<body>
<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-icon"><i class="bi bi-person-workspace"></i></div>
        <h1>Cổng thông tin<br>Thực tập sinh</h1>
        <span>Hồ sơ của tôi</span>
    </div>
    <div class="sidebar-section-label">Không gian của tôi</div>
    <ul class="sidebar-nav">
        <li><a href="${pageContext.request.contextPath}/intern/documents"><i class="bi bi-folder2-open"></i>Tài liệu của tôi</a></li>
        <li><a href="${pageContext.request.contextPath}/intern/contracts" class="active"><i class="bi bi-file-earmark-check"></i>Hợp đồng của tôi</a></li>
        <li><a href="${pageContext.request.contextPath}/intern/tasks"><i class="bi bi-list-task"></i>Nhiệm vụ của tôi</a></li>
    </ul>
    <div class="sidebar-footer">
        <div class="sidebar-user">
            <div class="avatar">${fn:substring(sessionScope.currentUser.fullName,0,1)}</div>
            <div class="sidebar-user-info">
                <div class="sidebar-user-name">${sessionScope.currentUser.fullName}</div>
                <div class="sidebar-user-role">Thực tập sinh</div>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn" title="Đăng xuất"><i class="bi bi-box-arrow-right"></i></a>
        </div>
    </div>
</aside>

<div class="main">
    <div class="topbar">
        <div>
            <div class="page-title">Hợp đồng của tôi</div>
            <div class="page-sub">Xem và xác nhận hợp đồng thực tập của bạn</div>
        </div>
    </div>

    <div class="content">

        <div class="info-banner">
            <i class="bi bi-info-circle"></i>
            <p>Khi phòng Nhân sự tải lên hợp đồng cho bạn, hợp đồng sẽ xuất hiện tại đây với trạng thái <strong>Chờ xác nhận</strong>.<br>
               Vui lòng đọc kỹ hợp đồng trước khi nhấn <strong>Xác nhận hợp đồng</strong> để hoàn tất thủ tục thực tập.</p>
        </div>

        <c:choose>
            <c:when test="${empty contracts}">
                <div class="empty-state">
                    <i class="bi bi-file-earmark-x"></i>
                    <p>Chưa có hợp đồng nào.<br>Phòng Nhân sự sẽ tải lên hợp đồng sau khi hồ sơ của bạn được phê duyệt.<br>Vui lòng kiểm tra lại sau!</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="c" items="${contracts}">
                    <div class="contract-card ${c.status == 'CONFIRMED' ? 'confirmed' : (c.status == 'CANCELLED' ? 'cancelled' : 'pending')}">
                        <div class="cc-header">
                            <div class="cc-icon ${c.status == 'CONFIRMED' ? 'ci-confirmed' : (c.status == 'CANCELLED' ? 'ci-cancelled' : 'ci-pending')}">
                                <c:choose>
                                    <c:when test="${c.status == 'CONFIRMED'}"><i class="bi bi-patch-check-fill"></i></c:when>
                                    <c:when test="${c.status == 'CANCELLED'}"><i class="bi bi-x-circle"></i></c:when>
                                    <c:otherwise><i class="bi bi-hourglass-split"></i></c:otherwise>
                                </c:choose>
                            </div>
                            <div class="cc-info">
                                <div class="cc-title">
                                    Hợp đồng Thực tập
                                    <c:if test="${not empty c.fileName}"> — ${c.fileName}</c:if>
                                </div>
                                <div class="cc-period">
                                    <c:if test="${not empty c.startDate}">
                                        <i class="bi bi-calendar3" style="font-size:.75rem"></i>
                                        ${c.startDate} → ${c.endDate}
                                    </c:if>
                                </div>
                            </div>
                            <div>
                                <c:choose>
                                    <c:when test="${c.status == 'CONFIRMED'}"><span class="badge badge-confirmed"><i class="bi bi-check-circle-fill" style="font-size:.6rem"></i>Đã xác nhận</span></c:when>
                                    <c:when test="${c.status == 'CANCELLED'}"><span class="badge badge-cancelled"><i class="bi bi-dash-circle-fill" style="font-size:.6rem"></i>Đã hủy</span></c:when>
                                    <c:otherwise><span class="badge badge-pending"><i class="bi bi-clock-fill" style="font-size:.6rem"></i>Chờ xác nhận</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="cc-body">
                            <c:if test="${not empty c.confirmedAt}">
                                <div class="cc-meta">
                                    <div class="label">Ngày xác nhận</div>
                                    <div class="value">${c.confirmedAt}</div>
                                </div>
                            </c:if>

                            <div style="margin-left:auto;display:flex;gap:10px;align-items:center">
                                <c:if test="${not empty c.filePath}">
                                    <a href="${pageContext.request.contextPath}${c.filePath}" class="btn-view" target="_blank">
                                        <i class="bi bi-eye"></i> Xem hợp đồng
                                    </a>
                                </c:if>
                                <c:if test="${c.status == 'PENDING'}">
                                    <form method="post" action="${pageContext.request.contextPath}/intern/contracts/confirm"
                                          onsubmit="return confirm('Bạn có chắc chắn muốn xác nhận hợp đồng này không? Hành động này không thể hoàn tác.')">
                                        <input type="hidden" name="id" value="${c.id}">
                                        <button type="submit" class="btn-confirm">
                                            <i class="bi bi-check-lg"></i> Xác nhận hợp đồng
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>
