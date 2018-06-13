# Bonkstudios Dev Test
### Quick Install
    1. Clone repository
    2. rename Vagrant.json.example Vagrant.json
    3. edit Vagrant.json change: edit synced_folder_path "/home/app/devtest" to the path to where you cloned the repository. 
        You can also change the private network ip.
    4. vagrant up
    5. vagrant ssh
    6. edit hosts file add:
        192.168.22.10   devtest.test
    7. seed database
    8. Go to: http://devtest.test and make sure it loads successfully

### Dev Test
    1. Fork a copy of this branch that is publicy accessible
    2. Go to: http://devtest.test/testHome
    3. Fix errors to make the page load
    4. Switch the user column to display the name
    5. Sort by date (most recent first)
    6. Make page title (Dev Test Home) not be cut off
    7. Go to https://devtest.test/add
    8. Make title and body require at least 5 characters
    9. Fix any errors found when posting
    10. Change post to AJAX
    11. Go back to testHome, and add a column to edit a post
    12. Add the ability to edit a post, based on add post
    12. Submit a branch with your updates

