---
title: "Week 1: Github"
date: 2025-05-01
slug: "wk1-github"
description: "Instructions for getting Github set up."
keywords: ["github", "setup", "wk1"]
draft: false
tags: ["github", "setup", "wk1"]
---

{{% admonition type=info %}}
If any of the instructions below are unclear, annotate this page with hypothesis while being logged into our course reading group. If you spot someone asking for help and you can offer advice, respond to the annotation. 

The sequence of steps below might be a bit different by the time you read this; Github often mucks about with its look and feel. Examine the steps first, and if what you encounter is a bit different than this, you should be able to work out the basic actions to take from this walk-through.
{{% /admonition %}}


### Introduction

Github is a code sharing website often used by digital historians. 'Git' is a program that takes snapshots of the current state of a folder, and stores them in sequence, allowing you to revert your changes to an earlier state. It also allows you to create **branches**, or duplicates of your folder, so you can experiment. If you like the results of your work, you can **merge** that branch back into your original.

**Github therefore is a hub for sharing these git snapshots.**

A branch (a copy, a duplicate) of your work uploaded to Github could therefore be copied to say my account (a **fork**); then I might download to my machine to work on it (I've **pulled** it). Once I'm happy with my changes, I **commit** them (save them to the sequence of changes that Git tracks), and then I could **push** those changes to the **fork** in my account. I would then send you a **pull** request or notification, asking you to pull my changes back to your account; you could then decide whether or not to **merge**.

{{% admonition type=info %}}
For our purposes, you will use Github mostly as a place to put your reflections or other pieces of work.
{{% /admonition %}}

I might sometimes fork your work, pull it down onto my machine, make changes that I commit, push it back online, and ask you to pull the changes back. But that won't happen very often. It takes a while to get comfortable with this.

### Get your account

1. Got to [github.com](http://github.com) and sign up for an account. You don't have to use your real name. (Protip: You might want to set up an email just for signing up for things.)

![](/docs/support/images/github/github-signup1.png)


---

2. Verify your account.

![](/docs/support/images/github/github-signup2.png)


---

3. Select the free tier (nb: **I will never require you to pay for any reading, or any software**. If something wants you to pay, **stop** and ask for help).

![](/docs/support/images/github/github-signup3.png)


---

4. Skip telling Github anything about yourself if it asks.

![](/docs/support/images/github/github-signup4.png)


---

5. Do the verification email thing. Once you hit the verification link in your email, you'll be brought back to Github to make a new repository:

![](/docs/support/images/github/github-new-repo.png)


---

6. Give it a reasonable name; tick the 'initialize with a readme' box, tick off the 'private' box, and hit the green commit button. (**Nb** It's your choice to choose public OR private):

![](/docs/support/images/github/github-new-repo-settings.png)

---

7. And on the final page, hit the 'dismiss' button in the 'Github Actions box'

![](/docs/support/images/github/github-dismiss-actions.png)


Ta Da! You now have a github account, and you've created your first repository. **Going Forward** create a new repository for each week's work/reflection. You can create a new repository from the plus sign in the top right corner:

{{< img src="/images/github/new-repo.png" alt="another new repo" width="500" >}}


**nb** Remember to tick off the 'initialize with a readme.md' file.

---

Once you've done that, you'll be at your Github user page:

![](/docs/support/images/github/github-signup5.png)


---

8. Add me as a collaborator to this and subsequent **private** repositories:

![](/docs/support/images/github/add-user-to-private-repo-1.png)


9. **Private Repo**: Then, once you've clicked on 'manage access', click on 'invite collaborator',

![](/docs/support/images/github/add-collaborator-to-private-repo-2.png)


10. **Private Repo**: Then find my username `shawngraham`, and add me:

![](/docs/support/images/github/add-username-private-repo.png)


### Setting up a 'repository' for your work

A 'repository' is just a folder that you've shared on Github. There are two ways to do this; the easy way and the more complex way. Luck you, you have _already_ done the easy way - you selected the `initialize with a readme`, and it's already present in your browser!

{{% admonition type=info %}}
To create new repositories, just click on the `+` button on the top right of your Github page when you're logged in. You might want to go ahead now and create repositories for week 2 through to week 12. Remember to tick off the `initialize with a readme` box. Remember to make them private.
{{% /admonition %}}

But if you didn't tick the initialize box, you've embarked on the more complex way. In the screenshot below, I created a new repository but I forgot to initialize it, and now I'm looking at this page:

![](/docs/support/images/github/github-complex.png)

If this is you, do not despair.

#### When you've forgotten to initialize a new repo:

You're going to have to install one or two things, and do some work at the **command prompt** or **terminal**.

1. If you have a PC, [click on this link to download and install git](https://git-scm.com/download/win). **Just use all of the suggested default settings when you run the installer**. If you have a Mac, you can install it by opening the terminal program (click on your applications and type 'terminal' in the search window) and then typing in these two commands (or copy and paste). The first command starts at the `/` and ends at the `"` and you must include the entire line from slash to closing quotation mark:

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```
and when that finishes,

```
brew install git
```

2. Make a new directory on your computer **with the same name as the repo you created above**. For my screenshotted example above, that would be `week-two`.
3. On a PC, find the folder in your file explorer; click on it so that's the folder displayed in the address bar at the top of the explorer. Then, click in the address bar and type `cmd` and hit enter. This will open a command prompt window for that folder, allowing you to type commands in directly. On a Mac, go to System Preferences, select Keyboard > Shortcuts > Services. Look for 'New Terminal at Folder' and tick the box. Open your finder; find the folder you created, right-click and select 'open Terminal here'.

---

{{% admonition type=info %}}
A Quick Primer for Working at the Command Line or Terminal

The following two videos, one for PC, one for Mac, show you how to do this. For reference's sake, this is what 'working at the command prompt' or 'working at the terminal' look like on your machine. When you interact with your computer, you can do it through a graphical interface - icons, clicks, etc - or you can directly type in commands. It's this latter kind of interaction that most people think of as 'coding', but for us, this is just 'opening the hood'.
{{% /admonition %}}

PC:
{{<youtube yvpn1lITcVU >}}

Mac:
{{<youtube 0R25NOsAHh4 >}}

Key commands for PC:
+ `dir` show the contents of the current directory
+ `cls` clear the window so that it's fresh again
+ `cd directory-name` change director to the named directory
+ `cd ..` change directory up one level
+ if you hit the up or down arrows you can cycle through the history of commands you've already typed

Key commands for Mac:
+ `ls` list the contents of the current directory
+ `pwd` print the path (location) of the current directory
+ `cd directory-name` change director to the named directory
+ `cd ..` change directory up one level
+ `history` prints out the entire history of commands you've typed this session
+ up and down arrows will cycle through this list

---

4. Do you see where, in your browser at github, it says `...or create a new repository on the command line`? With your command prompt or terminal open in the appropriate folder on your machine (remember, folders on your machine = repos on github), type in each line exactly as it is there (beginning with `echo`), hitting enter at the end of each line, in order. **If the command works, you'll just be presented with the next prompt.** The computer only ever responds when there is output to print - which often means only when there is an error message to report. (**nb** Git might prompt you to enter your email and name, as it does in the PC video, the first time you ever do this).

Ta da! You can now go to `github.com\<your-user-name>\your-repo` and you'll see it all there tickety boo.

### Making a new text file on Github

You can make a new text file by clicking on the 'create new file' button; **remember to always use .md as the file extension**. You can specify headers, links, images, bullets, blockquotes and so on by using [markdown conventions](https://guides.github.com/features/mastering-markdown/.)

The two videos below might be a bit clearer on youtube itself.

{{<youtube 2SeeKYWXbrE >}}

### Uploading a file into Github

You can add new files from your computer by dragging and dropping them into the main repository. At the end of this video, I show you how to display the image in the text of the reflection.

{{<youtube muKAh_j3Ogs >}}