CREATE PROCEDURE [dbo].[LCJ_AddNotesType]
(
@DomainId nvarchar(50),
@Notes_Type		nvarchar(100),
@Notes_Type_Color	nvarchar(100)

)
AS
BEGIN
	
	BEGIN


		-- Insert the records
		BEGIN TRAN
			
		INSERT INTO tblNotesType
		(
		DomainId,
		Notes_Type,
		Notes_Type_Color		
		)

		VALUES(
		@DomainId,
		@Notes_Type,
		@Notes_Type_Color	
		)					

		COMMIT TRAN

	END

END

