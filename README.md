![alt logo](Assets/Icon128.png)
# 速読 Sokudoku

## What Is It?

Sokudoku is a program for practicing reading random characters.
Although probably best for syllable-based character sets like Japanese
Katakana or Hiragana or Korean Hangul (for which it is primarily
intended), it more or less works fine with "regular" phonetic
character sets as well (or something like Korean Jomo), taking into
account the fact that it more or less produces strings of random
gibberish (alternately, instead of drilling on longer strings, it's
always possible to simply drill on single characters).  Things like
Japanese or Chinese compound words would also work reasonably well,
although those are probably more suited for a general flashcard test
program like [Anki](http://ankisrs.net/) which has the further
advantage of allowing you to drill in the other direction as well.

The program itself is fairly simple: it displays a set of characters,
the user attempts to type in the pronunciation of those characters as
quickly as possible, it times the user (with a penalty for incorrect
answers), keeps track of how fast the characters were entered and
optionally preferentially feeds the user characters they have trouble
with.

Really, the program is a bit of a gadget thrown together over a couple
weeks (and refined a bit as I've used it) so I could drill down on
Hangul reading practice (with Katakana as a bonus).  It's not as
generally useful as a general/configurable drill program like Anki,
but I believe it's still useful as a complement (I've been using both)
-- after all, I know why I wanted it, but your mileage may vary.

At this point, I'm probably done working on it (minus any bugs I find
while using it, except for maybe adding a character package or two to
test myself on).

## Application DMG

If you just want to install the program, there's a barebones DMG with
the application (and character packages) in the release directory; the
current latest version is [1.0.0](Release/Sokudoku-1.0.0.dmg).

## XCode Project

This repository contains an XCode project in the following
directories; if you have XCode installed, it should be possible to
load the project from the checked out repository and then build and
modify it.

- Sokudoku/ : source files
- SokudokuTests/ : unit tests
- Sokudoku.xcodeproj/ : XCode project files

## Packages

This repository contains several package files that can be drilled on
in the main program.

- Packages/ : package files
- Packages/Source/ : ruby programs that generate those package files

So far a Japanese kana and Korean Hangul and Jomo packages are
included; more may follow (as I build packages to practice on, or
maybe other people do if anyone besides me ever uses the program).
The test package, of course, is mainly a simple package for testing
and not of any particular interest beyond that.

Packages are encoded as plists (Apple's XML format that Cocoa supports
natively).  The format is actually fairly simple: a dictionary with a
name, an array of tags, an array of descriptions, and an array of
characters (each made up of a dictionary containing a literal, tags,
and pronunciations).  It's unlikely I'll fully document the format
anytime soon, but for the curious there are obviously several examples
in the repository of both programs that will generate packages and
packages themselves -- if you build a new package that contains any
errors, the program should supply somewhat meaningful error messages
when you attempt to load it (which should help you fix it).

Once packages are loaded, the application handles storing the package
and history internally in the user's account.

## Usage

The first time the program is run, it will prompt you to load a
package into Sokudoku's library.  This step is not optional -- the
program will not run until at least one package is loaded.  From
there, the user is presented with the main window:

![alt main window](Assets/mainwindow.png)

Everything else launches from there.  Drill options can be chosen on
the right.  Subsets from a package can be selected (e.g., for the
Japanese Kana package, drills can be limited to Hiragana or Katakana).
Session length can be chosen, minimum and maximum lengths for drill
questions can be selected, and whether or not difficult characters
should be prioritized can be toggled off and on (i.e., the user can
choose whether slower characters should appear more often in drills).

On the left are some other options: the top button chooses which
package is currently loaded.  Below that, more packages can be loaded,
a package can be "forgotten" (i.e., taken out of the list of packages
available to select), "recalled" (i.e., restored to the list of
packages available with all of its history intact) or permanently
deleted (which will remove all of its history as well.  Once that
occurs, it can only be restored -- minus any history or character
weightings -- by being re-imported).

On the bottom are other options for erasing history (this removes any
data used by the history graphs) or completely resetting the package
(restoring it to the state it was in when freshly imported, losing any
character weightings and history).  The other two buttons load graphs.

Starting a drill is done by pressing "Go!" -- as should be fairly
obvious -- and produces the following window.  To respond to each
set of characters, type the pronunciation into the box (which should
start selected, and clears itself after each question).

![alt drill window](Assets/drillwindow.png)

## License

Copyright 2013 Douglas Triggs (douglas@triggs.org), All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"); you
may not use this file except in compliance with the License. You may
obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
implied. See the License for the specific language governing
permissions and limitations under the License.
