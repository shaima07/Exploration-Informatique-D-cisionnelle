/* 1 Liste des clients (customer description) qui ont passé des commandes en 2013*/
SELECT DISTINCT c.Customer AS Customer_Description
FROM [WideWorldImportersDW].[Fact].[Order] o
JOIN [WideWorldImportersDW].[Dimension].[Customer] c ON o.[Customer Key] = c.[Customer Key]
WHERE YEAR(o.[Order Date Key]) = 2013

/* 2 Les 10 meilleurs Salespersons (full name) en nombre de commandes*/
SELECT TOP 10 e.Employee, COUNT(*) AS Nombre_Commandes
FROM [WideWorldImportersDW].[Fact].[Order] o
JOIN [WideWorldImportersDW].[Dimension].[Employee] e ON o.[Salesperson Key] = e.[Employee Key]
GROUP BY e.Employee
ORDER BY COUNT(*) DESC

/* 3 Les 5 Salespersons les moins performants (full name) en Montant (Total excluding Tax)*/
SELECT TOP 5 e.Employee AS Full_Name, SUM(o.[Total Excluding Tax]) AS Montant_Total
FROM [WideWorldImportersDW].[Fact].[Order] o
JOIN [WideWorldImportersDW].[Dimension].[Employee] e ON o.[Salesperson Key] = e.[Employee Key]
GROUP BY e.Employee
ORDER BY SUM(o.[Total Excluding Tax]) ASC

/* 4 Nombre de commandes par state province*/
SELECT c.[State Province] AS State_Province, COUNT(*) AS Nombre_Commandes
FROM [WideWorldImportersDW].[Fact].[Order] o
JOIN [WideWorldImportersDW].[Dimension].[City] c ON o.[City Key] = c.[City Key]
GROUP BY c.[State Province]

/* 5 Total Excluding Taxes par City - Sales Person*/
SELECT c.City, o.[Salesperson Key] AS Sales_Person, SUM(o.[Total Excluding Tax]) AS Montant_Total_Excl_Taxes
FROM [WideWorldImportersDW].[Fact].[Order] o
JOIN [WideWorldImportersDW].[Dimension].[City] c ON o.[City Key] = c.[City Key]
GROUP BY c.City, o.[Salesperson Key]


/* 6 Afficher les articles commandées - Total Excluding Taxes pour les commandes passées à partir de la city "Nahant"-- Méthode 1*/
SELECT s.[Stock Item] AS Article, o.[Total Excluding Tax] AS Montant_Total_Excl_Taxes
FROM [WideWorldImportersDW].[Fact].[Order] o
JOIN [WideWorldImportersDW].[Dimension].[City] c ON o.[City Key]= c.[City Key]
JOIN [WideWorldImportersDW].[Dimension].[Stock Item] s ON o.[Stock Item Key] = s.[Stock Item Key]
WHERE c.City = 'Nahant'


/* 7 Afficher les articles commandées - Total Excluding Taxes pour les commandes passées à partir de la city "Nahant" -- Méthode 2*/
CREATE VIEW v AS 
SELECT [City Key] FROM [WideWorldImportersDW].[Dimension].[City] WHERE City ='Nahant';

SELECT  s.[Stock Item] AS Article, o.[Total Excluding Tax] AS Montant_Total_Excl_Taxes
FROM [WideWorldImportersDW].[Fact].[Order] o
JOIN [WideWorldImportersDW].[Dimension].[Stock Item] s ON o.[Stock Item Key] = s.[Stock Item Key]
join v on o.[City Key]= v.[City Key]









/* 8 Pour chaque article commandé en 2013, afficher le numéro de la première commande de l'année*/

SELECT [Stock Item Key] AS Article, MIN([Order Key]) AS Numero_Premiere_Commande
FROM [WideWorldImportersDW].[Fact].[Order] 
WHERE YEAR([Order Date Key]) = 2013
GROUP BY [Stock Item Key]










