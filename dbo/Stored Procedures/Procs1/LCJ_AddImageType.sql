CREATE PROCEDURE [dbo].[LCJ_AddImageType]
(
@DomainId nvarchar(50),
@Image_Type		nvarchar(100)


)
AS
BEGIN
	
	BEGIN


		-- Insert the records
		BEGIN TRAN
			
		INSERT INTO tblImageTypes 
		(
		DomainId,
		Image_Type		
		)

		VALUES(
		@DomainId,
		@Image_Type
		)					

		COMMIT TRAN

	END

END

