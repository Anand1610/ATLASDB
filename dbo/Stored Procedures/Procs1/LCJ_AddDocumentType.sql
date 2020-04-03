CREATE PROCEDURE [dbo].[LCJ_AddDocumentType]
(
			@DomainId nvarchar(50),
			@Doc_Name nvarchar(100),
			--@Doc_Type nvarchar(100),
			@Doc_Value nvarchar(100),
			@Doc_Settlement as Bit
			


)
AS
BEGIN
	
	BEGIN


		-- Insert the records
		BEGIN TRAN
			
		INSERT INTO tblDocs 
		(
			DomainId,
			Doc_Name,
			--Doc_Type,
			Doc_Value,
			Settlement
			
		)

		VALUES(
		
			@DomainId,
			@Doc_Name,
			--@Doc_Type,
			@Doc_Value,
			@Doc_Settlement
		)					

		COMMIT TRAN

	END -- END of ELSE	

END

