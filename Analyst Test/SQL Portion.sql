--create a table to store the Excel data, make sure to save the Excel sheet as an .csv
CREATE TABLE ClientData (
    ClientID INT, --use INT as integers are better for whole number values
    ClientState VARCHAR(2),
    DOB DATE,
    FirstProviderID INT,
    CurrentProviderID INT,
    NumSessions INT,
    SwitchedProvider INT,
    StartDate DATE,
    SecondSession DATE,
    LatestDate DATE,
    DaysRetained INT,
    PrimaryInsurancePlan VARCHAR(255),
    SecondaryInsurancePlan VARCHAR(255),
    ClientStatus VARCHAR(255),
    Age INT,
    Gender VARCHAR(6)
);

--take initial look at data, Note: data has issues after PrimaryInsurancePlan
SELECT * FROM Darren_DB.ClientData;

/*
2. Identify the clients that make up the majority of sessions
First look at the avg number of sessions, then look at the median and mode ; 10.71, 6, and 1 respectively w/ Excel
Alternatively we could base this around the Pareto Principle:
    using the 80 20 rule we find define the cut off point for top clients to be less than 16 sessions
*/
--How many top clients? 
SELECT * FROM Darren_DB.ClientData
WHERE NumSessions >= 16
ORDER BY NumSessions DESC;
--419 top clients

--get a count of clientstates
SELECT ClientState, COUNT(ClientState) AS ClientCount FROM Darren_DB.ClientData
WHERE NumSessions >= 16
GROUP BY ClientState
ORDER BY ClientCount DESC;
--appears Fl followed by TX are the most prevalent states for our top clients

--get a count of First Providers
SELECT FirstProviderID, COUNT(FirstProviderID) AS ProCount FROM Darren_DB.ClientData
WHERE NumSessions >= 16
GROUP BY FirstProviderID
ORDER BY ProCount DESC;
--appears 16102,51493,32085,61453,64201,88200,18864,98817 are top providers

--get count of Current Providers
SELECT CurrentProviderID, COUNT(CurrentProviderID) AS ProCount FROM Darren_DB.ClientData
WHERE NumSessions >= 16
GROUP BY CurrentProviderID
ORDER BY ProCount DESC;
--16102,51493,61453,32085,64201,18864,12388 are top current providers. Pattern of these providers being top performers

--get a count of first providers where there clients are still active
SELECT FirstProviderID, COUNT(FirstProviderID) AS ProCount FROM Darren_DB.ClientData
WHERE NumSessions >= 16
AND ClientStatus = "Active"
GROUP BY FirstProviderID
ORDER BY ProCount DESC;
--16102,51493,61453,32085,64201

--get count of Current Providers where there clients are still active
SELECT CurrentProviderID, COUNT(CurrentProviderID) AS ProCount FROM Darren_DB.ClientData
WHERE NumSessions >= 16
AND ClientStatus = "Active"
GROUP BY CurrentProviderID
ORDER BY ProCount DESC;
--16102,51493,61453,32085,64201

--which providers get switched
SELECT FirstProviderID, COUNT(FirstProviderID) AS ProCount FROM Darren_DB.ClientData
WHERE NumSessions >= 16
AND SwitchedProvider > 0
GROUP BY FirstProviderID
ORDER BY ProCount DESC;
--appears 13766,32085,77401,17026,95568 are top switched

--what do they get switched to?
SELECT CurrentProviderID, COUNT(CurrentProviderID) AS ProCount FROM Darren_DB.ClientData
WHERE NumSessions >= 16
AND SwitchedProvider > 0
GROUP BY CurrentProviderID
ORDER BY ProCount DESC;
--16102,95568,90473,51493,12388 are current providers for those who switched. Note: 16102 and 51493 were top performers, 95568 both top switched and switched to

