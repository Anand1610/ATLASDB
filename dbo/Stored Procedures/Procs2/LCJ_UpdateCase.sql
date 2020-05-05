CREATE PROCEDURE [dbo].[LCJ_UpdateCase]

(
@DomainId				VARCHAR(50),
@Case_Id				VARCHAR(100),
@Provider_Id				VARCHAR(100),
@InsuranceCompany_Id			VARCHAR(100),
@InjuredParty_LastName		VARCHAR(200),
@InjuredParty_FirstName		VARCHAR(200),
@InjuredParty_Address			VARCHAR(255),
@InjuredParty_City			VARCHAR(20),
@InjuredParty_State			VARCHAR(20),
@InjuredParty_Zip			VARCHAR(20),
@InjuredParty_Phone			VARCHAR(20),
@InjuredParty_Misc			VARCHAR(50),
@InsuredParty_LastName		VARCHAR(200),
@InsuredParty_FirstName		VARCHAR(200),
@InsuredParty_Address			VARCHAR(255),
@InsuredParty_City			VARCHAR(20),
@InsuredParty_State			VARCHAR(20),
@InsuredParty_Zip			VARCHAR(20),
@InsuredParty_Misc			VARCHAR(50),
@Accident_Date			DATETIME,
@Accident_Address			VARCHAR(255),
@Accident_City				VARCHAR(20),
@Accident_State			VARCHAR(20),
@Accident_Zip				VARCHAR(20),
@Policy_Number			VARCHAR(50),
@Ins_Claim_Number			VARCHAR(50),
@IndexOrAAA_Number			VARCHAR(50),
@Status				VARCHAR(40),
@Initial_Status				VARCHAR(20),
@Memo				VARCHAR(255),
@InjuredParty_Type			VARCHAR(20),
@InsuredParty_Type			VARCHAR(20),
@Adjuster_Id				int,
@DenialReasons_Id			VARCHAR(100),
@Court_Id				int,
@Location_Id int		,
@PortfolioId int =null,
@AttorneyFirmId int= null		 
)
AS
BEGIN
if(@Location_Id=0)
	set @Location_Id=null;

	Declare @CurrentDate AS SMALLDATETIME
	DECLARE @Date_Opened AS DATETIME
	Declare @Old_Status AS VARCHAR(100)
	DECLARE @newStatusHierarchy int
	DECLARE @oldStatusHierarchy int
	SET @CurrentDate = Convert(Varchar(15), GetDate(),102)
	
		BEGIN
			
			
			BEGIN TRAN
				-- Insert Claim Details

				BEGIN

					declare @file_scaned as int
					declare @file_pending as int
					declare @old_file_scaned as int
					declare @old_file_pending as int
					declare @batchold as varchar(30)
					set	@batchold=(select batchcode from tblcase where case_id=@Case_Id and DomainId=@DomainId)
					set @file_scaned= (select file_scanned from tblProviderBoxDetails where batch_no=@batchold and DomainId=@DomainId)
					set @file_pending= (select file_pending from tblProviderBoxDetails where batch_no=@batchold and DomainId=@DomainId)
					SET @Old_Status =(select status from tblcase where Case_Id =@case_id and DomainId=@DomainID)
					SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@Old_Status)
		            SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@Status)

					set @old_file_scaned = @file_scaned-1
					set @old_file_pending = @file_pending +1
					if @old_file_scaned >=0 and @old_file_pending>=0
						Begin
							update tblProviderBoxDetails 
							set file_pending=@old_file_pending, file_scanned = @old_file_scaned
							where batch_no=@batchold
							and DomainId=@DomainId
						End
				End
			
				print '1'
				Update  tblcase  SET
				
		
					Case_Id = @Case_Id,
					Provider_Id = @Provider_Id,
					InsuranceCompany_Id = @InsuranceCompany_Id,
					InjuredParty_LastName = @InjuredParty_LastName,
					InjuredParty_FirstName = @InjuredParty_FirstName,
					InjuredParty_Address = @InjuredParty_Address,
					InjuredParty_City = @InjuredParty_City,
					InjuredParty_State = @InjuredParty_State,
					InjuredParty_Zip = @InjuredParty_Zip,
					InjuredParty_Phone = @InjuredParty_Phone,
					InjuredParty_Misc = @InjuredParty_Misc,
					InsuredParty_LastName = @InsuredParty_LastName,
					InsuredParty_FirstName = @InsuredParty_FirstName,
					InsuredParty_Address = @InsuredParty_Address,
					InsuredParty_City= @InsuredParty_City,
					InsuredParty_State = @InsuredParty_State,
					InsuredParty_Zip = @InsuredParty_Zip,
					InsuredParty_Misc = @InsuredParty_Misc,
					Accident_Date = @Accident_Date,
					Accident_Address = @Accident_Address,
					Accident_City = @Accident_City,
					Accident_State = @Accident_State,
					Accident_Zip = @Accident_Zip,
					Policy_Number = @Policy_Number,
					Ins_Claim_Number = @Ins_Claim_Number,
					IndexOrAAA_Number = @IndexOrAAA_Number,
					Status= (case when (@newStatusHierarchy>=@oldStatusHierarchy) then  @Status else @Old_Status  end),
					Defendant_Id = '',					
					Initial_Status = @Initial_Status,
					Memo = @Memo,
					InjuredParty_Type = @InjuredParty_Type,
					InsuredParty_Type = @InsuredParty_Type,
					Adjuster_Id = @Adjuster_Id,
					DenialReasons_Type = @DenialReasons_Id,
					Court_Id = @Court_Id,
					Location_Id = @Location_Id ,
					PortfolioId=@PortfolioId,
					AttorneyFirmId=@AttorneyFirmId
			WHERE Case_Id = @Case_Id
			and DomainId=@DomainId
				 
			COMMIT TRAN

		END -- END of ELSE	
	
END


