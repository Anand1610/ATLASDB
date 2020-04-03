
CREATE PROCEDURE [dbo].[USP_UpdateProviderCase]

(
@DomainId				nvarchar(50),
@Case_Id				nvarchar(100),
@Provider_Id				nvarchar(100),
@InsuranceCompany_Id			nvarchar(100),
@InjuredParty_LastName		nvarchar(200),
@InjuredParty_FirstName		nvarchar(200),
@InjuredParty_Address			nvarchar(255),
@InjuredParty_City			nvarchar(20),
@InjuredParty_State			nvarchar(20),
@InjuredParty_Zip			nvarchar(20),
@InjuredParty_Phone			nvarchar(20),
@InjuredParty_Misc			nvarchar(50),
@InsuredParty_LastName		nvarchar(200),
@InsuredParty_FirstName		nvarchar(200),
@InsuredParty_Address			nvarchar(255),
@InsuredParty_City			nvarchar(20),
@InsuredParty_State			nvarchar(20),
@InsuredParty_Zip			nvarchar(20),
@InsuredParty_Misc			nvarchar(50),
@Accident_Date			DATETIME,
@Accident_Address			nvarchar(255),
@Accident_City				nvarchar(20),
@Accident_State			nvarchar(20),
@Accident_Zip				nvarchar(20),
@Policy_Number			nvarchar(50),
@Ins_Claim_Number			nvarchar(50),
@Date_BillSent				NVARCHAR(50),
@DateOfService_Start			datetime,
@DateOfService_End			datetime,
@Claim_Amount				NVARCHAR(50),
@Paid_Amount				NVARCHAR(50),
@Memo				nvarchar(255),
@InjuredParty_Type			nvarchar(20),
@InsuredParty_Type			nvarchar(20),
@Adjuster_Id				int,
@batchcode NVARCHAR(50),
@Location_Id int
	 
)
AS
BEGIN
if(@Location_Id=0)
	set @Location_Id=null;

	Declare @CurrentDate AS SMALLDATETIME
	DECLARE @Date_Opened AS DATETIME
	SET @CurrentDate = Convert(Varchar(15), GetDate(),102)	
		BEGIN		
			
			BEGIN TRAN
				-- Insert Claim Details			
				Update  tblProviderCase  SET
					Case_Id = @Case_Id,
					Provider_Id = @Provider_Id,
					InsuranceCompany_Id = @InsuranceCompany_Id,
					ClaimantParty_LastName = @InjuredParty_LastName,
					ClaimantParty_FirstName = @InjuredParty_FirstName,
					ClaimantParty_Address = @InjuredParty_Address,
					ClaimantParty_City = @InjuredParty_City,
					ClaimantParty_State = @InjuredParty_State,
					ClaimantParty_Zip = @InjuredParty_Zip,
					ClaimantParty_Phone = @InjuredParty_Phone,
					ClaimantParty_Misc = @InjuredParty_Misc,
					InsuredParty_LastName = @InsuredParty_LastName,
					InsuredParty_FirstName = @InsuredParty_FirstName,
					InsuredParty_Address = @InsuredParty_Address,
					InsuredParty_City= @InsuredParty_City,
					InsuredParty_State = @InsuredParty_State,
					InsuredParty_Zip = @InsuredParty_Zip,
					InsuredParty_Misc = @InsuredParty_Misc,
					Incident_Date = @Accident_Date,
					Incident_Address = @Accident_Address,
					Incident_City = @Accident_City,
					Incident_State = @Accident_State,
					Incident_Zip = @Accident_Zip,
					Policy_Number = @Policy_Number,
					Ins_Claim_Number = @Ins_Claim_Number,					
					Defendant_Id = '',		
					Memo = @Memo,
					ClaimantParty_Type = @InjuredParty_Type,
					InsuredParty_Type = @InsuredParty_Type,
					Adjuster_Id = @Adjuster_Id,	
					DateOfService_Start = @DateOfService_Start,
					DateOfService_End = @DateOfService_End,
					Claim_Amount = @Claim_Amount,
					Paid_Amount = @Paid_Amount,
					Date_BillSent = @Date_BillSent,
					batchcode =	@batchcode,
					Location_Id = @Location_Id,
					Status='Pending'
					
			WHERE Case_Id = @Case_Id
			and DomainId=@DomainId
				 
			--BEGIN
			--		declare @file_scaned_new as int
			--		declare @file_pending_new as int
			--		declare @new_file_scaned as int
			--		declare @new_file_pending as int
			--		declare @batchnew as varchar(30)
			--		set	@batchnew=(select batchcode from tblcase  where case_id=@Case_Id and DomainId = @DomainId)
			--		set @file_scaned_new= (select file_scanned from tblProviderBoxDetails where batch_no=@batchnew and DomainId=@DomainId)
			--		set @file_pending_new= (select file_pending from tblProviderBoxDetails where batch_no=@batchnew and DomainId=@DomainId)

			--		set @new_file_scaned = @file_scaned_new+1
			--		set @new_file_pending = @file_pending_new -1
			--		if @new_file_scaned >=0 and @new_file_pending>=0
			--			Begin
			--				update tblProviderBoxDetails 
			--				set file_pending=@new_file_pending, file_scanned = @new_file_scaned
			--				where batch_no=@batchnew
			--				and DomainId=@DomainId
			--			End
			--End	
				
				
			COMMIT TRAN

		END -- END of ELSE	
	
END