--analyze prevalence of Primary Insurance Plan
SELECT PrimaryInsurancePlan, COUNT(PrimaryInsurancePlan) PlanCount FROM Darren_DB.ClientData
WHERE NumSessions >= 16
GROUP BY PrimaryInsurancePlan
ORDER BY PlanCount DESC;
--most common Medicare Florida

--compare to all clients
SELECT PrimaryInsurancePlan, COUNT(PrimaryInsurancePlan) PlanCount FROM Darren_DB.ClientData
GROUP BY PrimaryInsurancePlan
ORDER BY PlanCount DESC;

--analyze prevalence of Secondary Insurance Plan
SELECT SecondaryInsurancePlan, COUNT(SecondaryInsurancePlan) PlanCount FROM Darren_DB.ClientData
WHERE NumSessions >= 16
GROUP BY SecondaryInsurancePlan
ORDER BY PlanCount DESC;
--most don't have one, second most popular is AARP

--analyze prevalence of Secondary Insurance Plan all clients
SELECT SecondaryInsurancePlan, COUNT(SecondaryInsurancePlan) PlanCount FROM Darren_DB.ClientData
GROUP BY SecondaryInsurancePlan
ORDER BY PlanCount DESC;

--how many have Medicare Florida but no second insurance? Compare w those that have both insurances
SELECT * FROM Darren_DB.ClientData
WHERE NumSessions >= 16
AND PrimaryInsurancePlan = 'Medicare Florida'
AND SecondaryInsurancePlan NOT LIKE ''
ORDER BY NumSessions DESC;
--73
SELECT * FROM Darren_DB.ClientData
WHERE NumSessions >= 16
AND PrimaryInsurancePlan = 'Medicare Florida'
AND SecondaryInsurancePlan = ''
ORDER BY NumSessions DESC;
--8
SELECT * FROM Darren_DB.ClientData
WHERE NumSessions >= 16
AND PrimaryInsurancePlan LIKE '%'
AND SecondaryInsurancePlan LIKE '%'
AND PrimaryInsurancePlan NOT LIKE ''
AND SecondaryInsurancePlan NOT LIKE ''
ORDER BY NumSessions DESC;
--

--avg age of group
SELECT AVG(Age) FROM Darren_DB.ClientData
WHERE NumSessions >= 16;


/*
Look at clients w/ least sessions and their qualities
*/
SELECT * FROM Darren_DB.ClientData
WHERE NumSessions <= 1
ORDER BY DaysRetained;
--there are 248 clients

--avg days retained
SELECT AVG(DaysRetained) FROM Darren_DB.ClientData
WHERE NumSessions <= 1
ORDER BY DaysRetained;
--1.76days

--avg for top clients?
SELECT AVG(DaysRetained) FROM Darren_DB.ClientData
WHERE NumSessions >= 16
ORDER BY DaysRetained;

--look at the most common states
SELECT ClientState, COUNT(ClientState) AS ClientCount FROM Darren_DB.ClientData
WHERE NumSessions <= 2
AND DaysRetained = 0 --Note: some individuals actually stuck around for a short period
GROUP BY ClientState
ORDER BY ClientCount DESC;
--most prevalent state is FL, WA, NJ, CA, TX, PA

--look at avg age of these clients
SELECT AVG(Age) FROM Darren_DB.ClientData
WHERE NumSessions <= 2;
--the avg age is 69.77, about the same as top clients actually

--analyze prevalence of Primary Insurance Plan
SELECT PrimaryInsurancePlan, COUNT(PrimaryInsurancePlan) PlanCount FROM Darren_DB.ClientData
WHERE NumSessions <= 2
GROUP BY PrimaryInsurancePlan
ORDER BY PlanCount DESC;
--majority has Medicare [State] just like top patients

--get a count of First Providers
SELECT FirstProviderID, COUNT(FirstProviderID) AS ProCount FROM Darren_DB.ClientData
WHERE NumSessions <= 1
GROUP BY FirstProviderID
ORDER BY ProCount DESC;
