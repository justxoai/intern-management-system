# Internship Management System

A web-based internship management system built with Java Servlet, JSP, and MySQL. It supports HR, mentors, interns, and administrators with role-based workflows for managing internships end to end.

## Login credentials

- Username: hr01
- Password: 123456

## Features

- HR can manage intern profiles, recruitment applications, and mentor assignments.
- Mentors can manage tasks and evaluate interns.
- Interns can submit applications, upload documents, and track tasks.
- Admin can create user accounts and assign roles.

## Tech Stack

- Java 17
- Jakarta Servlet
- JSP / JSTL
- MySQL
- Maven
- Jetty for local development

## Project Structure

- src/main/java: Java controllers, models, DAO, entities, filters
- src/main/webapp: JSP pages and web resources
- database: SQL schema and seed data

## Getting Started

1. Create the MySQL database using the SQL scripts in the database folder.
2. Run the application locally with Maven:

```bash
cd intern-management-system/intern-management
./mvnw -q -DskipTests jetty:run
```

3. Open http://localhost:8081 in your browser.

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
>>>>>>> origin/main
