#Load the iris dataset
data(iris)
#Assign to object for ease of use
my_data <- (iris)
#Check success of saving as object (I'm a fresh R-user)
View(my_data)
#View only the Petal.Length column of data
View(iris$Petal.Length)
#Save as more concise object for ease of use
Petal.Length <- (iris$Petal.Length)
#Check success of assigning new object
View(Petal.Length)
#Read the help file for the function that calculates the mean
?mean
#Calculate the mean of the Petal.Length field
mean(Petal.Length)
#Save it as an object named petal_length_mean
petal_length_mean <- mean(Petal.Length)
#Check success of assigning new object
View(petal_length_mean)
#Read the help file for histogram
?hist
#Plot the distribution of the Petal.Length column as a histogram
hist(Petal.Length)
#Functions suggested by Collin, Bowei, and Marko to extend y axis to 40 and flip number labels
hist(Petal.Length, ylim=c(0,40), las=1)