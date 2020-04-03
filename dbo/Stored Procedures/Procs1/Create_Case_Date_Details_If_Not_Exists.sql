CREATE PROCEDURE [dbo].[Create_Case_Date_Details_If_Not_Exists] -- [Create_Case_Date_Details_If_Not_Exists]
   @s_a_DomainId varchar(50) = null
AS
BEGIN
	INSERT INTO tblCase_Date_Details
	(
		 Case_Id
		,DomainId		
		,CreatedBy
		,CreatedDate
	)
	SELECT DISTINCT
		c.Case_Id,
		c.DomainId,
		'',
		GETDATE()
	FROM 
		tblcase c
	WHERE 
		c.Case_Id not in (SELECT DISTINCT cd.Case_Id FROM tblCase_Date_Details cd)

END
