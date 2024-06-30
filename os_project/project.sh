#!/bin/bash

library_database="lib.csv"
library_database_temp=/tmp/ldb.$$
# $$ for the unique process id of the script
touch $library_database_temp

chmod u+rwx,g+r,o+r "$library_database_temp"
# rwx for owner, r for group and others

function manage_library() {
    clear

    echo -e "\tمكتبة المشتعلة\n"
    echo -e '\tBohni-Sikha Library - বহ্নিশিখা পাঠাগার\n'
    sleep 2.5

    done=""
    while [ "$done" != "ok" ];
    do

      menu

      case "$menu_choice" in
        1) view_books;;
        2) find_books;;
        3) add_books;;
        4) edit_books;;
        5) remove_books;;
        6) done=ok;;
        *) echo "press/type the correct menu choice (1-6)";;
        
      esac
    done

    rm -f $library_database_temp
    echo "Finished"
    exit 0
}



filter_and_update(){
  grep -v "$book_name" $library_database > $library_database_temp
  # -v = invert match
  mv $library_database_temp $library_database

  }

insert_record(){
  echo $* >> $library_database
  return
}

get_return(){
  echo -e '\tPress return\n'
  read x
  return 0
}

confirm(){
echo -e '\tAre you sure?\n'
while true
do
  read x
  case "$x" in
      y|yes|YES)
        return 0;;
      n|no|NO)
          echo -e '\ncancelled successfully\n'
          return 1;;
      *) echo 'enter yes/no';;
  esac
done
}

menu_choice=""
menu(){
  clear

  echo 'Bohni-Sikha Library\n'

  echo -e 'Choose one of the Options:-'
  echo "__________________________"
  echo -e '\n'
  echo -e "\t 1. View books"
  echo -e "\t 2. Find Books"
  echo -e "\t 3. Add new Books record"
  echo -e "\t 4. Edit Books"
  echo -e "\t 5. Remove Books"
  echo -e "\t 6. Quit\n"
  echo -e 'Please enter the choice then press return\n'

  read menu_choice

  return
}

view_books(){
echo -e "List of books are :-\n"

cat $library_database
get_return
return
}


add_books(){

  echo 'Enter unique Book id:-'
  read number

  echo 'Enter Book title:-'
  read title

  echo 'Enter Author Name:-'
  read author

  echo 'Enter Book genre:-'
  read genre

  echo 'Is the book issued or available:-'
  read availability

  echo -e 'Add new entry\n'
  echo -e "$number\t$title\t$author\t$genre\t$availability\n"

  if confirm; then
    insert_record $number,$title,$author,$genre,$availability
  fi

  return
}

find_books(){
  echo "Enter book title to find:"
  read find_book

  grep -wi "$find_book" $library_database > $library_database_temp
  #! -wi = whole words and case insensitive 

  position_of_line=`cat $library_database_temp|wc -l`
  #! wc -l = count lines

  case `echo $position_of_line` in
  0)    echo "Sorry, nothing found"
        get_return
        return 0
        ;;
  *)    echo "Found the following :"
        cat $library_database_temp
        get_return
        return 0
  esac
return
}

remove_books() {

  position_of_line=`cat $library_database|wc -l`
  #! wc -l = count lines

  case `echo $position_of_line` in
   0)    echo "nothing found\n"
         get_return
         return 0
         ;;
   *)    echo -e "Here the database found:\n"
         cat $library_database ;;
  esac

echo -e "Type the title of the book you want to delete"
 read book_name

  if [ "$book_name" = "" ]; then
      return 0
  fi

  filter_and_update

  echo "The book has been removed successfully"
  get_return
  return
}


edit_books(){

echo "Book-list:"
cat $library_database

echo -e "Type the title of the book you want to edit"
read book_name
  if [ "$book_name" = "" ]; then
     return 0
  fi

  filter_and_update

  echo "Enter new record"

  add_books
}

  manage_library
