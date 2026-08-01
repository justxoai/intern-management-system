CREATE DATABASE IF NOT EXISTS internship_management
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE internship_management;

CREATE TABLE IF NOT EXISTS users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    role VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS interns (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT,
    student_code VARCHAR(50) NOT NULL UNIQUE,
    university VARCHAR(150) NOT NULL,
    major VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    gender VARCHAR(20),
    address VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(100),
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_intern_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE SET NULL
);

INSERT INTO users (username, password, full_name, email, phone, role, status)
VALUES ('admin', 'admin123', 'System Admin', 'admin@example.com', '0123456789', 'ADMIN', 'ACTIVE')
ON DUPLICATE KEY UPDATE username = username;

INSERT INTO users (username, password, full_name, email, phone, role, status)
VALUES ('hr', 'hr123', 'HR User', 'hr@example.com', '0123456788', 'HR', 'ACTIVE')
ON DUPLICATE KEY UPDATE username = username;

INSERT INTO users (username, password, full_name, email, phone, role, status)
VALUES ('mentor1', 'mentor123', 'Mentor One', 'mentor1@example.com', '0123456790', 'MENTOR', 'ACTIVE')
ON DUPLICATE KEY UPDATE username = username;

INSERT INTO users (username, password, full_name, email, phone, role, status)
VALUES ('mentor2', 'mentor123', 'Mentor Two', 'mentor2@example.com', '0123456791', 'MENTOR', 'ACTIVE')
ON DUPLICATE KEY UPDATE username = username;

INSERT INTO users (username, password, full_name, email, phone, role, status)
VALUES ('intern1', 'intern123', 'Intern One', 'intern1@example.com', '0123456792', 'INTERN', 'ACTIVE')
ON DUPLICATE KEY UPDATE username = username;

INSERT INTO interns (user_id, student_code, university, major, date_of_birth, gender, address, phone, email, status)
SELECT id, 'STU001', 'HUST', 'Computer Science', '2002-05-10', 'MALE', 'Hanoi', '0123456793', 'intern1@example.com', 'PENDING'
FROM users WHERE username = 'intern1'
ON DUPLICATE KEY UPDATE student_code = student_code;
