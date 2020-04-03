CREATE PROCEDURE [dbo].[INSERT_POM_DETAILS]
	@DomainId NVARCHAR(50),
	@Pom_generated_by AS NVARCHAR(50),
	@POM_Date_Bill_Send AS DateTime, 
	@MAX_POMID INTEGER OUTPUT
AS
BEGIN

		DECLARE @i_l_POM_ID VARCHAR(10)
		SET @i_l_POM_ID =ISNULL((SELECT top 1 POM_ID_New FROM TBLPOM  (NOLOCK)
		WHERE DomainId=@DomainID ORDER BY POM_ID_New DESC),'100000')  + 1
		
		INSERT INTO TBLPOM
		(
			DomainId,
			Pom_date,
			Pom_generated_by,
			POM_ID_New,
			POM_Date_Bill_Send
		)
		VALUES
		(
			@DomainId,
			getdate(),
			@Pom_generated_by,
			@i_l_POM_ID,
			@POM_Date_Bill_Send
		)

		SET @MAX_POMID = @i_l_POM_ID -- (SELECT MAX(POM_ID) FROM TBLPOM)
END

