CREATE PROCEDURE Get_WitnessType
	@s_a_DomainId varchar(50)
AS
BEGIN
	SET NOCOUNT ON;
    
	Select WitnessTypeID
	      ,WitnessType
		  ,Description
		  ,DomainId
		  ,created_by_user
		  ,CONVERT(VARCHAR(50), created_date, 101) as created_date
		  ,modified_by_user 
		  ,CONVERT(VARCHAR(50), modified_date, 101) as modified_date 
    from tblWitnessType Where DomainId = @s_a_DomainId 
	ORDER BY
		WitnessType ASC
END
