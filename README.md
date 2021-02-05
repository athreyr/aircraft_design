[![View Indian Reference Atmosphere (0 - 80 km AMSL) by Sasi (1994)  on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://in.mathworks.com/matlabcentral/fileexchange/81328-indian-reference-atmosphere-0-80-km-amsl-by-sasi-1994)

INTRODUCTION
------------
This is just a repository of MATLAB files related to conceptual design of different kinds of aircraft. If you're here from **MATLAB File Exchange**, you're looking for the contents of the **ira** (Indian Reference Atmosphere) folder.

HOW TO USE
----------
If you have no idea what to do at this point (which is how I used to be like till _very_ recently), here are the steps to follow (this is about installing Git on Windows 10 and using it with MATLAB, but it can be applied to other OS with appropriate changes):
1. Download Git from https://git-scm.com/downloads
2. Install it by choosing the appropriate options as given in https://in.mathworks.com/help/releases/R2018b/matlab/matlab_prog/set-up-git-source-control.html#buhx2d6-1_1 (don't worry about registering binaries, that'll be taken care of when you "download" this repository)
3. Navigate to an _empty_ folder using Explorer, right-click, and "Open Git Bash here"
4. Type `git clone https://github.com/athreyr/aircraft_design` and press Enter to "clone this repo", i.e. copy the _entire_ contents of this repository to your empty folder

Now you can use the files with MATLAB like you would normally.

AUTHOR'S NOTE
-------------
It has come to my notice that people are indeed finding this repository useful enough to clone it (who knew? I thought I'd just be using it for cloud storage), so I sincerely apologise for all the histories that I surely must have screwed up recently.

Being very new to Git and Github, I made:
+ the rookie mistake of pushing too early,
+ the rookier mistake of force-pushing, and
+ the rookiest mistake of using the MATLAB in-built Git integration for my initial commits.

In the future, I'll ensure that this doesn't happen again by
+ trying to do everything locally first,
+ pulling and rebasing before pushing, and
+ using Git Bash

I am putting this up here as a lesson learnt the hard way, so that other beginners _don't_ follow in my footsteps.
