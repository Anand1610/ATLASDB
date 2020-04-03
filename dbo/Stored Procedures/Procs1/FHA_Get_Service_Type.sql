CREATE PROCEDURE [dbo].[FHA_Get_Service_Type]
AS
BEGIN
	SELECT ServiceType_ID,ServiceType FROM TBLSERVICETYPE
	Order By ServiceType ASC
END

