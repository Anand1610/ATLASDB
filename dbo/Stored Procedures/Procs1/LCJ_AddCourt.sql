CREATE PROCEDURE [dbo].[LCJ_AddCourt]
(
			@DomainId nvarchar(50),
			@Court_Name nvarchar(100),
			@Court_Venue nvarchar(100),
			@Court_Address nvarchar(100),
			@Court_Basis nvarchar(100),
			@Court_Misc nvarchar(100)


)
AS
BEGIN
	
	BEGIN


		-- Insert the records
		BEGIN TRAN
			
		INSERT INTO tblCourt 
		(
			DomainId,
			Court_Name,
			Court_Venue,
			Court_Address,
			Court_Basis,
			Court_Misc
		)

		VALUES(
			@DomainId,
			@Court_Name,
			@Court_Venue,
			@Court_Address,
			@Court_Basis,
			@Court_Misc
		)					

		COMMIT TRAN

	END -- END of ELSE	

END

