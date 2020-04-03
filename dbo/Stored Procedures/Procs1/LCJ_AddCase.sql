CREATE PROCEDURE [dbo].[LCJ_AddCase]

(

--Case_AutoId	int	4
--@Case_Id				nvarchar(100),
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
@IndexOrAAA_Number			nvarchar(50),
@Status				nvarchar(40),
--@Defendant_Id				nvarchar(20),
--@Date_Opened				nvarchar(15),
--@Date_BillSent				DATETIME,
@Date_BillSent				NVARCHAR(50),
@DateOfService_Start			DATETIME,
@DateOfService_End			DATETIME,
@Claim_Amount				varchar(100),
@Paid_Amount				varchar(100),
--@Last_Status				nvarchar(20),
@Initial_Status				nvarchar(20),
@Memo				nvarchar(255),
@InjuredParty_Type			nvarchar(20),
@InsuredParty_Type			nvarchar(20),
@Adjuster_Id				int,
@DenialReasons_Id		nvarchar(100),
@Court_Id				int,

--@Comment VARCHAR(250) ,
--@NotesDesc VARCHAR(250),
--@ValueMemo Varchar(250) ,
--@ValueClaimID Varchar(10),
--@UserID AS VARCHAR(10) ,
/*
Add @OperationResult Paramater to Check if Matter inserted already exists!
Add @NewMatterOutputResult to get the Last New Matter ID Just Added in the DBase
*/
@OperationResult INTEGER OUTPUT,
@NewCaseOutputResult VARCHAR(100) OUTPUT
				 
)
AS
BEGIN
	DECLARE @Case_Id	AS NVARCHAR(20) , @CurrentDate AS SMALLDATETIME
	DECLARE @Date_Opened AS DATETIME
	-- Remove Leading and ending spaces from the input parameters
	SET @InjuredParty_LastName = RTRIM(LTRIM(@InjuredParty_LastName))
	SET @InjuredParty_FirstName = RTRIM(LTRIM(@InjuredParty_FirstName))
	SET @CurrentDate = Convert(Varchar(15), GetDate(),102)
	--SET @Date_Opened = Convert(DATETIME, @Date_Opened, 101)
	-- Check if similiar Claim already exisits 
	-- if it exists the don't proceed further , return output code as 2
	IF EXISTS(Select Case_Id  
			FROM  tblCase
			WHERE 
			Provider_Id = @Provider_Id and 
			InjuredParty_LastName = InjuredParty_LastName and 
			InjuredParty_FirstName = @InjuredParty_FirstName and
			Accident_Date = @Accident_Date and 
			Policy_Number = @Policy_Number
			  
			)

		BEGIN
			SET @OperationResult = 2
			--RETURN @OperationResult
		END
	
	ELSE
	
		BEGIN
			
			
			DECLARE @MaxCase_Id INTEGER
			DECLARE @Case_Id_IDENTITY INTEGER
			
			
			-- Insert the records
			BEGIN TRAN
				-- Insert Claim Details
			
				Insert INTO tblCase 
				(
				
				
					Case_Id,
					Provider_Id,
					InsuranceCompany_Id,
					InjuredParty_LastName,
					InjuredParty_FirstName,
					InjuredParty_Address,
					InjuredParty_City,
					InjuredParty_State,
					InjuredParty_Zip,
					InjuredParty_Phone,
					InjuredParty_Misc,
					InsuredParty_LastName,
					InsuredParty_FirstName,
					InsuredParty_Address,
					InsuredParty_City,
					InsuredParty_State,
					InsuredParty_Zip,
					InsuredParty_Misc,
					Accident_Date,
					Accident_Address,
					Accident_City,
					Accident_State,
					Accident_Zip,
					Policy_Number,
					Ins_Claim_Number,
					IndexOrAAA_Number,
					Status,
					Defendant_Id,
					Date_Opened,
					--Last_Status,
					Initial_Status,
					Memo,
					InjuredParty_Type,
					InsuredParty_Type,
					Adjuster_Id,
					DenialReasons_Type,
					Court_Id


				)
				 
				VALUES

				(
				
					'',
					@Provider_Id,
					@InsuranceCompany_Id,
					@InjuredParty_LastName,
					@InjuredParty_FirstName,
					@InjuredParty_Address,
					@InjuredParty_City,
					@InjuredParty_State,
					@InjuredParty_Zip,
					@InjuredParty_Phone,
					@InjuredParty_Misc,
					@InsuredParty_LastName,
					@InsuredParty_FirstName,
					@InsuredParty_Address,
					@InsuredParty_City,
					@InsuredParty_State,
					@InsuredParty_Zip,
					@InsuredParty_Misc,
					Convert(nvarchar(15), @Accident_Date, 101),
					@Accident_Address,
					@Accident_City,
					@Accident_State,
					@Accident_Zip,
					@Policy_Number,
					@Ins_Claim_Number,
					@IndexOrAAA_Number,
					@Status,
					'',
					Convert(nvarchar(15), getdate(),101),					
					--@Last_Status,
					@Initial_Status,
					@Memo,
					@InjuredParty_Type,
					@InsuredParty_Type,
					@Adjuster_Id,
					@DenialReasons_Id,
					@Court_Id		
				)
					
				--Select @NewMatterOutputResult = Max(Matter_Id) from tblMatter
				--return @NewMatterOutputResult
				--return @OperationResult
				--Set  @NewMatterOutputResult = @@IDENTITY
				-- Insert Notes Data Entry
				/*INSERT INTO Notes 
				(Notes_Desc , Notes_Type , Claim_ID , Notes_Date , User_ID , Notes_Priority) VALUES 
			    	 (@NotesDesc , 'A' , @ValueClaimID , @CurrentDate , @UserID , '0')
				
				IF @Comment <> ''
				BEGIN
					-- Insert into Notes again??
					INSERT INTO Notes
					(Notes_Desc , Notes_Type , Claim_ID , Notes_Date , User_ID , Notes_Priority) VALUES 
					(@ValueMemo , 'A' , @ValueClaimID , @CurrentDate , @UserID , '0')
				END
	
				IF ((@Status = 'SUIT' OR @Status = 'UNTIMELY') AND @claimff = 1 AND @OrignalStatus ='SUIT') 
					Insert into Transactions VALUES(@CID ,'OTH',@CurrentDate,55,'' ,@ClientId,'System',55)
				*/
				
			COMMIT TRAN

			--Select @MaxMatter_Id =Convert(Integer, SUBSTRING(MAX(Matter_Id),PATINDEX('%-%' , MAX(Matter_Id) )+1, 8)) from tblMatter 
			--Select @MaxMatter_Id = Max(Matter_AutoId) from tblMatter
			
			--Set @MM_ID = @MaxMatter_Id + 1
			
			--IF (@MaxMatter_Id = NULL)
			SET  @Case_Id_IDENTITY = @@IDENTITY	

			SET @Case_Id  = 'LGT' + RIGHT(CAST(DATEPART(year, GETDATE()) AS NVARCHAR),2) + '-' + CAST(@Case_Id_IDENTITY AS NVARCHAR)

			UPDATE tblCase SET Case_Id = @Case_Id where Case_AutoId = @Case_Id_IDENTITY

			SET @NewCaseOutputResult = @Case_Id

			update tblCase set DateOfService_Start=Convert(nvarchar(15), @DateOfService_Start, 101),DateOfService_End=Convert(nvarchar(15), @DateOfService_End, 101),Claim_Amount=convert(varchar,@Claim_Amount),Paid_Amount=convert(varchar,@Paid_Amount),Date_BillSent=@Date_BillSent where case_id=@Case_Id
			
			
			
			--RETURN @OperationResult
			--RETURN  @Matter_Id
declare
@caid varchar(50),
@iid varchar(50),
@status1 varchar(50),
@prid varchar(50)

select @caid = case_id,@iid=insurancecompany_id,@status1=status,@prid=provider_id from tblCase where Case_AutoId = @Case_Id_IDENTITY
exec procInsertDesks @CID=@caid,@insurancecompany_id=@iid,@provider_id=@prid,@status=@status1

--------------------------insert captions-----------------------------------------------

exec LCJ_CreateCaption @cid = @caid,@gpid = 0


		END -- END of ELSE	
	
END

