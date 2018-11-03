#!/usr/bin/env bash

query=$1

echo -n $query

searchGit() {
	goto "https://gitlab-app.eng.qops.net/search?utf8=✓&search=$1"
}

goto() {
	echo "Going to $1"
	open $1
	exit
}

if [ "$query" == 'eedj' ] || [ "$query" == 'ee-dashboard-java' ] || [ "$query" == 'dashboard' ]
then
	goto 'https://gitlab-app.eng.qops.net/employee-insights/ee-dashboard-java'
fi

if [ "$query" == 'eiws' ] || [ "$query" == 'eiwidgetservice' ]
then
	goto 'https://gitlab-app.eng.qops.net/employee-insights-widgets/eiwidgetservice'
fi

searchGit $query
