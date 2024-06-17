--1. Muestre el nombre del producto y el nombre su categoría para cada producto
SELECT p.ProductName, c.CategoryName
FROM [dbo].[Products] p
INNER JOIN Categories c
ON p.CategoryID = c.CategoryID


SELECT CONCAT (p.ProductName, ' ',c.CategoryName) AS JUNTOS
FROM [dbo].[Products] p
INNER JOIN Categories c
ON p.CategoryID = c.CategoryID

--2. Indicar el nombre del producto con la mayor cantidad de órdenes
SELECT TOP 1  p.ProductName, COUNT(od.Quantity) AS TOP1
FROM [dbo].[Products] p
INNER JOIN [dbo].[Order Details] od
ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY TOP1 DESC


SELECT p.ProductName, COUNT(*) AS Quantity
FROM [Order Details] od 
LEFT JOIN Products p ON p.ProductID = od.ProductID 
GROUP BY p.ProductName

-- where de los group bys
HAVING COUNT(*) = (
            --PRIMER SUB QUERY
            SELECT MAX(Quantity) 
            FROM (
            --SEGUNDO SUB QUERY
            SELECT COUNT(*) AS Quantity
            FROM [Order Details] od 
            LEFT JOIN Products p ON p.ProductID = od.ProductID 
            GROUP BY p.ProductName
            ) AS tUTIO
        ) 
--UNIR		
UNION



-- MINIMO

SELECT p.ProductName, COUNT(*) AS Quantity
FROM [Order Details] od 
LEFT JOIN Products p ON p.ProductID = od.ProductID 
GROUP BY p.ProductName
-- where de los group bys
HAVING COUNT(*) = (
            --PRIMER SUB QUERY
            SELECT MIN(Quantity) 
            FROM (
            --SEGUNDO SUB QUERY
            SELECT COUNT(*) AS Quantity
            FROM [Order Details] od 
            LEFT JOIN Products p ON p.ProductID = od.ProductID 
            GROUP BY p.ProductName
            ) AS tUTIO
        )

--3. Indicar la cantidad de órdenes atendidas por cada empleado (mostrar el nombre y apellido de cada empleado).
SELECT * FROM [dbo].[Employees]
SELECT * FROM [dbo].[Orders]

SELECT CONCAT(e.FirstName, ' ',e.LastName) AS Empleado, COUNT(*) AS Cantidad
FROM [dbo].[Orders] o
INNER JOIN [dbo].[Employees] e 
ON o.EmployeeID = e.EmployeeID
--metele todo
GROUP BY CONCAT(e.FirstName, ' ',e.LastName)
ORDER BY Cantidad DESC

--4. Indicar la cantidad de órdenes realizadas por cada cliente (mostrar el nombre de la compañía de cada cliente).
SELECT * FROM [dbo].[Orders]
SELECT * FROM [dbo].[Customers]

SELECT c.CompanyName , COUNT(*) AS TotalOrdenes
FROM Customers c
INNER JOIN Orders o
ON c.CustomerID = o.CustomerID
GROUP BY C.CompanyName

--5. Identificar la relación de clientes (nombre de compañía) que no han realizado pedidos
SELECT * FROM [dbo].[Orders]
SELECT * FROM [dbo].[Customers]

SELECT c.CompanyName 
FROM Customers c
LEFT JOIN Orders o
ON c.CustomerID = o.CustomerID
WHERE o.CustomerID is NULL


--6. Muestre el código y nombre de todos los clientes (nombre de compañía) que tienen órdenes pendientes de despachar
SELECT * FROM [dbo].[Orders]
SELECT * FROM [dbo].[Customers]

SELECT c.CustomerID, c.CompanyName
FROM [dbo].[Customers] c
INNER JOIN Orders o
ON c.CustomerID = o.CustomerID
WHERE o.ShippedDate IS NULL
ORDER BY c.CompanyName ASC

--7. Muestre el código y nombre de todos los clientes (nombre de compañía) que tienen órdenes pendientes de despachar, y la cantidad de órdenes con esa característica.
SELECT * FROM [dbo].[Orders]
SELECT * FROM [dbo].[Customers]

SELECT c.CustomerID, c.CompanyName, COUNT(*) AS TOTAL
FROM [dbo].[Customers] c
INNER JOIN Orders o
ON c.CustomerID = o.CustomerID
WHERE o.ShippedDate IS NULL
GROUP BY c.CustomerID, c.CompanyName
ORDER BY TOTAL DESC


/*8. Encontrar los pedidos que debieron despacharse a una ciudad o código postal diferente de la ciudad o código postal del cliente que los solicitó. 
	Para estos pedidos, mostrar el país, ciudad y código postal del destinatario, así como la cantidad total de pedidos por cada destino*/
SELECT * FROM [dbo].[Orders]
SELECT * FROM [dbo].[Customers]

SELECT c.Country, c.City, c.PostalCode, COUNT(o.OrderID) AS Total
FROM Customers c
INNER JOIN Orders o
ON c.CustomerID = o.CustomerID
WHERE c.City <> o.ShipCity OR c.PostalCode <> o.ShipPostalCode
GROUP BY c.Country, c.City, c.PostalCode
 


/*9. Seleccionar todas las compañías de envío (código y nombre) que hayan efectuado algún despacho a
	México entre el primero de enero y el 28 de febrero de 2018.
	Formatos sugeridos a emplear para fechas:
	• Formatos numéricos de fecha (por ejemplo, '15/4/2018')
	• Formatos de cadenas sin separar (por ejemplo, '20181207')*/
