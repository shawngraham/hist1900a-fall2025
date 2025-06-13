#--- Step 1 ONE TIME ACTIONS
library("devtools")
devtools::install_github("benmarwick/rrtools")
library(rrtools)

# now we set up the structure of the compendium
# name it lastname.exit.ticket, eg:
rrtools::use_compendium("graham.compendium")

# edit the description file now. save it.

# adjust the next line accordingly:
setwd("~/graham.compendium")

rrtools::use_analysis()

# because we are using a computer in the cloud, inactivity after around ten minutes
# causes this to time out. RUN commands to avoid being timed out.
# periodically zip up your work and download it.

# let's do that now.
# now go to the jupyter file explorer, and open a new terminal
# at the terminal prompt, zip the compendium up. the zip command goes like this:
# zip output-zipped-folder name-of-input-folder-to-be-zipped
# so in my case: zip output graham.compendium

# then at the jupyter file explorer tick off the zipped folder then hit 'download'.

#--- Step 2: GET THE GRAVEYARDS DATA
library(curl)
graveyards <- read.csv( curl("https://raw.githubusercontent.com/shawngraham/hist3000/master/static/data/graveyards-data.csv") )

write.csv (graveyards, "analysis/data/raw_data/my_csv_file.csv")

# now our graveyards data is in your compendium as a csv called 'my_csv_file.csv'

#---- Step 3: NOW, WRITING YOUR RESEARCH COMPENDIUM

# Open the analysis/paper/paper.Rmd file
# fill in the metadata at the top of the file correctly, for the 'title', 'author', 'institute' keys
# (You can delete line 14 completely)
# fill in the metadata for abstract, keywords, and highlights.

# don't touch anything else until line 58!

# This file is in 'R Markdown'. Unlike a regular R script, the R code has to be set off in particular ways.
# R markdown mixes your writing with your code.
# to put a bit of code in, mark it off with three backticks & signal that R code is coming next,
# followed by the code,
# closed off by another three backticks. Here's an example (imagine the # wasn't there):

# ```{r}
# plot(mtcars) #<- a bit of code
# ```

# NOW: What goes in this document?

# I want you to do one simple bit of analysis on the graveyards data we collected.

# In 'Background', I want you to explain, in one paragraph, your archaeological experience before coming to this class.

# In 'Methods', I want you to describe how you collected the data.

# In the Results section:
# the default code in line 72 makes your data - the graveyards data - available for your paper.
# Using what you learned earlier in the course, I want you to do a summary of some variable (numeric)
# or a crosstabulation of some categorical variable. You can try plotting or doing something more complicated if you're up to it.

# PROTIP: do these explorations in a regular R script file (which you save in the 'data' folder). Once you get it working the way you want,
# you can copy the code to the .Rmd file. Copy line 72 to load your data in. When you save that script
# you can create a new folder at the same time; call it 'scripts', and save the script in that new folder.

# In 'Discussion' give me some sense of what you think the above results might mean. I'm not expecting an essay here.
# This wasn't a class on graveyards.

# Finally, give me some sort of a conclusion.

# save, zip up your compendium, download.

#--- Step 4 TURNING RMD INTO A WORD DOC
# When you're in the paper.Rmd file in R Studio, there is a tiny tool bar right underneath
# the title tabs. One of the options on that bar is 'Knit'. Hit that.
# R Studio will read your paper, and turn it into a word document, and prompt you to download it.
# magic!

# BUT, if there's an issue with your Rmd, you'll get an error; read that carefully as it'll
# tell you where the problem is. Usually, it'll be because you forgot to wrap your code with
# opening and closing backticks.

# *If* you can't get the code and the .Rmd file to work properly, you can delete the code bits in
# the 'results' section, and add a line saying, 'see my R script file blah.R'. Save, then knit.

# Going further: If you've been using Zotero, you can export your zotero library as a .bib file.
# You could then upload that .bib file via the jupyter file explorer page, and move it to the analysis/paper folder.
# Each entry will have a 'cite key'; if you want to cite it in rmarkdown, you just frame it
# in square brackets and an @ sign, eg [@graham2016]. When R Studio knits your document, it'll
# go into the bib file, find the reference, and format it correctly.

# SAVE! ZIP! DOWNLOAD! PUT THE ZIP IN YOUR OWN REPO!
