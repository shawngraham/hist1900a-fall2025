
# simple statistics in R for archaeologists

# https://mybinder.org/v2/gh/binder-examples/r-conda/master?urlpath=rstudio

# Now, Kevin Gratski has an excellent course on 'Digital Archaeology and Data Reuse',
# https://github.com/kgarstki/Introduction-Digital-Archaeology-Course and we are going
# to follow what he does with his class here:
# https://github.com/kgarstki/ANTH-641_Stats-with-R
# this document is a remix of that one.

# The "archdata" package was created by David L. Carlson and Georg Roth for
# "Quantitative Methods in Archaeology Using R" by David L. Carlson (2017).

# set up, grab the packages you need
install.packages("archdata")
library(archdata)
library(RcmdrMisc)

# To find out the different kinds of data in archdata and where the data come from, run the following
??archdata
# or go to
# https://cran.rstudio.com/web/packages/archdata/archdata.pdf

#1. Initial exploration for numerical and categorical data

# Once you've collected data, you will want to explore the distribution of that data. We can look for
# the average values, or the most frequently occuring values (mean and median). We can look for how dispersed
# the data are around those central tendencies by looking for standard deviation or variance.

# Because the data is already packaged up for us in archdata, we can load it up with the 'data' command.
# Here we'll load up the 'DartPoints' dataframe:
data(DartPoints)
View(DartPoints)

# Three ways of finding the average length of the dart points:
mean(DartPoints$Length)
mean(DartPoints[, 5])
mean(DartPoints[,"Length"])
# All three commands are equivalent. First, we tell R we want the mean, and then inside the brackets we
# tell it WHAT we want mean to be calculated on. In the first example, we give the name of the dataframe
# and then use the $ operator to specify which column by name. In the second, we give the name of the dataframe
# and then indicate the position that we want: the 5th column. The third specifies position, but uses the name of the column.

# You can calculate each descriptive statistic one at a time, or you can get R to give you:
summary(DartPoints$Length)

# So let's indicate the number of significant digits we want (places after the decimal) and then
# get R to give us a summary for *all* the columns, from the 5th position to the 11th:
options(digits=3)
numSummary(DartPoints[, 5:11])

# What happens if you try to include columns 1 to 4?

# How many points are there for each type of point? The type is in the 'Name' column.
# We make a new variable called DP_Type, and it gets the results of the command
# table(DartPoints$Name).
# The outer parentheses are a short cut to print the result of what goes inside DP_Type.
(DP_Type <- table(DartPoints$Name))

# We can work out the proportion each type has using prop.table on DP_Type, then multiplying by 100.
prop.table(DP_Type)*100

#---
# Initial exploration for categorical data
# In DartPoints, there's a lot of data about the kind of blade, and the shape of the blade.
# These are categories; something either is in one category, or another. So one thing we
# can do is see how they relate to each other by cross tabulation.

# Here, we create a new variable to contain the results of the xtabs command. You can almost read
# the code like this: DP_CT gets the results of xtabs of Name versus Blade.Sh from DartPoints.

(DP_CT <- xtabs(~Name+Blade.Sh, DartPoints))

# We can add up each row and column by using the addmargins command:
addmargins(DP_CT)

# The bottom right hand corner shows us how many records we've added: 89. But do we have all the data? Let's check
# with the `dim` command (dimension):
dim(DartPoints)

# that command tells us we've got 91 rows and 17 columns. So DP_CT is missing some data!
# What gives? If you look at DartPoints:
View(DartPoints)

# you'll see we're missing cells of data. That might be the issue. So let's add the missing data
# to our cross tabulation:

addmargins(xtabs(~Name+addNA(Blade.Sh), DartPoints))

#---
### YOUR TURN #1

# add another dataframe from archdata, and explore the numerical and categorical data. Write down any patterns you see.
#---

#2. Graphs
# Looking at data with Graphs - Often, graphs provide us with a good summary of data and can help illuminate patterns.
#
# We're going to look at two ways to visualize the number of coils present on La Tène fibulae
# from the Iron Age cemetery of Münsingen near Berne, Switzerland. Bring the dataframe into your directory.
data(Fibulae)
View(Fibulae)

