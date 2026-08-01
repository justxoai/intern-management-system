Đối với 3 yêu cầu trên trong tính năng **Quản lý hồ sơ thực tập sinh (Intern Profile Management)**, các file cần chỉnh sửa/phát triển được phân theo từng tầng trong kiến trúc MVC như sau:

---

### 1. Tầng Entity (Thực thể dữ liệu)
* [Intern.java](intern-management-system/intern-management/src/main/java/codegym/vn/internmanagement/entity/Intern.java)
  * **Nhiệm vụ:** Khai báo các thuộc tính chứa thông tin thực tập sinh (`studentCode`, `university`, `major`, `dateOfBirth`, `gender`, `address`, `phone`, `email`, `status`, `userId`, `fullName`).

---

### 2. Tầng DAO (Data Access Object - Tương tác Database)
* [InternDAO.java](intern-management-system/intern-management/src/main/java/codegym/vn/internmanagement/dao/InternDAO.java)
  * **Chức năng Thêm mới:** Hàm `insert(Intern intern)` — Thực thi câu lệnh `INSERT INTO interns...`
  * **Chức năng Chỉnh sửa:** 
    * Hàm `findById(Long id)` — Lấy thông tin thực tập sinh theo ID để đổ lên Form sửa.
    * Hàm `update(Intern intern)` — Thực thi câu lệnh `UPDATE interns SET... WHERE id = ?`
  * **Chức năng Tìm kiếm & Lọc:** Hàm `search(String keyword, String university, String major, String status)` — Tạo câu truy vấn SQL động sử dụng `PreparedStatement` kết hợp `JOIN users` để tìm theo mã sinh viên, họ tên, email, trường, ngành và trạng thái.

---

### 3. Tầng Model / Service (Nghiệp vụ & Validation)
* [InternModel.java](intern-management-system/intern-management/src/main/java/codegym/vn/internmanagement/model/InternModel.java)
  * **Chức năng Thêm mới & Sửa:** Hàm `createIntern(Intern intern)` và `updateIntern(Intern intern)` — Kiểm tra các điều kiện đầu vào (bắt buộc nhập mã sinh viên, trường, ngành, email format, trùng lặp,...).
  * **Chức năng Lọc:** Hàm `searchInterns(...)` — Xử lý các giá trị rỗng/khoảng trắng từ form và gọi xuống `InternDAO.search()`.

---

### 4. Tầng Controller / Servlet (Điều hướng Request)
* **Thêm mới (URL: `/hr/interns/create`):**
  * [InternCreateServlet.java](intern-management-system/intern-management/src/main/java/codegym/vn/internmanagement/controller/intern/InternCreateServlet.java)
    * `doGet`: Forward sang trang `create.jsp`.
    * `doPost`: Nhận tham số form, gọi `InternModel.createIntern()`, nếu thành công thì `sendRedirect` về `/hr/interns`.
* **Chỉnh sửa (URL: `/hr/interns/edit`):**
  * [InternEditServlet.java](intern-management-system/intern-management/src/main/java/codegym/vn/internmanagement/controller/intern/InternEditServlet.java)
    * `doGet`: Lấy `id` từ URL request parameter, gọi `InternModel.getInternById(id)` và gửi dữ liệu sang `edit.jsp`.
    * `doPost`: Lấy thông tin đã sửa từ form, gọi `InternModel.updateIntern()` và redirect về `/hr/interns`.
* **Danh sách & Tìm kiếm (URL: `/hr/interns`):**
  * [InternListServlet.java](intern-management-system/intern-management/src/main/java/codegym/vn/internmanagement/controller/intern/InternListServlet.java)
    * `doGet`: Đọc các query parameter (`keyword`, `university`, `major`, `status`), gọi `InternModel.searchInterns()`, đưa kết quả danh sách vào request attribute và forward tới `list.jsp`.

---

### 5. Tầng View (Giao diện JSP)
* **Giao diện Thêm mới:** [create.jsp](intern-management-system/intern-management/src/main/webapp/WEB-INF/views/intern/create.jsp)
  * Form nhập liệu tạo mới hồ sơ thực tập sinh với các field: mã sinh viên, trường, ngành, ngày sinh, giới tính, email, số điện thoại, địa chỉ.
* **Giao diện Chỉnh sửa:** [edit.jsp](intern-management-system/intern-management/src/main/webapp/WEB-INF/views/intern/edit.jsp)
  * Form hiển thị thông tin thực tập sinh hiện tại (có chứa hidden `id`), cho phép chỉnh sửa thông tin cá nhân và cập nhật trạng thái.
* **Giao diện Danh sách & Thanh tìm kiếm:** [list.jsp](intern-management-system/intern-management/src/main/webapp/WEB-INF/views/intern/list.jsp)
  * Chứa thanh công cụ tìm kiếm (các ô nhập Keyword, Trường, Ngành, Dropdown trạng thái).
  * Bảng hiển thị danh sách thực tập sinh và nút **Edit** trỏ đến URL `/hr/interns/edit?id=...`.