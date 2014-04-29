User Stories for NSS Chronicles
==============================

### Cohort Model

As the NSS president<br />
In order to separate students by cohort and track cohort details<br />
I want to be able to create a new cohort

  - User runs `nss add cohort <title/language 1/language 2/term>`
  - The cohort record is then added to the list of all cohorts
  - After saving, the user is given a confirmation message

<hr />

As the NSS president<br />
In order to see all cohorts<br />
I want to be able to search for all cohorts

  - User runs `nss cohort list`
  - The list of all cohorts is returned

<hr />

As the NSS president<br />
In order to see an individual cohort<br />
I want to be able to look up a cohort by title

  - User runs `nss cohort search <title>`
  - The individually searched cohort record is returned
  - If the query does not return any results, the user will be given a default empty result message

### Student Model

As the NSS president<br />
In order for people to research students at NSS</br>
I want to create a personal profile for each student with their github url, and have a default alumni column set to false

  - User runs `nss add student <first name/last name/cohort id>`
  - The student record is then added to the list of all students
  - After saving, the user is given a confirmation message

<hr />

As the NSS president<br />
In order to keep a student profile current<br />
I want to be able to change a student status to alumni

  - User runs `nss current student list` to see the list of all students without alumni status (if needed)
  - User runs `nss set alumni <student id>`
  - After saving, the user is given a confirmation message

<hr />

As the NSS president<br />
In order to see a list of first and last names for all students sorted by first name, in alphabetical order<br />
I want to be able to search all students and have their names returned alphabetically by first name

  - User runs `nss student list`
  - A list of students with their first and last name is returned in alphabetical order by first name
  - If the query does not return any results, the user will be given a default empty result message

<hr />

As the NSS president<br />
In order to see the profile of an individual student<br />
I want to be able to look up a student by their student id

  - User runs `nss student search <student id>`
  - The individual student record is returned
  - If the query does not return any results, the user will be given a default empty result message

<hr />

As the NSS president<br />
In order to show past students<br />
I want to be able to search students by alumni status

  - User runs `nss alumni student list`
  - The list of all alumni with their first and last name is returned

<hr />

As the NSS president<br />
In order to see an all students from a single cohort <br />
I want to be able to look up a cohort and see all the students that were members

  - User runs `nss student search <cohort id>`
  - The individually searched cohort record is returned
  - If the query does not return any results, the user will be given a default empty result message

<hr />

As the NSS president<br />
In order to accurately track all students<br />
I want to be able to delete a student who will not be graduating.

  - User runs `nss current student list` to see the list of all students without alumni status (if needed)
  - User runs `nss student delete <student id>`
  - After saving, the user is given a confirmation message

### Project Model

As the NSS president<br />
In order for people to research student projects at NSS</br>
I want to create a record for each student project with a hosted url and GitHub url

  - User runs `nss add project <title/primary language/student id/github url/hosted url>`
  - The project record is then added to the list of all projects
  - After saving, the user is given a confirmation message

<hr />

As the NSS president<br />
In order to see a list of all projects<br />
I want to be able to search for all projects

  - User runs `nss project list`
  - The list of all projects is returned
  - If the query does not return any results, the user will be given a default empty result message

<hr />

As the NSS president<br />
In order to see the record for an individual student project<br />
I want to be able to look up an individual project by a student id

  - User runs `nss project search <student id>`
  - The individually searched project record with corresponding student information is returned
  - If the query does not return any results, the user will be given a default empty result message

