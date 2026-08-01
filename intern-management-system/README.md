# Internship Management System

A web-based **Internship Management System** developed using **Java Servlet**, **JSP**, and **MySQL**. The system helps Human Resources (HR) manage internship applications, intern profiles, mentors, assigned tasks, and internship evaluations through a centralized platform.

This project was developed by **2 members** over approximately **1 month** as a Java Web practice project.

---

# Product Vision

Build a lightweight internship management system that digitizes the internship process, improves collaboration between HR, mentors, and interns, and simplifies internship management through a centralized web application.

---

# Objectives

* Digitize intern profile management.
* Simplify internship recruitment and approval.
* Assign mentors to interns.
* Track internship tasks and weekly reports.
* Evaluate intern performance.
* Manage user accounts and permissions.

---

# Core Features

## Authentication & Authorization

The system supports role-based authentication for different users.

### Roles

* Admin
* HR
* Mentor
* Intern

### Features

* Login
* Logout
* Session Management
* Role-based Authorization

---

## Intern Profile Management

HR can

* Add new intern profiles
* Update intern information
* Search interns
* Filter interns by university or major

Intern can

* Upload CV
* Upload internship documents

HR can

* Review and approve uploaded documents

---

## Recruitment Management

Intern can

* Register an account
* Submit internship applications
* Confirm internship contracts

HR can

* Review applications
* Approve or reject applications
* Upload internship contracts

System can

* Send email notifications (optional)

---

## Mentor Management

HR can

* Add mentors
* Assign mentors to interns
* View mentor assignments

---

## Task Management

Mentor can

* Create internship tasks
* Monitor task progress
* Review weekly reports

Intern can

* View assigned tasks
* Update task progress
* Submit weekly reports

---

## Internship Evaluation

Mentor can

* Evaluate intern performance
* Leave comments and feedback

HR can

* View final evaluation results

---

## User Management

Admin can

* Create user accounts
* Assign user roles
* Manage system permissions

---

# Technology Stack

## Backend

* Java 25 (LTS)
* Java Servlet
* JSP (JavaServer Pages)
* JDBC

## Database

* MySQL

## Web Server

* Apache Tomcat 10

## Frontend

* HTML5
* CSS3
* Bootstrap 5
* JavaScript

## Build Tool

* Maven

## Version Control

* Git
* GitHub

---

# Project Structure

```
InternshipManagementSystem
│
├── src
│   ├── controller
│   ├── dao
│   ├── model
│   ├── service
│   ├── filter
│   ├── listener
│   ├── util
│   └── config
│
├── webapp
│   ├── assets
│   │   ├── css
│   │   ├── js
│   │   └── images
│   ├── views
│   └── WEB-INF
│
├── database
│   └── internship_management.sql
│
├── pom.xml
└── README.md
```

---

# Development Team

| Member   | Responsibility                                                  |
| -------- | --------------------------------------------------------------- |
| Member 1 | Authentication, Recruitment, Intern Profile Management          |
| Member 2 | Mentor Management, Task Management, Evaluation, User Management |

---

# Future Improvements

* Email notification service
* Attendance management
* Dashboard and analytics
* Export reports (Excel/PDF)
* Mobile application
* HRM system integration

---

# Getting Started

## Requirements

Before running the project, make sure the following software is installed:

* Java JDK 25 (LTS)
* Apache Tomcat 10+
* Apache Maven
* MySQL 8.0+

---

## Database connection

1. Run `database/internship_management.sql` to create the schema.
2. In `database/create_app_user.sql`, replace the password placeholder and run it with an administrator account.
3. Configure the application without committing credentials:

```bash
export DB_USERNAME=intern_app
export DB_PASSWORD='your-strong-password'
export DB_URL='jdbc:mysql://localhost:3306/internship_management?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true'
```

HR intern management is available at `/hr/interns`. Intern self-service starts at `/intern`.

---

## Clone Repository

```bash
git clone https://github.com/your-username/internship-management-system.git

cd internship-management-system
```

---

## Configure Database

1. Create a new MySQL database.

```sql
CREATE DATABASE internship_management;
```

2. Import the SQL script located in:

```
database/internship_management.sql
```

3. Update your database configuration in the project.

Example:

```java
private static final String URL = "jdbc:mysql://localhost:3306/internship_management";
private static final String USERNAME = "root";
private static final String PASSWORD = "your_password";
```

---

## Build Project

```bash
mvn clean package
```

---

## Deploy

Deploy the generated **WAR** file to Apache Tomcat.

Example directory:

```
apache-tomcat/webapps/
```

Start Tomcat and open:

```
http://localhost:8080/InternshipManagementSystem
```

---

# Future Development

Possible enhancements include:

* QR Code attendance
* Email notification automation
* Internship statistics dashboard
* Online document approval
* Integration with HR Management Systems (HRM)

---

# License

This project is developed for educational purposes.