# We're interested in the variable "Coils"
(Fib_coils <- table(Fibulae$Coils))

# First we'll make a pie chart of the number of coils. We'll include a main title and title our variable.
pie(Fib_coils, main="La Tene Bronze Fibulae", xlab="Number of Coils", clockwise=TRUE)
# Beautiful! Remember to export the graph as image and upload it to your GitHub.

# Let's compare it to a barplot of the same data.
barplot(Fib_coils, main="La Tene Bronze Fibulae", xlab="Number of Coils", ylab="Number of Fibulae")
# Export that graph, as well. Which way to visualize the data is more helpful?

# We'll try one more graph, using more complex data. First bring the dataframe Pithouses into the directory.
# This includes the desription of 45 Arctic Norway pithouses with 6 categorical variables.
data(PitHouses)

# Then we'll create a cross-tabulation of Hearths with Size
(PitHouses.tbl <- xtabs(~Hearths+Size, PitHouses))

# Then create a barplot of the crosstab. We'll include a legend that describes are different Hearths.
# Remember to export the grab when you're done.
barplot(PitHouses.tbl, ylab="Frequency", main="Arctic Norway Pithouses", beside=TRUE,legend.text=TRUE, args.legend=list(title="Hearths"))

#---
## YOUR TURN #2. Find a new dataset from the archdata package. Use one of these two create a graph of the data.
# You can use a scatterplot (plot), a bargraph (barplot), pie chart (pie), or boxplot (boxplot).
# Save the graph you make into the GitHub repo.
#---

#3. Chi-squared test of association
# see also https://www.r-bloggers.com/chi-squared-test/

# First we need a contingency table. This will allow us to say, is there an
# association between x and y?
# Let's say we suspect there's something up with the form of the house and the depth of hearth.
# So we make a new table with just that data:

(table(PitHouses$Orient, PitHouses$Form))

# Looking at the numbers, it kinda looks like _something_ is going on?
# But that's why we do the test.
# Chi-square measures the difference between what we observe in the
# contingency table, and what we would expect, if the distribution
# is normal.

#Pearson's Chi-squared test is simple to perform.
# The 'correct=FALSE' means, do we want to apply Yates' correction?
# (see https://en.wikipedia.org/wiki/Chi-squared_test for an accessible explanation)
# for now, we don't.

chisq.test(PitHouses$Orient, PitHouses$Form, correct=FALSE)

# The X-squared value is very small, and the p-value is greater than
# the 95% significance value (0.05) we reject the idea that there is an association.
# (That is, we accept the null hypothesis).

# Now, when we look at the table of values, we see that oval houses with the gabel
# towards the coast only have 1 example. Chi-square is wonky if any of the values
# in a 2x2 table are less than 5, so we can't really conclude anything here.

# Let's see if there's an association between the number of hearths and the form of the house:

table(PitHouses$Hearths, PitHouses$Form)

#Pearson's Chi-squared test
chisq.test(PitHouses$Hearths, PitHouses$Form, correct=FALSE)

# What's the p value? If it's less than 0.05, then we can reject the null hypothesis.
# (That is, there's an association). If it's greater than 0.05, we accept the null hypothesis.
# (That is, there's no association).

# Let's try it on a different dataset, the EWBurials.
# Read up on the data:
??EWBurials
#Load and view the data:
data("EWBurials")
View(EWBurials)

# We might imagine that there's an association between burial goods and the different groups:
table(EWBurials$Goods, EWBurials$Group)
# Pearson's Chi-squared test
chisq.test(EWBurials$Goods, EWBurials$Group, correct=FALSE)

# What is the p value? Do you reject the null hypothesis?
# What other associations might you imagine?

#---
# YOUR TURN #3
# Explore some of the other datasets. See if you can find some associations.
#---

#---
# YOUR TURN #4
# Load up our grave data

library(curl)

graveyards <- read.csv( curl("https://raw.githubusercontent.com/shawngraham/hist3000/master/static/data/graveyards-data.csv") )

View(graveyards)

# Now... explore. Use the image export to export any graphs you make; copy any interesting results to a new
# markdown file, and place everything in your repo for this week.
