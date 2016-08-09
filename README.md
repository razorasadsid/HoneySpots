# HoneySpots
Noob-friendly CSV parser and .bat generator for PokemonGoMap instances.
Mainly, this is just an easy way to save some heartache if you've got many, many ptc accounts and don't feel like adding them by hand to some .bat files. This is a really good way to generate a few .bat files with very many accounts to scan a few small areas very quickly and accurately. 

Easily used with accounts generated through https://github.com/FrostTheFox/ptc-acc-gen, just open the final accounts.csv with excel and delete the columns that aren't the usernames and passwords, and then save as a .csv

There is more to come - will attempt to integrate Beehive-style worker multithreading and calculations along with easy to set multi-workers with easy multi-account allocation per worker - but that comes much later :P

#How-To

Step 1: Make sure your accounts.csv is in the same directory as HoneySpots.exe and is named accounts.csv

Step 2: Setup your config.ini - nothing should be too unfamiliar. 

Step 3: MAKE SURE your accounts.csv looks like this when you open it with notepad:

![csvexample](http://image.prntscr.com/image/7b7d0854808041a78a35e83870c42b8f.png)

It should be account,password all the way down!

Step 4:Run HoneySpots.exe, it should give you a few dialouge boxes to confirm your settings and the accounts detected and should build a honeyspots.bat in it's directory. 

Step 5: Now move this .bat file to the directory where you have your main PokemonGoMap runserver.py file and run it!

Now as long as you have python added to your system path you should be good to go. Feel free to make changes to the .bat file as you please. 

This was quickly coded in AHK to solve a specific problem I needed solving. Anything else I can't promise :P
