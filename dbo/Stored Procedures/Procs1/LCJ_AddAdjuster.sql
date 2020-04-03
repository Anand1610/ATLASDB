CREATE PROCEDURE [dbo].[LCJ_AddAdjuster]
(

--Adjuster_Id	nvarchar	no	100
@DomainID nvarchar(50),
@InsuranceCompany_Id		nvarchar(50),
@Adjuster_LastName		nvarchar(100),
@Adjuster_FirstName		nvarchar(100),
@Adjuster_Address  varchar(255),
@Adjuster_Phone		nvarchar(50),
@Adjuster_Fax			nvarchar(50),
@Adjuster_Email		nvarchar(50),
@Adjuster_Extension nvarchar(50)

--@OperationResult INTEGER OUT
)
AS
BEGIN
	DECLARE @AdjusterID AS NVARCHAR(20) ,@CurrentDate AS SMALLDATETIME


	SET @CurrentDate = Convert(Varchar(15), GetDate(),102)


	BEGIN


		-- Insert the records
		BEGIN TRAN
			-- Insert Claim Details
		INSERT INTO tblAdjusters
		(
		DomainId,
		InsuranceCompany_Id, 
		Adjuster_LastName,
		Adjuster_FirstName,
        Adjuster_Address,
		Adjuster_Phone,
		Adjuster_Fax,
		Adjuster_Email,
        Adjuster_Extension
		)

		VALUES(
		@DomainID,
		@InsuranceCompany_Id,
		@Adjuster_LastName,
		@Adjuster_FirstName,
		@Adjuster_Address,
		@Adjuster_Phone,
		@Adjuster_Fax,
		@Adjuster_Email,
        @Adjuster_Extension
		)					

		COMMIT TRAN

	END -- END of ELSE	

END

