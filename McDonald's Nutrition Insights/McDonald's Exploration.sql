/*
My personal McDonald's Order Analytics
Used SQLite
The dataset was retrieved off Kaggle,
Consists of all items on the McDonald's menu as of 2021,
includes Calories, Calories from Fat, Total Fat, Saturated Fat, Trans Fat, Cholesterol, Sodium, Carbs, Fiber, Sugars, Protein, and Weight Watchers Points
My main objectives are to examine:
1. The nutrition facts of the typical menu items I order
2. What McDonalds options provide the most optimal ratio of carbs to protein for bulking?
3. Which McDonalds options to avoid as they contain highest amount of trans fat 
*/

/*
Problematic things I found and changed in file through Excel:
-adjusted first row b/c of strange Excel formatting issues
-comma deliminated yet there were commas in cells under "Items" column that would cause importing issues
*/

--first create a table for data under personal database, insert data into table(tools)
CREATE TABLE Darren_DB.McD_Nutrition (
Item TEXT, --can also use TEXT
Calories INTEGER, --INTEGER more efficient than using NUMERIC, therefore use when appropriate
"Calories From Fat" INTEGER,
"Total Fat" NUMERIC, --NUMERIC good choice for a wide range of applications due to its balance between precision and efficiency, others: DECIMAL, REAL
"Saturated Fat" NUMERIC,
"Trans Fat" NUMERIC,
Cholesterol INTEGER,
Sodium INTEGER,
Carbs NUMERIC,
Fiber NUMERIC,
Sugars NUMERIC,
Protein NUMERIC,
"Weight Watchers Points" NUMERIC
);

--Initial look at data, Note: Total fat, saturated fat, trans fat, carbs, fiber, sugar, protein all measured in grams(g). Cholesterol and sodium (mg)
SELECT * FROM Darren_DB.McD_Nutrition;

/*
My typical orders, let's look at the calories:
-Double Cheeseburger
-Big Mac®
-McChicken ®
-Sausage McMuffin® with Egg
-Medium French Fries
-Coca-Cola® Classic (Medium)
*/
SELECT * 
FROM Darren_DB.McD_Nutrition
WHERE Item IN ('Double Cheeseburger', 'Big Mac®', 'McChicken ®', 'Sausage McMuffin® with Egg', 'Medium French Fries', 'Coca-Cola® Classic (Medium)')
ORDER BY Calories;

--Now let's analyze the servings of carbs to protein to total fat and order based on optimal ratio of 5:3 carbs to protein
SELECT Item, Carbs, Protein, "Total Fat", ROUND(CAST (Carbs AS FLOAT) / CAST (Protein AS FLOAT), 2) AS Ratio --Use CAST("" AS FLOAT) since respective columns are integer values resulting in only integer outputs
FROM Darren_DB.McD_Nutrition
WHERE Item IN ('Double Cheeseburger', 'Big Mac®', 'McChicken ®', 'Sausage McMuffin® with Egg', 'Medium French Fries', 'Coca-Cola® Classic (Medium)')
AND Ratio IS NOT NULL
ORDER BY ABS(Ratio - (5.0/3.0)); --here we order at which item's carb to protein ratio has the smallest difference to ideal 5:3. Note: 5.0/3.0 is different from 5/3; floating-point and integer division respectively

--Let's extend this ratio to look at the whole menu, this time only showing options where total fat is also less than or equal to protein 
SELECT Item, Carbs, Protein, "Total Fat", ROUND(CAST (Carbs AS FLOAT) / CAST (Protein AS FLOAT), 2) AS Ratio
FROM Darren_DB.McD_Nutrition
WHERE "Total Fat" <= Protein
AND Ratio IS NOT NULL
ORDER BY ABS(Ratio - (5.0/3.0)); --Note: reminder again, 5.0/3.0 tells SQL that this is a case of floating-point division NOT integer division: 5/3 = 1

