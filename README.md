## NSS Chronicles

NSS Chronicles is a cli-application that is intended to provide an interface to a database of current and former NSS students.

## Technologies/Dependencies
Ruby
SQLite

## Setup

Clone this repo

`> git clone https://github.com/AimeeKnight/NSS-Chronicles.git`

## Usage

Planned usage is as follows:

To add a new cohort:
`> nss add cohort -n "Name", -t "Technology1, Technology2", -d "Term Period"`

To view a list of all cohorts
`> nss cohort list`

To add a new student
`> nss add student -f` "First Name", -l "Last Name", -a "True", -c "Cohort Id", -p "Final Project URL"

To view a list of all students
`> nss student list`

To delete a student
`nss delete "First Name, Last Name"`

## License

NSS Chronicles is released under the [MIT License](http://www.opensource.org/licenses/MIT).
