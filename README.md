======
BASHRC
======

List of functions
-----------------
add-path-composer {} - Adds the composer bin to the $PATH variable if one is found at CWD/vendor/bin
push-msg {message} - Pushes a message to the pushover api. Environment variable need to be set (see environment.sh)
List of Aliases
---------------

Directory Listing
-----------------
| lf | ls -Art | tail -n 1 | Fetches the most recently edited file

PS1 Key
-------
| b: master  | 
| 00:00      | user | @        | Machine      | ~/Folder
|------------|------|----------|--------------|
| Git Branch |      |          |              |
| Time       | User | @ symbol | Machine Name | Current working directory
