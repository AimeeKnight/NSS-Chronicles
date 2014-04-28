User Stories for NSS Chronicles
==============================

As the nss president<br />
In order for people to research students at nss</br>
I want to create a personal profile for each student with their project url

  - User runs `nss add student <first name/last name/cohort/project url>`
  - The Student record is then added to the list of all students
  - After saving, the user is given a confirmation message

<hr />

As the nss president<br />
In order to keep a student profile current<br />
I want to be able to change their status to alumni

  - User runs `nss current student list` to see the list of all students without alumni status (if needed)
  - User runs `nss set alumni <first name/last name>`
  - After saving, the user is given a confirmation message

<hr />

As the nss president<br />
In order to see a list of all student names in alphebetical order<br />
I want to be able to search all students names alphebetically

  - User runs `nss student list`
  - A list of student names is returned in alphebetical order

<hr />

As the nss president<br />
In order to see the profile of an individual student<br />
I want to be able to look up a student by their first and last name

  - User runs `nss student search <first name/last name>`
  - The individually searched student record is returned

<hr />

As the nss president<br />
In order to show past students<br />
I want to be able to search students by alumni status

  - User runs `nss alumni student list` to see the list of all students with alumni status

<hr />

As the nss president<br />
In order to separate students by cohort and track cohort details<br />
I want to be able to create a new cohort

  - User runs `nss add cohort <name/technology/term>`
  - The cohort record is then added to the list of all cohorts
  - After saving, the user is given a confirmation message

<hr />

As the nss president<br />
In order to see all cohorts<br />
I want to be able to search for all chorts

  - User runs `nss cohort list` to see the list of all cohorts

<hr />

As the nss president<br />
In order to see an individual cohort<br />
I want to be able to look up a cohort by title

  - User runs `nss cohort search <title>`
  - The individually searched cohort record is returned

<hr />

As the nss president<br />
In order to accurately track all students<br />
I want to be able to delete a student who will not be graduating.

  - User runs `nss student list` to see the list of all students
  - User runs `nss student delete <first name/last name>`
  - After saving, the user is given a confirmation message

<hr />
