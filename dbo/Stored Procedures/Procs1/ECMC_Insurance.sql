CREATE PROCEDURE [dbo].[ECMC_Insurance]
AS
BEGIN
	SELECT '------'[Code],'---SELECT---'[Desc]
	UNION
	SELECT distinct Insurance[Code],Insurance[Desc] from ECMC WHERE Insurance is not null
	ORDER BY 1
END

