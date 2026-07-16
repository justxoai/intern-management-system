# Internship Management System

A simple Internship Management System built with **Java**, **Spring Boot**, and **Servlet** to help companies manage internship programs efficiently.

## Project Overview

This project digitizes the basic internship management workflow, allowing Human Resources (HR) to manage intern information, assign mentors, track internship progress, and perform evaluations.

The project was developed by **2 members** over approximately **1 month** as a practice project for learning Java Web technologies.

---

# Product Vision

Build a lightweight internship management system that simplifies intern management and improves collaboration between HR, mentors, and interns.

---

# Objectives

- Manage intern information digitally.
- Assign interns to mentors.
- Track internship tasks and progress.
- Evaluate internship performance.
- Generate simple management reports.

---

# Core Features

## Authentication

- Login
- Logout
- Role-based Authorization

Roles:

- Admin
- HR
- Mentor
- Intern

---

## Intern Management

- Add intern
- Edit intern
- Delete intern
- Search interns
- View intern details

---

## Mentor Management

- Create mentor
- Assign mentor to intern
- View assigned interns

---

## Internship Program

- Create internship program
- Assign interns to program
- View internship schedule

---

## Task Management

Mentor can

- Create task
- Update task
- Mark task completed

Intern can

- View assigned tasks
- Update progress

---

## Evaluation

Mentor can

- Evaluate intern
- Add comments

HR can

- View evaluation results

---

## Dashboard

- Total interns
- Total mentors
- Internship status
- Simple statistics

---

# Technologies

Backend

- Java 17
- Spring Boot
- Spring MVC
- Spring Data JPA
- Spring Security
- Java Servlet

Database

- MySQL

Frontend

- Thymeleaf
- HTML
- CSS
- Bootstrap
- JavaScript

Build Tool

- Maven

Version Control

- Git
- GitHub

---

# Project Structure

```
src
 ├── controller
 ├── service
 ├── repository
 ├── entity
 ├── dto
 ├── config
 ├── security
 ├── exception
 └── util
```

---

# Development Team

| Member | Responsibility |
|---------|----------------|
| Member 1 | Authentication, Intern Management |
| Member 2 | Mentor, Task, Evaluation |

---

# Future Improvements

- Email notification
- Attendance management
- Report export (Excel/PDF)
- Mobile application
- HRM integration

---

# Getting Started

## Requirements

- JDK 17+
- Maven
- MySQL

## Clone

```bash
git clone https://github.com/username/internship-management-system.git
```

## Configure Database

Update

```
application.properties
```

```properties
spring.datasource.url=
spring.datasource.username=
spring.datasource.password=
```

## Run

```bash
mvn spring-boot:run
```

Open

```
http://localhost:8080
```

---

# License

This project is developed for educational purposes.