#!/bin/bash
#Travis Schilling
#12/2/16
#This is a menu system that executes basic commands based on user input.

#initialize varaibles
calYear='1'
calMonth='12'
menuNum='0'
viFile='1'
newDir='a'
grepResult='b'
emailUser='c'
fileNewness='Y'

menuList()
# display a list of options for the user
{
until [ "$menuNum" = "9" ]
do
	echo
	echo "Welcome to Travis' main menu"
	echo
	echo "1 -- Display users currently logged in"
	echo "2 -- Display a calendar for a specific month and year"
	echo "3 -- Display the current directory path"
	echo "4 -- Change directory"
	echo "5 -- Long listing of visible files in the current directory"
	echo "6 -- Display current time and date and calendar"
	echo "7 -- Start the vi editor"
	echo "8 -- Email a file to a user"
	echo "9 -- Quit"
	echo
	# prompt for input
	echo -n "Please select a number: "
	read menuNum
	case $menuNum in
	1)
		usersOnline
		;;
	2)
		userCalendar
		;;
	3)
		currentDirectory
		;;
	4)
		changeDirectory
		;;
	5)
		longList
		;;
	6)
		dateCal
		;;
	7)
		startVi
		;;
	8)
		emailer
		;;
	9)
		#exit program due to condition being fulfilled in loop
		;;
	*)
		echo
		#error message if 1-9 not entered
		echo ""$menuNum" is out of the range 1-9. Going back to menu."
		echo
		pressKey
	esac
done
}

pressKey()
# prompts user for input before going back to menu
{
echo
read -n 1 -s -p "Press any key to continue..."
clear
}

usersOnline()
# show users currently logged into the system
{
echo
who | more
pressKey
}

userCalendar()
# display user-specified month and year
{
	echo "Enter a year between 1 and 9999: "
	read calYear
	if [ $calYear -le 9999 -a $calYear -ge 1 ] ; then
		echo "Enter a month between 1 and 12: "
		read calMonth
		if [ $calMonth -le 12 -a $calMonth -ge 1 ] ; then
			cal "$calMonth" "$calYear"
			pressKey
		else
			echo "Out of range value. Going back to menu."
			pressKey
		fi
	else
		echo "Out of range value. Going back to menu."
		pressKey
	fi
}

currentDirectory()
# displays current directory
{
echo
pwd
pressKey
}

changeDirectory()
{
# changes current directory to desired different directory
echo "What directory do you want to go to?"
read -e newDir
if [ "$newDir" == " " ]
then
	cd ~/
else
	eval cd "$newDir"
	pwd
	pressKey
fi
}

longList()
# displays detailed view of files in current directory
{
echo
ls -l | more
pressKey
}

dateCal()
# displays current date, time, and calendar month
{
echo
date
echo
cal
pressKey
}

startVi()
#opens up vi to edit existing named file or create new named file
{
echo "Are you creating a new file? Type Y or N: "
read fileNewness
case $fileNewness in
y|Y)
	echo "Enter a new file name: "
	read viFile
	vi "$viFile"
	pressKey
	;;
	
n|N)
	echo "Enter an existing text file name to edit in vi: "
	read viFile
	if [[ $(file "$viFile" | grep "ASCII") ]];
	then
		vi "$viFile"
		pressKey
	else
		echo "Error: "$viFile" is not a text file."
		pressKey
	fi
	;;
*)
	echo "Input not Y or N. Heading back to menu."
	pressKey
esac
}

emailer()

{
echo "This program will allow you to send an email to a user."
echo "You can also send a file in the email."
echo "Enter a valid username to send the email to: "
# prompt for subject name
read emailUser
if grep "$emailUser" /etc/passwd
then
#prompt for subject of the email
	echo "Enter the subject of the email: "
	read emailMessage
	echo
#prompt for file name
	echo -n "Enter the name of the file to be attached: "
	read emailFile
	if [[ $(file "$emailFile" | grep "ASCII") ]];
	then
		mail -s "$emailMessage" "$emailUser"<"$emailFile"
		echo
		echo "Email sent successfully."
	else
		echo "That is not a valid file."
	fi
else echo "That is not a valid user in the system."
fi
}

menuList
