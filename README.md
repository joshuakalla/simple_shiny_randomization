# Shiny App to Randomize a List to Experimental Conditions
This [Shiny app](https://josh-kalla.shinyapps.io/simple_shiny_randomization/) takes an uploaded spreadsheet and randomizes to up to four experimental conditions based on percentages specified by the user. Visit the app at [https://josh-kalla.shinyapps.io/simple_shiny_randomization/](https://josh-kalla.shinyapps.io/simple_shiny_randomization/)

# Examples

## Example 1: Simple Random Assignment

Simple random assignment assigns all subjects to an experimental condition with an equal probability by flipping a (weighted) coin for each subject. For example, you might want subjects to be randomly assigned to Group 1 with probablility 0.5, Group 2 with probability 0.4, and Group 3 with probability 0.1. Note that under simple random assignment, the number of subjects assigned to each group is a random number. This means that depending on the random assignment, a different number of subjects might be assigned to each group.

To use simple random assignment, you would make sure the type of randomization is set to simple. For this example, you would set the group percentages to:

- Probability of Group 1 = 0.5
- Probability of Group 2 = 0.4
- Probability of Group 3 = 0.1
- Probability of Group 4 = 0

You would then upload your spreadsheet, ensure the output reads "GOOD TO DOWNLOAD", and then click "Randomize and Download!". This will downlaod a spreadsheet with a treatment vector according to your specified probabilities. Note that the numerical suffix of the saved file was the seed used in this randomization. The seed is set to the date and hour. Saving this seed allows you to recreate the randomization, if necessary.


## Example 2: Complete Random Assignment

Under complete random assignment, you can specify exactly how many units are assigned to each condition. Say you want 10 units in Group 1, 15 units in Group 2, 3 units in Group 3, and 1 unit in Group 4, you would first select "Complete" as the type of randomization and enter in the above numbers. Then upload the file. If you see in error, this means the total number in each condition does not equal the number of observations in the data. Fix this and the error should go away. You can then download your randomized data. Note that the numerical suffix of the saved file was the seed used in this randomization. The seed is set to the date and hour. Saving this seed allows you to recreate the randomization, if necessary.

## Thanks
Thanks to [@SachaEpskamp](https://gist.github.com/SachaEpskamp/5796467) for providing code that was helpful in using Shiny's upload/download functions and to the [DeclareDesign](http://declaredesign.org/) for creating the (Randomizr)[https://github.com/DeclareDesign/randomizr] package that inspired this. 
