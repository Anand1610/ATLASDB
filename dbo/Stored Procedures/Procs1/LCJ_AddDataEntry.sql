CREATE PROCEDURE [dbo].[LCJ_AddDataEntry]
(
--Case_AutoId	int	4
--@Case_Id				nvarchar(100),
@Provider_Id				nvarchar(100),
@InsuranceCompany_Id			nvarchar(100),
@InjuredParty_LastName		nvarchar(200),
@InjuredParty_FirstName		nvarchar(200),
@Accident_Date			DATETIME,
@Policy_Number			nvarchar(50),
@Ins_Claim_Number			nvarchar(50),
@Status				nvarchar(40),
@Claim_Amount				varchar(100),
@Paid_Amount				varchar(100),
@Initial_Status				nvarchar(20),
@Memo				nvarchar(255),
@Court_Id				int,

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
	DECLARE @Date_Opened AS DATETIME,
		@LASTCASEID VARCHAR(50),
		@NEWCASEID VARCHAR(50),
		@PART1CASEID INT,
		@PART2CASEID INT
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
			Policy_Number = @Policy_Number AND
			CLAIM_AMOUNT = @Claim_Amount
			  
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
					Accident_Date,
					Policy_Number,
					Ins_Claim_Number,					
					Status,
					Claim_Amount,
					Paid_Amount,
					Date_Opened,					
					Initial_Status,
					Memo,					
					Court_Id


				)
				 
				VALUES

				(
				
					'',
					@Provider_Id,
					@InsuranceCompany_Id,
					@InjuredParty_LastName,
					@InjuredParty_FirstName,
					Convert(nvarchar(15), @Accident_Date, 101),
					@Policy_Number,
					@Ins_Claim_Number,					
					@Status,
					@Claim_Amount,
					@Paid_Amount,
					'',					
					@Initial_Status,
					@Memo,					
					@Court_Id
				)
					
				
				
			COMMIT TRAN

			
			SET  @Case_Id_IDENTITY = @@IDENTITY	

			SELECT @LASTCASEID = Max(Case_Id) FROM TBLCASE WHERE CHARINDEX('.',CASE_ID) > 1
			
			select @PART1CASEID  = convert(int,SUBSTRING(CASE_ID,1,CHARINDEX('.',CASE_ID)-1)),@PART2CASEID = convert(int,SUBSTRING(CASE_ID,CHARINDEX('.',CASE_ID)+1,LEN(CASE_ID))) FROM TBLCASE WHERE CHARINDEX('.',CASE_ID) > 1 and isNumeric(SUBSTRING(CASE_ID,CHARINDEX('.',CASE_ID)+1,LEN(CASE_ID)))>0 and charindex('.',SUBSTRING(CASE_ID,CHARINDEX('.',CASE_ID)+1,LEN(CASE_ID))) <=0 order by case_id

			if @PART1CASEID < 250 
				set @PART1CASEID = 250
			else
				set @PART1CASEID = @PART1CASEID

			IF @PART2CASEID = "999"
			BEGIN 
				SET @NEWCASEID =  CONVERT(VARCHAR,@PART1CASEID + 1) + '.00' +   CONVERT(VARCHAR,1)
			END
			ELSE
			BEGIN
				if  @PART2CASEID < 9
				begin
					SET @NEWCASEID =  CONVERT(VARCHAR,@PART1CASEID) + '.00' +   CONVERT(VARCHAR,@PART2CASEID + 1)
				end
				if  @PART2CASEID >= 9 and @PART2CASEID < 99
				begin
					SET @NEWCASEID =  CONVERT(VARCHAR,@PART1CASEID) + '.0' +   CONVERT(VARCHAR,@PART2CASEID + 1)
				end
				if  @PART2CASEID >= 99
				begin
					SET @NEWCASEID =  CONVERT(VARCHAR,@PART1CASEID) + '.' +   CONVERT(VARCHAR,@PART2CASEID + 1)
				end
				
			END
			SET @Case_Id  = @NEWCASEID 

			UPDATE tblCase SET Case_Id = @Case_Id,Date_Opened=getdate() where Case_AutoId = @Case_Id_IDENTITY
			SET @NewCaseOutputResult = @Case_Id

		
			declare
			@caid varchar(50),
			@iid varchar(50),
			@status1 varchar(50),
			@prid varchar(50)
			
			select @caid = case_id,@iid=insurancecompany_id,@status1=status,@prid=provider_id from tblCase where Case_AutoId = @Case_Id_IDENTITY
			
			exec procInsertDesks @CID=@caid,@insurancecompany_id=@iid,@provider_id=@prid,@status=@status1
			
			update tblcase set Caption = @InjuredParty_FirstName + ' ' + @InjuredParty_LastName,Group_All = @Case_Id,GROUP_CLAIMAMT = @Claim_Amount,GROUP_PAIDAMT=@Paid_Amount,GROUP_BALANCE = convert(varchar,convert(money,@Claim_Amount) - convert(money,@Paid_Amount)),GROUP_INSCLAIMNO = @Ins_Claim_Number,Group_Accident=Convert(nvarchar(15), @Accident_Date, 101),Group_PolicyNum=@Policy_Number where case_id=@case_id





		END -- END of ELSE	
	
END

