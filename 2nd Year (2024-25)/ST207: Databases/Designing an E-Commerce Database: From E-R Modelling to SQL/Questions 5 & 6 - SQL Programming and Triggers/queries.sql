-- QUESTION 5: SQL STATEMENTS -- 

-- QUESTION 5.1 --
SELECT c.Customer_ID, c.Name, c.Email_Address, co.Order_Number, co.Date, co.Grand_Total,
  -- ChatGPT for GROUP_CONCAT() AS
  GROUP_CONCAT(op.Product_Number, ', ') AS Product_Numbers, 
  GROUP_CONCAT(op.Product_Subtotal, ', ') AS Product_Subtotals,
  GROUP_CONCAT(p.Product_Name, ', ') AS Product_Names
FROM CUSTOMER AS c LEFT JOIN CUSTOMER_ORDER AS co ON c.Customer_ID = co.Customer_ID
LEFT JOIN ORDERED_PRODUCT AS op ON co.Order_Number = op.Order_Number
LEFT JOIN PRODUCT AS p ON op.Product_Number = p.Product_Number
GROUP BY c.Customer_ID, co.Order_Number
ORDER BY c.Customer_ID ASC, co.Date ASC;

-- QUESTION 5.2 --
SELECT c.Customer_ID, c.Name, c.Email_Address, c.Date_of_Birth, vgc.Current_Balance,
	GROUP_CONCAT(a.Product_Number, ', ') AS Product_Numbers
FROM CUSTOMER as c JOIN BASKET as b ON c.Customer_ID = b.Customer_ID
JOIN ADDED_TO as a ON b.Basket_ID = a.Basket_ID
LEFT JOIN PAYMENT_METHOD as pm ON c.Customer_ID = pm.Customer_ID 
LEFT JOIN VOUCHER_GIFTCARD as vgc ON pm.SerialCard_Number = vgc.SerialCard_Number
GROUP BY c.Customer_ID
ORDER BY c.Customer_ID ASC;

-- QUESTION 5.3 --
WITH RankedProducts AS (
    SELECT p.Category, p.Product_Name, p.Product_Number, 
        SUM(op.Num_Ordered * p.Price) AS Total_Sales,
        ROW_NUMBER() OVER (PARTITION BY p.Category ORDER BY SUM(op.Num_Ordered * p.Price) DESC) AS RowNum -- ChatGPT
    FROM PRODUCT AS p JOIN ORDERED_PRODUCT AS op ON p.Product_Number = op.Product_Number
    GROUP BY p.Category, p.Product_Name, p.Product_Number
)
SELECT *
FROM RankedProducts
WHERE RowNum <= 2
ORDER BY Category, RowNum;

-- QUESTION 5.4 --
-- MonthlySales VIEW
CREATE VIEW MonthlySalesView AS
SELECT strftime('%Y', co.Date) AS Year, strftime('%m', co.Date) AS Month,
  SUM(
    CASE
      WHEN d.Status != 'cancelled' AND (r.Status IS NULL OR r.Status != 'completed')
      THEN op.Num_Ordered * p.Price
      ELSE 0
    END
  ) AS Total_Sales
FROM ORDERED_PRODUCT AS op 
JOIN PRODUCT AS p ON op.Product_Number = p.Product_Number
JOIN CUSTOMER_ORDER AS co ON op.Order_Number = co.Order_Number
LEFT JOIN DELIVERY AS d ON co.Order_Number = d.Order_Number
LEFT JOIN RETURN AS r ON co.Order_Number = r.Order_Number
GROUP BY Year, Month
ORDER BY Year, Month

SELECT *, 
  -- using ChatGPT for LAG functions for Percentage_Change
  CASE 
    WHEN LAG(Total_Sales, 1, 0) OVER (ORDER BY Year, Month) != 0
    THEN 
      (Total_Sales - LAG(Total_Sales, 1, 0) OVER (ORDER BY Year, Month)) 
      / LAG(Total_Sales, 1, 0) OVER (ORDER BY Year, Month) * 100
    ELSE 0
  END AS Percentage_Change
FROM MonthlySalesView
ORDER BY Year, Month;

-- QUESTION 6 --
-- Trigger (iii) Customer Tries to Open a New Return When They Already Have a Pending Return
CREATE TRIGGER MultipleReturnRequests
BEFORE INSERT ON RETURN
FOR EACH ROW
BEGIN
    SELECT CASE 
        WHEN EXISTS (
            -- ChatGPT for SELECT, LIMIT
            SELECT 1
            FROM CUSTOMER_ORDER AS co JOIN RETURN AS r ON co.Order_Number = r.Order_Number
            WHERE co.Customer_ID = (SELECT Customer_ID FROM CUSTOMER_ORDER WHERE Order_Number = NEW.Order_Number)
            AND r.Status = 'pending' OR r.Status = 'denied'
            LIMIT 1
        )
        THEN RAISE (ABORT, 'ERROR: customer already has a pending return for this order.')
    END;
END;

-- (i) A Query That Passes the Trigger (i.e., normal situation, no errors)
INSERT INTO RETURN (Ticket_Number, Order_Number, Start_Date, Due_Date, Refund_Total, Status)
VALUES ('8778dcb2-062c-4e42-a18e-40beb4ae5df0', 56488, 2024-05-23, 2024-06-22, 9845.00, 'pending');

-- (ii) A Query That Violates Any Condition and “Fires” the Trigger (i.e. generates error message)
INSERT INTO RETURN (Ticket_Number, Order_Number, Start_Date, Due_Date, Refund_Total, Status)
VALUES ('8ca10897-28c8-4884-afb0-44a501ee37ca', 71493, 2024-01-09, 2024-02-08, 27625.00, 'denied');