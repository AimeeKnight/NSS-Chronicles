User Stories for NSS Chronicles
==============================

As the nss president<br />
In order for people to research students at NSS</br>
I want to create a personal profile for each student with their project urls

  - User runs `nss add student <first name/last name/cohort/project url 1/project url 2>`
  - The Student's record is then added to the list of all students
  - After saving, the user is given a confirmation message

<hr />

As the nss president<br />
In order to see a list of all student names in alphebetical order<br />
I want to be able to search all students names alphebetically

  - User runs `nss student list`
  - A list of student names is returned in alphebetical order

<hr />

As the nss president<br />
In order to see the profile of an individual students<br />
I want to be able to look up a student by their first and last name

  - User runs `nss student search <first name/last name>`
  - The individually searched student record is returned

<hr />

As the nss president<br />
In order to keep a student profile current<br />
I want to be able to change their status to alumni

  - User runs `nss student list` to see the list of all students without alumni status
  - User runs `nss set alumni <first name/last name>`
  - After saving, the user is given a confirmation message

<hr />

As the nss president<br />
In order to separate students by cohort and track cohort details<br />
I want to be able to create a new cohort

  - User runs `nss add cohort <name/technology/term>`
  - The cohort record is then added to the list of all cohorts
  - After saving, the user is given a confirmation message

<hr />

As the nss president<br />
In order to accuratly track all students<br />
I want to be able to delete a student who will not be graduating.

  - User runs `nss student list` to see the list of all students
  - User runs `nss student delete <first name/last name>`
  - After saving, the user is given a confirmation message

<hr />
