CREATE PROCEDURE [dbo].[LCJ_AddClaimRep]
(

--ClaimRep_Id	nvarchar	no	100
@Insurer_Id			nvarchar(50),
@ClaimRep_LastName		nvarchar(100),
@ClaimRep_FirstName		nvarchar(100),
@ClaimRep_Phone		nvarchar(50),
@ClaimRep_Fax			nvarchar(50),
@ClaimRep_Email		nvarchar(50)


--@OperationResult INTEGER OUT
)
AS
BEGIN
	DECLARE @ClaimRepID AS NVARCHAR(20) ,@CurrentDate AS SMALLDATETIME


	SET @CurrentDate = Convert(Varchar(15), GetDate(),102)

	
	BEGIN
		
		
		-- Insert the records
		BEGIN TRAN
			-- Insert Claim Details
		INSERT INTO tblClaimRep 
		(
		Insurer_Id, 
		ClaimRep_LastName,
		ClaimRep_FirstName,
		ClaimRep_Phone,
		ClaimRep_Fax,
		ClaimRep_Email
		)

		VALUES(
		@Insurer_Id,
		@ClaimRep_LastName,
		@ClaimRep_FirstName,
		@ClaimRep_Phone,
		@ClaimRep_Fax,
		@ClaimRep_Email
		)					

		COMMIT TRAN

	END -- END of ELSE	

END

