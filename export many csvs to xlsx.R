# Export multiple csvs into one xlsx

#packages----
#Uncomment next line to install package
install.packages("openxlsx")

#Load package
library(openxlsx)

#csv to list----
#Indicate what the file pattern is
#all files must have the same pattern
#here all are csvs
file_pattern <- "*.csv"


file_list = list.files(pattern = file_pattern, 
                              full.names = TRUE)


file_list = setNames (file_list,
                      list.files(pattern = file_pattern))

#csv to data frames----

# Next command is if you don't want
#names in your columns
#otherwise use my_files as usual
#df.list <- lapply(fileListwithPath, read.csv)


#read csvs as data frames + add header
my_files <- lapply(file_list,function(x) {
  y <- read.csv(x,stringsAsFactors=FALSE, header = FALSE, sep = ',',
                col.names = c("well_1", "well_2", "well_3", "well_4", "well_5",
                              "well_6", "well_7", "well_8"))
  # uncomment next line to add a column that stores the file name
  #y$filename <- x
  y 
})

# Now we rename the List Names for use in worksheets...
# Remove .csv and sample_ prefix used in filenames...
# Result in workbook S<size>_<R version>_<date>
names(my_files) <- gsub("\\.csv$","", names(my_files))

#xlsx workbook----

# create workbook
wb <- createWorkbook()

#Iterate the same way as PavoDive, slightly different 
#(creating an anonymous function inside Map())
Map(function(data, nameofsheet){     
  
  addWorksheet(wb, nameofsheet)
  writeData(wb, nameofsheet, data)
  
}, my_files, names(my_files))

#export data----

## Save workbook to excel file 
saveWorkbook(wb, file = "all_csvs.xlsx", overwrite = TRUE)

