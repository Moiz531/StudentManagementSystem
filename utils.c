#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char* get_grade(int marks) {
    if (marks >= 92) return "A+";
    else if (marks >= 88) return "A";
    else if (marks >= 84) return "A-";
    else if (marks >= 79) return "B+";
    else if (marks >= 74) return "B";
    else if (marks >= 69) return "B-";
    else if (marks >= 65) return "C+";
    else if (marks >= 60) return "C";
    else if (marks >= 55) return "C-";
    else if (marks >= 50) return "D+";
    else if (marks >= 45) return "D";
    else return "F";
}

float get_cgpa_from_grade(const char* grade) {
    if (strcmp(grade, "A+") == 0 || strcmp(grade, "A") == 0) return 4.0;
    else if (strcmp(grade, "A-") == 0) return 3.67;
    else if (strcmp(grade, "B+") == 0) return 3.33;
    else if (strcmp(grade, "B") == 0) return 3.0;
    else if (strcmp(grade, "B-") == 0) return 2.67;
    else if (strcmp(grade, "C+") == 0) return 2.33;
    else if (strcmp(grade, "C") == 0) return 2.0;
    else if (strcmp(grade, "C-") == 0) return 1.67;
    else if (strcmp(grade, "D+") == 0) return 1.33;
    else if (strcmp(grade, "D") == 0) return 1.0;
    else return 0.0;
}

int main(int argc, char* argv[]) {
    if (argc != 3) {
        printf("Usage: ./utils <roll_no> <grade|cgpa|onlygrade>\n");
        return 1;
    }

    char *roll = argv[1];
    char *mode = argv[2];
    FILE *file = fopen("records.txt", "r");
    if (!file) {
        printf("File not found.\n");
        return 1;
    }

    char line[100];
    int found = 0;
    while (fgets(line, sizeof(line), file)) {
        char r[20], name[50];
        int marks;
        sscanf(line, "%[^,],%[^,],%d", r, name, &marks);

        if (strcmp(r, roll) == 0) {
            found = 1;
            char *grade = get_grade(marks);
            float cgpa = get_cgpa_from_grade(grade);

            if (strcmp(mode, "grade") == 0) {
                printf("Name: %s\nMarks: %d\nGrade: %s\n", name, marks, grade);
            } else if (strcmp(mode, "cgpa") == 0) {
                printf("Name: %s\nMarks: %d\nGrade: %s\nCGPA: %.2f\n", name, marks, grade, cgpa);
            } else if (strcmp(mode, "onlygrade") == 0) {
                printf("%s\n", grade);
            } else {
                printf("Invalid option. Use 'grade' or 'cgpa'\n");
            }
            break;
        }
    }

    fclose(file);

    if (!found) {
        printf("Student not found.\n");
    }

    return 0;
}
