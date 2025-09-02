## **Analysing Indian Flight Data - Data Analysis Project**

### **Project Description**

In this project I analysed indian flight data from Kaggle to identify patterns, Trends, and key drivers of ticket price. The Analysis follows the complete data Analytics workflow - from data cleaning, to exploratory data Analysis with SQL and Power BI visualisation.


### **Goals**

- Give an overview of the data - cities, Airlines, classes, number of flights and the average price of the tickets.
- identify Trends and patterns - the most popular airline, the most chosen class, the most popular route, identify time-based pricing trends, most popular departure time
- Compare airlines based on average price, flight Duration, classes, number of flights and number of stops
- Understand the facotrs influencing ticket prices - airline, class, stops, time of departure and routes


### **Dataset:**

Kaggle - https://www.kaggle.com/datasets/rohitgrewal/airlines-flights-data

### **Tech Stack:**

- Excel - Data Cleaning

- MySQL - Data Cleaning and Exploratory Data Analysis

- Power BI - Data Visualisation

### **Process:**



#### 1. **Data Cleaning - Excel**

   The dataset was provided as a raw CSV file. I performed several cleaning steps in Excel before importing the data into MySQL:
   1.1. Converted the CSV file into a structured table
   1.2. Checked spelling and formatting - e.g. in the "airline" column, spaces were replaced with underscores and then standardized it back to spaces.
   1.3. Adjusted data types - e.g. converted "duration" from text to numberic values.
   1.4. Checked for duplicates - None were found.
   1.5. Checked for missing values - None were found.
   1.6. created new columns:
- extracted "flight\_code" (e.g. from "SG-8709" -> "SG")
- extracted "flight\_number" (e.g. from "SG-8709" -> "8709")

   1.7. Investigated flight\_codes:
- Used Pivot tables to analyse which airlines used which codes.
- Found an inconsistency: Indigo was linked to three different flight\_codes.
- Determined the correct one (6E) by frequency Analysis (the most common code).
- Added a Validation column with an IF-function to check whether airline and flight\_code match (Output "stimmt" if it matches or "stimmt nicht" if it does not match).

**RESULT:** A clean, consistent dataset Ready for SQL Analysis

   
#### 2. **Data Cleaning - MySQL**

   1. removing columns that are not necessary for the data Analysis:
- flight\_code
- flight\_number
- flight\_code\_test
- id
- flight

   
#### 3. **Data Analysis - MySQL**
   I explored the dataset wit MySQL queries to answer key Business Questions.

   **Highlights:**
- Vistara has the largest market share (42.6%), followed by Air India (26.9%).
- the most popular route is Mumbai <-> Delhi, followed by Delhi <-> Bangalore
- Economy class is Chosen by around 69% of passengers (economy class is cheaper and more available)
- Non-stop flights are around 6-8x faster than flights with stops
- AirAsia offers the lowest average ticket price (4.091,07), while Visara is the most expensive (123.071,00)

   
#### 4. **Visualisation - Power BI**

The final step of this Project was creating interactive dashboards in Power BI to visualize the results of the Analysis.

**Dashboards:**

1. Overview Dashboard - get to know the data

	- Shows all the cities on a map, airlines and classes

	- it Shows the average price and average duration of flight

	- two visualisations showing the most popular airlines (the most flights), highlighting the most popular airline and the average price of each airline, highlighting the cheapest airline

2. Trends Dashboard - all About patterns and trends

	- Shows the number of flights of each airline seperated into classes - only the two most popular airlines offer business class

	- the top 10 most popular routes - Mumbai <-> Delhi being the most popular

	- ticket-price development by days left before departure - the prices tend to decrease when booked earlier.

	- the most popular time of departure - Morning and Early Morning being the most common time of departure

3. Airline Comparison Dashboard

	- showing the average duration and average ticket price of each airline, and above showing the overall average duration of flight and average price - AirAsia is the cheapest, while Vistara is 			  the most expensive, Air India takes the longest on average, while Indigo takes the shortest

	- the amount of stops each airline takes, above it showing the overall amount of stops - one-stop-flights are the most common amongst the airlines, followed by zero-stops-flights, flights with 		  at least two stops are less common

	- airlines and classes to choose from for better comparison



4. Price Dashboard

	- showing the average price of business- and economy-class - economy-class is around 7-8x cheaper than business-class

	- showing the average price of each time of departure - the tickets tend to be more expensive at night, while it tends to be the cheapest in the late night.

	- showing the average price of one-stop-, zero-stops- and two-or-more-stops-flights - most expensive are the one-stop-flights, the cheapest are the zero-stop-flights

	- an interactive visual that can be switched from the top 5 cheapest routes to the top 5 most expensive routes by clicking the button - Hyderabad <-> Delhi is the cheapest route, while Chennai 		  <-> Bangalore is the most expensive route