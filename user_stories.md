User Stories for NSS Chronicles
==============================

### Students Model

As the NSS president<br />
In order for people to research students at NSS</br>
I want to create a personal profile for each student with their github url, and have a default alumni coloumn set to false

  - User runs `nss add student <first name/last name/cohort id/github url>`
  - The Student record is then added to the list of all students
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
In order to see a list of all student names in alphebetical order by first name<br />
I want to be able to search all students names sorted alphebetically by first name

  - User runs `nss student list`
  - A list of students with their first and last name is returned in alphebetical order by first name
  - If the query does not retuan any results, the user will be given a default empty result message

<hr />

As the NSS president<br />
In order to see the profile of an individual student<br />
I want to be able to look up a student by a student id

  - User runs `nss student search <student id>`
  - The individually searched student record is returned
  - If the query does not retuan any results, the user will be given a default empty result message

<hr />

As the NSS president<br />
In order to show past students<br />
I want to be able to search students by alumni status

  - User runs `nss alumni student list` to see the list of all alumni with their first and last name

<hr />

### Cohorts Model

As the NSS president<br />
In order to separate students by cohort and track cohort details<br />
I want to be able to create a new cohort

  - User runs `nss add cohort <title/primary languages/term>`
  - The cohort record is then added to the list of all cohorts
  - After saving, the user is given a confirmation message

<hr />

As the NSS president<br />
In order to see all cohorts<br />
I want to be able to search for all chorts

  - User runs `nss cohort list` to see the list of all cohorts

<hr />

As the NSS president<br />
In order to see an individual cohort<br />
I want to be able to look up a cohort by title

  - User runs `nss cohort search <title>`
  - The individually searched cohort record is returned
  - If the query does not retuan any results, the user will be given a default empty result message

<hr />

As the NSS president<br />
In order to accurately track all students<br />
I want to be able to delete a student who will not be graduating.

  - User runs `nss current student list` to see the list of all students without alumni status (if needed)
  - User runs `nss student delete <student id>`
  - After saving, the user is given a confirmation message

<hr />
