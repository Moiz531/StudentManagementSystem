#!/bin/bash

STUDENT_FILE="records.txt"
TEACHER_USERNAME="Moiz"
TEACHER_PASSWORD="123456789"

if [ ! -f "$STUDENT_FILE" ]; then
  touch "$STUDENT_FILE"
fi

while true
do
  echo "===== Student Management System ====="
  echo "1. Teacher Login"
  echo "2. Student Login"
  echo "3. Exit"
  echo "Enter your choice:"
  read choice

  if [ "$choice" = "1" ]; then
    echo "Enter Teacher Username:"
    read tuser
    echo "Enter Teacher Password:"
    read tpass

    if [ "$tuser" = "$TEACHER_USERNAME" ] && [ "$tpass" = "$TEACHER_PASSWORD" ]; then
      while true
      do
        echo "---- Teacher Menu ----"
        echo "1. Add Student"
        echo "2. View All Students"
        echo "3. Update Student"
        echo "4. Delete Student"
        echo "5. Back"
        read option

        if [ "$option" = "1" ]; then
          echo "Enter Roll Number:"
          read roll
          found=0
          while read line
          do
            r=$(echo "$line" | cut -d',' -f1)
            if [ "$r" = "$roll" ]; then
              found=1
            fi
          done < "$STUDENT_FILE"
          if [ "$found" = "1" ]; then
            echo "Student already exists."
          else
            echo "Enter Name:"
            read name
            echo "Enter Marks:"
            read marks
            echo "$roll,$name,$marks" >> "$STUDENT_FILE"
            echo "Student added."
          fi

        elif [ "$option" = "2" ]; then
          echo "Roll No | Name | Marks | Grade"
          while read line
          do
            r=$(echo "$line" | cut -d',' -f1)
            n=$(echo "$line" | cut -d',' -f2)
            m=$(echo "$line" | cut -d',' -f3)
            grade=$(./utils "$r" onlygrade 2>/dev/null | tail -1)
            echo "$r | $n | $m | $grade"
          done < "$STUDENT_FILE"

        elif [ "$option" = "3" ]; then
          echo "Enter Roll Number to update:"
          read roll
          found=0
          touch temp.txt
          while read line
          do
r=$(echo "$line" | cut -d',' -f1)
if [ "$r" = "$roll" ]; then
  echo "Enter new name:"
  read new_name
  # Clear the input buffer to prevent issues with reading next inputs
  read -t 1 -n 1000 discard

  echo "Enter new marks:"
  read new_marks
  # Clear the input buffer to prevent issues with reading next inputs
  read -t 1 -n 1000 discard

  echo "$r,$new_name,$new_marks" >> temp.txt
  found=1
else
echo "$line" >> temp.txt  
fi

          done < "$STUDENT_FILE"
          mv temp.txt "$STUDENT_FILE"
          if [ "$found" = "1" ]; then
            echo "Student updated."
          else
            echo "Student not found."
          fi

        elif [ "$option" = "4" ]; then
          echo "Enter Roll Number to delete:"
          read roll
          touch temp.txt
          while read line
          do
            r=$(echo "$line" | cut -d',' -f1)
            if [ "$r" != "$roll" ]; then
              echo "$line" >> temp.txt
            fi
          done < "$STUDENT_FILE"
          mv temp.txt "$STUDENT_FILE"
          echo "If student existed, deleted."

        elif [ "$option" = "5" ]; then
          break
        else
          echo "Invalid option"
        fi
      done
    else
      echo "Invalid credentials. Returning to main menu."
    fi

  elif [ "$choice" = "2" ]; then
    echo "Enter your Roll Number:"
    read roll
    found=0
    while read line
    do
      r=$(echo "$line" | cut -d',' -f1)
      if [ "$r" = "$roll" ]; then
        found=1
      fi
    done < "$STUDENT_FILE"

    if [ "$found" = "1" ]; then
      echo "1. View Grade"
      echo "2. View CGPA"
      echo "3. Back"
      read sub
      if [ "$sub" = "1" ]; then
        ./utils "$roll" grade
      elif [ "$sub" = "2" ]; then
        ./utils "$roll" cgpa
      fi
    else
      echo "Student not found."
    fi
  elif [ "$choice" = "3" ]; then
    echo "Exiting..."
    exit
  else
    echo "Invalid input."
  fi
done
