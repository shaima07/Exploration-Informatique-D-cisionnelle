/* 1 Nombre de state province */
select COUNT(DISTINCT[State Province]) as NumberOfStateProvinces
FROM [WideWorldImportersDW].[Dimension].[City]

/* 2 State province ayant le moins de nombre de cities*/
SELECT TOP 1 [State Province],COUNT(city) as NumberOfCity
  FROM [WideWorldImportersDW].[Dimension].[City]
  group by [State Province]
  having [State Province] <> 'N/A'
  order by NumberOfCity ASC

  /* 3 Top 5 des states province par population */
  SELECT TOP 5 [State Province], sum([Latest Recorded Population]) as ProvincePopulation
  FROM [WideWorldImportersDW].[Dimension].[City]
  group by [State Province]
  order by ProvincePopulation DESC

  /* 4 Nombre d'articles par couleur */
  select [color], count(*) as ArticleCount
  FROM [WideWorldImportersDW].[Dimension].[Stock Item]
  group by Color

  /* 5 Nombre d'employés */
  select count(distinct(Employee)) as EmployeeCount
  FROM [WideWorldImportersDW].[Dimension].[Employee]

  /* 6 Nombre d'employés qui ne sont plus valides ordonnés par WWI Id */
  select count(distinct(Employee)) as InactiveEmployeeCount
  FROM [WideWorldImportersDW].[Dimension].[Employee]
  where GETDATE() > [Valid To]

  /* 7 Liste des articles présents plus qu'une fois (mentionner le nombre d'occurrences) */
  select [Stock Item], count(*) as occurrences
  FROM [WideWorldImportersDW].[Dimension].[Stock Item]
  group by [Stock Item]
  having count(*)>1

  /* 8 Liste des articles avec un prix unitaire inférieur ou égal à 20 */
  select [Stock Item], [Unit Price]
  FROM [WideWorldImportersDW].[Dimension].[Stock Item]
  where [Unit Price] <= 20

  /* 9 Liste des codes postaux où on a plus qu'un client */
  select [Postal Code], count(*) as ClientCount
  FROM [WideWorldImportersDW].[Dimension].[Customer]
  group by [Postal Code]
  having Count(*) >1

  /* 10 Liste des clients avec un nom et un prénom qui commencent par la même lettre */
  select [Customer]
  FROM [WideWorldImportersDW].[Dimension].[Customer]
  where SUBSTRING([Customer], 1, 1) = SUBSTRING([Customer], CHARINDEX(' ', [Customer]) + 1, 1)

  /* 11 Nombre de commandes */
  select count(*) as NumberOrder
  FROM [WideWorldImportersDW].[Fact].[Order]

  /* 12 Nombre de commandes par année */
  select YEAR([Order Date Key]) as annee, count(*) as NumberOrder
  FROM [WideWorldImportersDW].[Fact].[Order]
  group by YEAR([Order Date Key])

  /* 13 Nombre de commandes réparties avec / sans client (customer key) */
  select 
	case
		when [Customer Key] = 0 then 'sans client'
		else 'avec client'
		end as Avec_Sans_Client,
		count(*) as NumberOrder
  FROM [WideWorldImportersDW].[Fact].[Order]
  group by 
			case
				when [Customer Key] = 0 then 'sans client'
				else 'avec client'
			end

  /* 14 Les top 5 pickers qui ont préparé des commandes avec le nombre de commandes pour chacun */
  select top 5 [Picker Key], count(*) as NumberOrder
  FROM [WideWorldImportersDW].[Fact].[Order]
  group by [Picker Key]
  order by NumberOrder desc

  /* 15 Le montant total des commandes passées durant le premier trimestre de 2016 (Total Excluding Tax) */
  select sum([Total Excluding Tax]) as MontantTotal
  FROM [WideWorldImportersDW].[Fact].[Order]
  where [Order Date Key]>= '2016-01-01' and [Order Date Key] < '2016-04-01'

  /* 16 L'article le plus commandés en 2014 */
  select top 1 [Stock Item Key], count(*) as NumberOrder
  FROM [WideWorldImportersDW].[Fact].[Order]
  where [Order Date Key]>= '2014-01-01' and [Order Date Key] < '2015-01-01'
  group by [Stock Item Key]
  order by NumberOrder desc

/* 17 Top 8 des articles les plus commandés en 2016 (Total Excluding Tax) */
	SELECT TOP 8 [Stock Item Key], sum([Total Excluding Tax]) AS Total_Commandes
	FROM [WideWorldImportersDW].[Fact].[Order]
	WHERE [Order Date Key]>= '2016-01-01' and [Order Date Key] < '2017-01-01'
	GROUP BY [Stock Item Key]
	ORDER BY Total_Commandes DESC

/* 18 Mois et année avec le plus grand nombre de commandes */
	SELECT top 1 DATEPART(month,[Order Date Key]) AS Mois, DATEPART(year, [Order Date Key]) AS Annee, COUNT(*) AS Nombre_Commandes
	FROM [WideWorldImportersDW].[Fact].[Order]
	GROUP BY DATEPART(month, [Order Date Key]), DATEPART(year, [Order Date Key])
	ORDER BY COUNT(*) DESC

/* 19 Nombre de commandes ayant une [Order Date Key] différente de [Picked Date Key] */
	SELECT COUNT(*) AS nombre_commandes_differentes
	FROM [WideWorldImportersDW].[Fact].[Order]
	WHERE [Order Date Key] <> [Picked Date Key]

/* 20 Total Excluding Tax moyen par commande par mois pour l'année 2014 */
	SELECT MONTH([Order Date Key]) AS Mois, AVG([Total Excluding Tax]) AS Moyenne_Total
	FROM [WideWorldImportersDW].[Fact].[Order]
	WHERE YEAR([Order Date Key]) = 2014
	GROUP BY MONTH([Order Date Key])


