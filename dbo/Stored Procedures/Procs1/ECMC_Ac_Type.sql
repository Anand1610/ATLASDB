CREATE PROCEDURE [dbo].[ECMC_Ac_Type]
AS
BEGIN
	SELECT '------'[Code],'---SELECT---'[Desc]
	UNION
	SELECT distinct [Account Type][Code],[Account Type][Desc] from ECMC WHERE [Account Type] is not null
	ORDER BY 1
END

