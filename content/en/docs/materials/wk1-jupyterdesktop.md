---
title: "Week 1: Jupyter Desktop Lab Bench"
date: 2025-05-03
slug: "wk1-jupyterdesktop"
description: "Instructions for Jupyter exploration."
keywords: ["jupyter", "setup", "wk1"]
draft: false
tags: ["jupyter", "setup", "wk1"]
---
👋🏻 Hi!

Let's do some coding. The interface below accepts python code (it might take a moment to load up; if you can see a 'play' etc it's loaded). Try copying and pasting this:

```python
text = "Oh yeah, digital archaeology!"
print(text)
```
into the gray box at the bottom of the interface below. Then, hit shift+enter while your cursor is in the box:

<iframe
  src="https://jupyterlite.github.io/demo/repl/index.html?toolbar=1&kernel=python&showBanner=0"
  width="100%"
  height="500px"
></iframe>

Now try this:
```python
one = 1
two = 2
print(one + two)
```

See how easy that was? You just entered some python code into a coding environment powered by a version of the Python language. That gray box is a 'cell' powered by the Jupyter lab interface. When you hit shift+enter (or hit the 'play' arrow) the code is passed to an interpreter which translates the python language into something your machine understands.

We want to get something similar set up on your computer. In this course, we will use the Python and R languages for the most part, so we need to get an interpreter or 'kernel' for Python and for R installed. We'll start with Python, for now. 

Installing Python directly onto your machine can be a pain though, since there are so many of you and so many different computers y'all might have. We will be using, for parts of the course, an application called 'Jupyter Lab Desktop' that ought to make life easier for us. I have created an extension for Jupyter Lab Desktop that lets us not only do computational analysis, but also, make wiki-style notes around our readings and our analyses (following 'personal knowledge management' approaches.)

## The Content for our Lab Bench

I have made a folder with a variety of notes (plain text files that use the .md file extension to signal that I'm using [markdown](https://www.markdownguide.org/cheat-sheet/) to indicate headers, bullets, and so on) and python 'notebooks' that mix python code with markdown comments. These files are signaled with the .ipynb extension, and they can be understood and run by Jupyter. 

The attraction for us is that we can make notes using markdown, and we can treat the .ipynb files like experiments that we link into our thinking. Right-click and open this link in a new browser tab: [https://github.com/shawngraham/digiarch-labbench](https://github.com/shawngraham/digiarch-labbench).

Click on the green 'Code' button then click 'Download zip.'

![](/docs/support/images/jdl/lb.png) 

Unzip this file in a location on your computer that is easy to find.

{{% admonition type=info title="Oi! Windows Users!" %}}
You **MUST** right-click the file and select 'extract all' to properly unzip this folder so that you can use it in the next part.
{{% /admonition %}}

## Our Lab Bench

WE will use JupyterLab Desktop as our lab bench for analytical code work and note taking. It provides a clean, self-contained environment that will not interfere with any other software on your computer. First of all, grab the version that works on your machine:

+ Install for Windows [using this file](https://github.com/jupyterlab/jupyterlab-desktop/releases/latest/download/JupyterLab-Setup-Windows-x64.exe)

+ Install for Mac [using this file](https://github.com/jupyterlab/jupyterlab-desktop/releases/latest/download/JupyterLab-Setup-macOS-arm64.dmg) (if you have an older Mac from before Apple Silicon chips were introduced, ie 2020, [try this instead](https://github.com/jupyterlab/jupyterlab-desktop/releases/latest/download/JupyterLab-Setup-macOS-x64.dmg))

+ Install for Linux [have some options depending on which variety of Linux](https://github.com/jupyterlab/jupyterlab-desktop).

Now we will install the specific Python libraries and extensions needed for this course with a single command.

1. When you first install Jupyter, it will check to see if you have Python installed on your machine. If it cannot find it in the usual places, it will ask you if you want to install with the bundled Python. Click on that install bundled python option.

![](/docs/support/images/jdl/jdl0.png)

2. Open JupyterLab Desktop. Select 'open' and choose a folder where you want to do your course work.

![](/docs/support/images/jdl/jdl1.png) 

3. Once it loads, go to the top menu bar and click: File > New > Terminal

![](/docs/support/images/jdl/jdl2.png)

4. A command-line terminal will open inside a new JupyterLab tab. It will have a prompt like `$` or `>` or even `%`.

![](/docs/support/images/jdl/jdl3.png)

5. Copy the entire command below (it does two things: using pip, it installs a number of extensions for python and jupyter that we need; using git, it downloads content for you I have created). Make sure you select the complete command from 'pip' to '.git', then copy (Ctrl+C or Cmd+C). 

```     
    pip install pandas matplotlib scikit-learn ipywidgets lckr-jupyterlab-variableinspector jupyterlab-git jupyter-archive jupyterlab-pkm; git clone https://github.com/shawngraham/digiarch-labbench.git
```

6. Paste the command into the JupyterLab terminal (Ctrl+V or Cmd+V) and press Enter.

![](/docs/support/images/jdl/jdl4.png)

You will see a lot of text as those two commands are run and packages are downloaded and installed. This may take a few minutes. Wait for it to finish and for the command prompt ($ or >) to reappear.

7. Completely close JupyterLab Desktop. 

8. Find the `digiarch-labbench` on your computer - use your finder or file explorer to locate it, and REMEMBER WHERE YOU'VE PUT IT!
  
9. Re-open JupyterLab Desktop. Select 'open' and find the  `digiarch-labbench`. Select it. If you see the PKM extension pop-up when you open the folder, then you're good to go!

![](/docs/support/images/jdl/jdl5.png)

I have preloaded this folder with guidance on note-making, and a number of computational notebooks (which are signaled by having the .ipnyb at the end of the filename) which we will use throughout the course.

- Explore the existing materials, 
  - try to make some notes on your readings, your observations, hiccups or roadblocks you've encountered this week. 
  - Make reflection note and your wk-1 memo note in the environment. Then right-click on those notes in the file pane and select 'download' for those two notes. Then upload those notes to your github repository.

{{% admonition type=info %}}
Windows users, I would suggest that you do not put the `digiarch-labbench` into your One Drive, no matter how often Windows begs you to do it. Put it somewhere easy to find on your machine. 
{{% /admonition %}}

## Help, this isn't working for me. 

That said, AS AN ALTERNATIVE, or if you run into trouble using this application, you may download all of the course materials from [this link](https://github.com/shawngraham/digiarch-labbench/archive/refs/heads/main.zip) and use [Obsidian](https://obsidian.md) to manage your note making, and then open the ipynb files directly in the https://colab.research.google.com/ service under 'file -> upload notebook'.
