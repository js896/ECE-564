#   ECE564_HW 
This is the project you will use for all four of your ECE564 homework assignments. You need to download to your computer, add your code, and then add a repo under your own ID with this name ("ECE564_HW"). It is important that you use the same project name.  Any notes, additional functions, comments you want to share with the TA and I before grading please put in this file in the correspondiing section below.  Part of the grading is anything you did above and beyond the requirements, so make sure that is included here in the README.

## HW1
I used UILabel for the labels, UITextfield for info input, UISegmentedControl for gender, program and role slection, UITextfield for output at the bottom. Sometimes the playground can't read keyboard input as mentioned in Piazza @17, if that happenes, please restart the playground.

## HW2
To search you must specify "First", "Last", "From" and "Degree", to add/update you must provide info for all input fields.
1. I did use any database.
2. I used StackView for input fields.
3. When you search with my name, you're gonna see a different pic.
4. I added a "clear button", it can clear all input fields, you may find it handful when adding a new person.
5. I used PickerView for Role and Gender input.
6. Updating a person's gender or role doesn't make sense.
7. I feel it would make more sense if Degree field could alse use PickerView, but the requirement said it should be any possible string. So for prepopulated data, options for this field are "Not Applicable" and "Grad"
## HW3
1. I didi not use cells to fake section headers.
2. Name can't be changed when editting, an alert will pop up for this.
3. No database used.
4. When editting press on the image can let you choose and save photo from Photos app
## HW4
1. Search bar support is not ideal, changes to data wouldn't apply immediately to the search result. The scenarios includes but are not limited to:  
    if you type China in search bar and go to create a new person from China, when you go back to table view, Ric would appear in the search results. But if you change the text in search bar like deleting the "a" at the end of China and retype the "a" to make "China" complete, Ric won't appear in the search results. 
    To conclude, every time chages are made to data in table view, you need to change the text in search bar to make it take effcects.
    ## HW5
    In each information view, swipe left to flip and swipe back to go back. 
    Somehow swiping back doesn't work on Xcode 11.x, if you wanna see swiping back please run it on Xcode 12.0.1
    On the back side of my information view, you can see/hear:
    1. Attributed text: "NBA" at top left
    2. UIImage: a basketball image
    3. A circular progress using "UIBezierPath"
    4. Basketball.swift contains the "draw" method
    5. Animation: a basketball bouncing and a circular progress
    6. The theme song of NBA 2K 2020 
    ## HW6
    I used JSONEncoder to achieve data persistence. 
    All pictures are converted into base64 format before saving to disk.
    The DukePerson object supports ECE564 JSON Grammar.
    Team support added. If the Team field is filled for a Student, then  a Section will be created for that Team in the Table View and that student will be put in that section.  If a Student does not have any Team information, he/she will be kept  in the Student section. 
    Email field added.
    Searching and swipe options always work.
    ## HW7
    1. I skipped log in process because I keep getting request timed out error. The Log in alert will show up, you can enter your info, but I am using hard-coded token to access the server. There will be alerts for login button pressed, status and timeout.
    2. I get all entries from the server when launching the app. Loading entries from the server to my table view will take about 30 seconds, thanks for being patient.
    3. Everything works before still works, but only changes about me will be posted to the server.
# ECE-564
