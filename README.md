[![View Indian Reference Atmosphere (0 - 80 km AMSL) by Sasi (1994) on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/81328-indian-reference-atmosphere-0-80-km-amsl-by-sasi-1994)

This file is meant to be viewed at [its Github page](https://github.com/athreyr/aircraft_design). If you have already followed the steps in this file, you can open [read_me.txt](read_me.txt) on your local repo and read how to actually use the project.

INTRODUCTION
------------
1. **What** is this? This is the Github site of a project to (hopefully) develop a MATLAB toolbox for conceptual design of any kind of aircraft (eventually). For now, it only has the implementation of a [reference atmospheric model](https://en.wikipedia.org/wiki/Reference_atmospheric_model) with units. New features to be soon added include fin geometry, foil geometry, foil fluid dynamics, etc.
2. **Why** does this exist? Well, while there are plenty of aircraft design software<sup id="a1">[1](#f1)</sup> out there, I needed something in MATLAB<sup id="a2">[2](#f2)</sup>, while also being highly customizable, e.g. by adding your own unit symbols or unit dimensions (like currency).
3. **When** will this be ready? As soon as I figure out how to write [unit tests](https://www.mathworks.com/help/matlab/class-based-unit-tests.html)<sup id="a3">[3](#f3)</sup>, I would know when my code is good enough to be published, and that would significantly accelerate the process.
4. **How** does one use this? Read on.

HOW TO USE
----------
I aim for this project to be as user-friendly as MATLAB itself. The reader is assumed to be familiar with regular MATLAB operations and nothing else. If you already know some or most of the steps below, feel free to skip ahead.
1. Set up Git. In later releases of MATLAB (I haven't pinned down which one yet), you don't need to do this - MATLAB comes with Git. Run `!git help` at the MATLAB Command Window to see if it executes without error. If it errors, download Git for your OS from https://git-scm.com/downloads, and install it by choosing the appropriate options as given in https://www.mathworks.com/help/releases/R2018b/matlab/matlab_prog/set-up-git-source-control.html#buhx2d6-1_1 (don't worry about the part about "registering binaries", that'll be taken care of when you "download" this repository).
2. Navigate to an _empty_ folder using Explorer, right-click, and "Open Git Bash here"
3. Type `git clone https://github.com/athreyr/aircraft_design` and press Enter to "clone this repo", i.e. copy the _entire_ contents of this repository to your empty folder.

Now you can open [read_me.txt](read_me.txt) located at the project root folder.

---

<b id="f1">1</b> placeholder for links to other such software, but rest assured there's a lot [↩](#a1)

<b id="f2">2</b> MATLAB is the language best suited for <u>**_THIS_**</u> purpose. Don't fight me on this. [↩](#a2)

<b id="f3">3</b> I had to learn Git and Markdown along with MATLAB OOP __on top of__ 5 years of aerospace engineering just to get this far, so bear with me. [↩](#a3)
