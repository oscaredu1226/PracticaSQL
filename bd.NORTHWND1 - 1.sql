--1. Listar los nombres de los productos cuyo precio unitario sea mayor a 18 pero menor a 100, mostrando primero los productos de mayor precio
SELECT * FROM [dbo].[Products]
SELECT ProductName, UnitPrice AS PECIO FROM [dbo].[Products]
WHERE UnitPrice >18 AND UnitPrice <100
ORDER BY UnitPrice DESC

--2. Indicar los países de procedencia de los clientes
SELECT * FROM [dbo].[Customers]
SELECT CompanyName, Country FROM [dbo].[Customers]

--3. Indicar los nombres de los clientes que no sean de los siguientes países de Francia, Brasil y México
SELECT * FROM [dbo].[Customers]
SELECT CompanyName, Country FROM [dbo].[Customers]
WHERE Country != 'France' AND Country != 'Brasil' AND Country != 'Mexico'

--4. Indicar los nombres de clientes que comiencen con la letra L o la letra M
SELECT * FROM [dbo].[Customers]
SELECT CompanyName FROM [dbo].[Customers]
WHERE CompanyName LIKE 'L%' OR CompanyName LIKE 'M%'

--5. Indicar la cantidad de clientes
SELECT * FROM [dbo].[Customers]
SELECT COUNT (*) AS TotalClientes FROM [dbo].[Customers]

--6. Indicar el mayor precio unitario de los productos
SELECT * FROM [dbo].[Products]
SELECT ProductName, UnitPrice AS PrecioMax FROM [dbo].[Products]
WHERE UnitPrice = (SELECT MAX (UnitPrice) FROM [dbo].[Products])

--7. Indicar el menor precio unitario de los productos
SELECT * FROM [dbo].[Products]
SELECT ProductName, UnitPrice AS PrecioMin FROM [dbo].[Products]
WHERE UnitPrice = (SELECT MIN(UnitPrice) FROM [dbo].[Products])

--8. Indicar la cantidad de países distintos de procedencia de los clientes
SELECT * FROM [dbo].[Customers]
SELECT COUNT(DISTINCT Country) AS CantidadPaises FROM [dbo].[Customers]

--9. Indicar la cantidad de clientes cuya procedencia sea Alemania
SELECT * FROM [dbo].[Customers]
SELECT COUNT(*) AS CantidadAlemania FROM [dbo].[Customers]
WHERE Country = 'Germany'

--10. Indicar la cantidad de clientes por país de procedencia
SELECT * FROM [dbo].[Customers]
SELECT Country, COUNT(*) AS ClientePorPais FROM [dbo].[Customers]
GROUP BY Country

--11. Indicar la cantidad de productos de acuerdo a su discontinuidad
SELECT * FROM [dbo].[Products] 
SELECT ProductName, Discontinued FROM [dbo].[Products] 
WHERE Discontinued = 1

--12. Indicar los países de procedencia que superen los cinco clientes
SELECT * FROM [dbo].[Customers]
SELECT Country, COUNT(*) AS ClientePorPais FROM [dbo].[Customers]
GROUP BY Country HAVING COUNT(*) > 5

--13. Indicar el nombre del producto con mayor precio
SELECT * FROM [dbo].[Products]
SELECT ProductName, UnitPrice AS PrecioMax FROM [dbo].[Products]
WHERE UnitPrice = (SELECT MAX (UnitPrice) FROM [dbo].[Products])

--14. Indicar el nombre del país con la mayor cantidad de clientes
SELECT * FROM [dbo].[Customers]
SELECT TOP 1 Country, COUNT(*) AS ClientePorPaisMax FROM [dbo].[Customers]
GROUP BY Country ORDER BY COUNT(*)  DESC