--STORAGE PROCEDURE
ALTER PROCEDURE pedidoFecha
@f1 date,
@f2 date,
@Country varchar(50)
AS

SELECT DISTINCT s.ShipperID, s.CompanyName FROM [dbo].[Shippers] s
INNER JOIN [dbo].[Orders] o ON s.ShipperID = o.ShipVia
WHERE o.OrderDate BETWEEN @f1 AND @f2 AND o.ShipCountry = @Country


EXEC pedidoFecha '2018-01-01','2018-02-28','Mexico' 

--10. Mostrar los nombres y apellidos de los empleados junto con los nombres y apellidos de sus respectivos jefes
SELECT * FROM [dbo].[Employees]
SELECT * FROM [dbo].[Employees]

SELECT e1.EmployeeID, e1.FirstName, e1.LastName, e1.ReportsTo, e2.FirstName, e2.LastName
FROM Employees e2
RIGHT JOIN Employees e1
ON e1.ReportsTo = e2.EmployeeID

--11. Mostrar el ranking de venta anual por país de origen del empleado, tomando como base la fecha de las órdenes, y mostrando el resultado por año y venta total (descendente). 
SELECT * FROM [dbo].[Order Details]
SELECT * FROM [dbo].[Orders]
SELECT * FROM [dbo].[Employees]

SELECT e.Country, YEAR(o.OrderDate) AS AÑO, SUM((od.UnitPrice-(od.UnitPrice*od.Discount))*od.Quantity) AS TOTAL
FROM Orders o
INNER JOIN [dbo].[Order Details] od
ON o.OrderID = od.OrderID
INNER  JOIN Employees e
ON o.EmployeeID = e.EmployeeID
GROUP BY e.Country, YEAR(o.OrderDate) 
ORDER BY TOTAL DESC

/*12. Mostrar de la tabla Orders, para los pedidos cuya diferencia entre la fecha de despacho y la fecha de la orden sea mayor a 4 semanas, las siguientes columnas:
	  OrderId, CustomerId, Orderdate, Shippeddate, diferencia en días, diferencia en semanas y diferencia en meses entre ambas fechas.*/
SELECT o.OrderID, o.CustomerID, o.CustomerID, o.ShippedDate, DATEDIFF(DAY, o.OrderDate, o.ShippedDate) AS DifDias,DATEDIFF(WEEK, o.OrderDate, o.ShippedDate) AS DifSem, DATEDIFF(MONTH, o.OrderDate, o.ShippedDate) AS DifMes   FROM Orders o
WHERE DATEDIFF(WEEK, o.OrderDate, o.ShippedDate) > 4

/*13. La empresa tiene como política otorgar a los jefes una comisión del 0.5% sobre la venta de sus subordinados. 
	Calcule la comisión mensual que le ha correspondido a cada jefe por cada año (basándose en la fecha de la orden) 
	según las ventas que figuran en la base de datos. Muestre el código del jefe, su apellido, el año y mes de cálculo, el monto acumulado de venta de sus subordinados, y la comisión obtenida.*/
SELECT * FROM [dbo].[Employees]
SELECT * FROM [dbo].[Orders]
SELECT * FROM [dbo].[Order Details]




/*14. Obtener los países donde el importe total anual de las órdenes enviadas supera los $45,000. Para determinar el año, tome como base la fecha de la orden (orderdate). 
	Ordene el resultado monto total de venta. Muestre el país, el año, y el importe anual de venta.*/
SELECT * FROM [dbo].[Orders]
SELECT * FROM [dbo].[Order Details]

SELECT o.ShipCountry, YEAR(o.OrderDate) AS AÑO, SUM((od.UnitPrice-(od.UnitPrice*od.Discount))*od.Quantity) AS TOTAL
FROM Orders o
INNER JOIN [Order Details] od
ON o.OrderID=od.OrderID
GROUP BY o.ShipCountry, YEAR(o.OrderDate)
HAVING SUM((od.UnitPrice-(od.UnitPrice*od.Discount))*od.Quantity) > 45001

/*15. De cada producto que haya tenido venta en por lo menos 20 transacciones (ordenes) del año 2017 mostrar el código, nombre y cantidad de 
	unidades vendidas y cantidad de ordenes en las que se vendió.*/
SELECT * FROM [dbo].[Order Details]
SELECT * FROM Orders
SELECT * FROM [dbo].[Products]

SELECT p.ProductID, p.ProductName, SUM(od.Quantity) AS UnVen, COUNT(od.OrderID) AS CantOrd
FROM [Order Details] od
INNER JOIN Products p
ON od.ProductID = p.ProductID
INNER JOIN Orders o
ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = 2017
GROUP BY p.ProductID, p.ProductName
HAVING COUNT(od.OrderID) > 20 

/*16. Determinar si existe algún problema de stock para la atención de las órdenes pendientes de despacho. Para ello, determinar la relación de productos no descontinuados 
cuyo stock actual (unitsinstock) es menor que la cantidad de unidades pendientes de despacho (as que figuran en pedidos que no han sido despachados).
Mostrar el nombre del producto, la cantidad pendiente de entrega, el stock actual y la cantidad de unidades que falta para la atención de las órdenes.*/
SELECT * FROM [dbo].[Products]
SELECT * FROM [dbo].[Orders]
SELECT * FROM [dbo].[Order Details]
