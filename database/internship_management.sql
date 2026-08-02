CREATE DATABASE IF NOT EXISTS internship_management
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE internship_management;

-- =====================================================
-- 1. USERS
-- =====================================================
CREATE TABLE IF NOT EXISTS users (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    username    VARCHAR(100)  NOT NULL UNIQUE,
    password    VARCHAR(255)  NOT NULL,
    full_name   VARCHAR(150)  NOT NULL,
    email       VARCHAR(150)  NOT NULL UNIQUE,
    phone       VARCHAR(20),
    role        ENUM('ADMIN','HR','MENTOR','INTERN') NOT NULL,
    status      ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =====================================================
-- 2. INTERNS
-- =====================================================
CREATE TABLE IF NOT EXISTS interns (
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id       BIGINT UNIQUE,
    student_code  VARCHAR(50),
    university    VARCHAR(255) NOT NULL,
    major         VARCHAR(150) NOT NULL,
    date_of_birth DATE,
    gender        ENUM('MALE','FEMALE','OTHER'),
    address       VARCHAR(255),
    phone         VARCHAR(20),
    email         VARCHAR(150),
    status        ENUM('PENDING','APPROVED','REJECTED','INTERNING','COMPLETED') DEFAULT 'PENDING',
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_intern_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- =====================================================
-- 3. MENTORS
-- =====================================================
CREATE TABLE IF NOT EXISTS mentors (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id     BIGINT UNIQUE NOT NULL,
    department  VARCHAR(150),
    position    VARCHAR(150),
    max_interns INT DEFAULT 5,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_mentor_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- =====================================================
-- 4. INTERNSHIP APPLICATIONS
-- =====================================================
CREATE TABLE IF NOT EXISTS internship_applications (
    id               BIGINT AUTO_INCREMENT PRIMARY KEY,
    intern_id        BIGINT NOT NULL,
    application_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status           ENUM('PENDING','APPROVED','REJECTED') DEFAULT 'PENDING',
    reviewed_by      BIGINT,
    reviewed_at      TIMESTAMP NULL,
    rejection_reason TEXT,
    CONSTRAINT fk_application_intern    FOREIGN KEY (intern_id)    REFERENCES interns(id) ON DELETE CASCADE,
    CONSTRAINT fk_application_reviewer  FOREIGN KEY (reviewed_by)  REFERENCES users(id)   ON DELETE SET NULL
);

-- =====================================================
-- 5. DOCUMENTS
-- =====================================================
CREATE TABLE IF NOT EXISTS documents (
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    intern_id     BIGINT NOT NULL,
    document_type ENUM('CV','INTERNSHIP_APPLICATION','CONTRACT') NOT NULL,
    file_name     VARCHAR(255) NOT NULL,
    file_path     VARCHAR(500) NOT NULL,
    status        ENUM('PENDING','APPROVED','REJECTED') DEFAULT 'PENDING',
    reviewed_by   BIGINT,
    reviewed_at   TIMESTAMP NULL,
    uploaded_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_document_intern    FOREIGN KEY (intern_id)   REFERENCES interns(id) ON DELETE CASCADE,
    CONSTRAINT fk_document_reviewer  FOREIGN KEY (reviewed_by) REFERENCES users(id)   ON DELETE SET NULL
);

-- =====================================================
-- 6. CONTRACTS
-- =====================================================
CREATE TABLE IF NOT EXISTS contracts (
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    intern_id    BIGINT NOT NULL,
    document_id  BIGINT,
    start_date   DATE NOT NULL,
    end_date     DATE NOT NULL,
    status       ENUM('PENDING','CONFIRMED','CANCELLED') DEFAULT 'PENDING',
    confirmed_at TIMESTAMP NULL,
    CONSTRAINT fk_contract_intern    FOREIGN KEY (intern_id)   REFERENCES interns(id)    ON DELETE CASCADE,
    CONSTRAINT fk_contract_document  FOREIGN KEY (document_id) REFERENCES documents(id)  ON DELETE SET NULL
);

-- =====================================================
-- 7. MENTOR ASSIGNMENTS
-- =====================================================
CREATE TABLE IF NOT EXISTS mentor_assignments (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    mentor_id   BIGINT NOT NULL,
    intern_id   BIGINT NOT NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status      ENUM('ACTIVE','ENDED') DEFAULT 'ACTIVE',
    UNIQUE (mentor_id, intern_id),
    CONSTRAINT fk_assignment_mentor FOREIGN KEY (mentor_id) REFERENCES mentors(id) ON DELETE CASCADE,
    CONSTRAINT fk_assignment_intern FOREIGN KEY (intern_id) REFERENCES interns(id) ON DELETE CASCADE
);

-- =====================================================
-- 8. TASKS
-- tasks.mentor_id -> mentors.id (NOT users.id)
-- =====================================================
CREATE TABLE IF NOT EXISTS tasks (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    mentor_id   BIGINT NOT NULL,
    intern_id   BIGINT NOT NULL,
    title       VARCHAR(255) NOT NULL,
    description TEXT,
    start_date  DATE,
    due_date    DATE,
    status      ENUM('TODO','IN_PROGRESS','COMPLETED') DEFAULT 'TODO',
    progress    INT DEFAULT 0,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_task_mentor FOREIGN KEY (mentor_id) REFERENCES mentors(id) ON DELETE CASCADE,
    CONSTRAINT fk_task_intern FOREIGN KEY (intern_id) REFERENCES interns(id) ON DELETE CASCADE
);

-- =====================================================
-- 9. WEEKLY REPORTS
-- =====================================================
CREATE TABLE IF NOT EXISTS weekly_reports (
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    intern_id    BIGINT NOT NULL,
    mentor_id    BIGINT NOT NULL,
    week_number  INT NOT NULL,
    title        VARCHAR(255) NOT NULL,
    content      TEXT NOT NULL,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    feedback     TEXT,
    reviewed_at  TIMESTAMP NULL,
    status       ENUM('SUBMITTED','REVIEWED') DEFAULT 'SUBMITTED',
    CONSTRAINT fk_report_intern  FOREIGN KEY (intern_id) REFERENCES interns(id) ON DELETE CASCADE,
    CONSTRAINT fk_report_mentor  FOREIGN KEY (mentor_id) REFERENCES mentors(id) ON DELETE CASCADE
);

-- =====================================================
-- 10. EVALUATIONS
-- =====================================================
CREATE TABLE IF NOT EXISTS evaluations (
    id                   BIGINT AUTO_INCREMENT PRIMARY KEY,
    intern_id            BIGINT NOT NULL,
    mentor_id            BIGINT NOT NULL,
    technical_score      DECIMAL(5,2),
    attitude_score       DECIMAL(5,2),
    communication_score  DECIMAL(5,2),
    overall_score        DECIMAL(5,2),
    comments             TEXT,
    evaluated_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_evaluation_intern  FOREIGN KEY (intern_id) REFERENCES interns(id) ON DELETE CASCADE,
    CONSTRAINT fk_evaluation_mentor  FOREIGN KEY (mentor_id) REFERENCES mentors(id) ON DELETE CASCADE
);

-- =====================================================
-- SEED DATA
-- =====================================================
INSERT INTO users (username, password, full_name, email, phone, role)
VALUES
    ('admin',    '123456', 'System Administrator', 'admin@gmail.com',   '0900000001', 'ADMIN'),
    ('hr01',     '123456', 'Nguyen Van HR',         'hr@gmail.com',      '0900000002', 'HR'),
    ('mentor01', '123456', 'Tran Van Mentor',       'mentor@gmail.com',  '0900000003', 'MENTOR'),
    ('intern01', '123456', 'Le Van Intern',          'intern@gmail.com',  '0900000004', 'INTERN'),
    ('intern02', '123456', 'Pham Thi Intern',        'intern2@gmail.com', '0900000005', 'INTERN')
ON DUPLICATE KEY UPDATE
    password=VALUES(password), full_name=VALUES(full_name), phone=VALUES(phone), role=VALUES(role);

INSERT INTO interns (user_id, student_code, university, major, date_of_birth, gender, address, phone, email, status)
VALUES
    (4, 'SV001', 'Hanoi University of Science and Technology', 'Computer Science',    '2003-05-10', 'MALE',   'Hanoi', '0900000004', 'intern@gmail.com',  'APPROVED'),
    (5, 'SV002', 'National Economics University',              'Information Technology','2003-08-20', 'FEMALE', 'Hanoi', '0900000005', 'intern2@gmail.com', 'PENDING')
ON DUPLICATE KEY UPDATE student_code=VALUES(student_code);

INSERT INTO mentors (user_id, department, position, max_interns)
VALUES (3, 'Technology', 'Software Engineer', 5)
ON DUPLICATE KEY UPDATE department=VALUES(department);

INSERT INTO internship_applications (intern_id, status, reviewed_by, reviewed_at)
VALUES
    (1, 'APPROVED', 2, CURRENT_TIMESTAMP),
    (2, 'PENDING',  NULL, NULL)
ON DUPLICATE KEY UPDATE status=VALUES(status);

INSERT INTO mentor_assignments (mentor_id, intern_id)
VALUES (1, 1)
ON DUPLICATE KEY UPDATE status='ACTIVE';

INSERT INTO tasks (mentor_id, intern_id, title, description, start_date, due_date, status, progress)
VALUES
    (1, 1, 'Learn Java Servlet',   'Study Servlet lifecycle and MVC architecture.',       '2026-07-01', '2026-07-07', 'COMPLETED',   100),
    (1, 1, 'Build Login Module',   'Implement login and session management.',              '2026-07-08', '2026-07-15', 'IN_PROGRESS',  60)
ON DUPLICATE KEY UPDATE title=VALUES(title);
