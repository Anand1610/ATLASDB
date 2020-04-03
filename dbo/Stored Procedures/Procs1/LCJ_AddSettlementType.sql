CREATE PROCEDURE [dbo].[LCJ_AddSettlementType]
(

@DomainId				nvarchar(50),
@Settlement_Type		nvarchar(100)


)
AS
BEGIN
	
	BEGIN


		-- Insert the records
		BEGIN TRAN
			
		INSERT INTO tblSettlement_Type 
		(
		DomainId,
		Settlement_Type		
		)

		VALUES(
		@DomainId,
		@Settlement_Type
		)					

		COMMIT TRAN

	END

END

