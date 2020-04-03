CREATE PROCEDURE [dbo].[LCJ_DDL_Transfer_To]
as
SELECT   
attorney_Id,
attorney_firstname + ' ' + attorney_lastname as Attorney_Name
FROM tblattorney
WHERE (1 = 1 ) ORDER BY attorney_firstname ASC

