package codegym.vn.internmanagement.entity;

import java.time.LocalDate;

public class Task {

    private Long id;

    private Long mentorId;

    private Long internId;

    private String title;

    private String description;

    private LocalDate startDate;

    private LocalDate dueDate;

    private String status;

    private Integer progress;

    public Task() {
    }

    // Getters and Setters
}
