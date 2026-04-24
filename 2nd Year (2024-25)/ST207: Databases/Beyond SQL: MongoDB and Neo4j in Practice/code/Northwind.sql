-- 1 (b) List all product names and unit prices supplied by each company (supplier). Also, list the supplier's name.

    SELECT P.ProductName, P.UnitPrice, S.CompanyName
      FROM Product P
      JOIN Supplier S ON P.SupplierId = S.Id
  GROUP BY P.SupplierId
  ORDER BY 2 ASC;

-- 1 (c) List the category of the 10 top-seller products.

  SELECT CategoryName
    FROM Category C
    JOIN Product P ON C.Id = P.CategoryId
   WHERE P.Id IN
         (SELECT ProductId
            FROM OrderDetail
        ORDER BY (UnitPrice*Quantity) DESC
           LIMIT 10);

-- 1 (d) For each customer, list all products they bought.

    SELECT C.CompanyName, P.ProductName
      FROM Customer C
      JOIN [Order] O ON O.CustomerId = C.Id
      JOIN OrderDetail OD ON OD.OrderId = O.Id
      JOIN Product P ON OD.ProductId = P.Id
  GROUP BY C.Id;
