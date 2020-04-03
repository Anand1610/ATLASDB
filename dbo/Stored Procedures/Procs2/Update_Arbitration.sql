
CREATE PROCEDURE [dbo].[Update_Arbitration]
(
	@DomainId VARCHAR(50),
	@CASE_ID VARCHAR(100),
	@REPRESENTETIVE VARCHAR(500),
	@Representative_Contact_Number VARCHAR (500),
	@INJUREDPARTY_ADDRESS VARCHAR(255),
	@INJUREDPARTY_CITY VARCHAR(40),
	@INJUREDPARTY_STATE VARCHAR(40),
	@INJUREDPARTY_ZIP VARCHAR(40),
	@INSUREDPARTY_LASTNAME 	VARCHAR(100),
	@INSUREDPARTY_FIRSTNAME	VARCHAR(100),
	@INSUREDPARTY_ADDRESS	VARCHAR(255),
	@INSUREDPARTY_CITY	VARCHAR(40),
	@INSUREDPARTY_STATE	VARCHAR(40),
	@INSUREDPARTY_ZIP	VARCHAR(40),
	@DENIAL_DATE        DATETIME=null,	
	@ACCIDENT_DATE        DATETIME,	
	@INSURANCECOMPANY_INITIAL_ADDRESS	VARCHAR(250),
	@USERID VARCHAR(100)
	--@INSURANCECOMPANY_INITIAL_CITY	VARCHAR(100),
	--@INSURANCECOMPANY_INITIAL_STATE	VARCHAR(100),
	--@INSURANCECOMPANY_INITIAL_ZIP	VARCHAR(100)
)
AS
BEGIN
	BEGIN TRANSACTION;
	
	if @Representetive =''
		set @Representetive =null
	if @Representative_Contact_Number =''
		set @Representative_Contact_Number =null
			
		UPDATE tblcase
		SET 
			tblcase.Representetive =@Representetive,
			tblcase.Representative_Contact_Number = @Representative_Contact_Number,
			tblcase.INSUREDPARTY_LASTNAME = @INSUREDPARTY_LASTNAME,
			tblcase.INSUREDPARTY_FIRSTNAME = @INSUREDPARTY_FIRSTNAME,
			tblcase.InsuredParty_Address =@InsuredParty_Address,
			tblcase.InsuredParty_City = @InsuredParty_City,
			tblcase.InsuredParty_State = @InsuredParty_State,
			tblcase.InsuredParty_Zip = @InsuredParty_Zip,
			tblcase.DENIAL_DATE = @DENIAL_DATE,
			tblcase.INJUREDPARTY_ADDRESS = @INJUREDPARTY_ADDRESS,
			tblcase.INJUREDPARTY_CITY = @INJUREDPARTY_CITY,
			tblcase.INJUREDPARTY_STATE = @INJUREDPARTY_STATE,
			tblcase.INJUREDPARTY_ZIP = @INJUREDPARTY_ZIP,
			tblcase.InsuranceCompany_Initial_Address=@InsuranceCompany_Initial_Address,
			tblCase.Accident_Date=@ACCIDENT_DATE
		WHERE Case_Id = @Case_ID
		AND DomainID = @DomainId
			 --AND tblcase.InsuranceCompany_Id = tblInsuranceCompany.InsuranceCompany_Id  
		DECLARE @NOTES_DESC VARCHAR(3000)

		SET @NOTES_DESC = 'Case Updated -' +
			'Injuredparty Address  -' + ISNULL(@INJUREDPARTY_ADDRESS,'') + ';'+
			'Injuredparty City  -' + ISNULL(@INJUREDPARTY_CITY,'') + ';'+
			'Injuredparty State  -' + ISNULL(@INJUREDPARTY_STATE,'') + ';'+
			'Injuredparty Zip  -' + ISNULL(@INJUREDPARTY_ZIP,'') + ';'+
			'Insuredparty Lastname  -' + ISNULL(@INSUREDPARTY_LASTNAME,'') + ';'+
			'Insuredparty Firstname  -' + ISNULL(@INSUREDPARTY_FIRSTNAME,'') + ';'+
			'Insuredparty Address  -' + ISNULL(@INSUREDPARTY_ADDRESS,'') + ';'+
			'Insuredparty City  -' + ISNULL(@INSUREDPARTY_CITY,'') + ';'+
			'Insuredparty State  -' + ISNULL(@INSUREDPARTY_STATE,'') + ';'+
			'Insuredparty Zip  -' + ISNULL(@INSUREDPARTY_ZIP,'') + ';'+
			'Denial Date  -' + ISNULL(CONVERT(VARCHAR,@DENIAL_DATE,101),'') + ';'+
			'Accident Date  -' + ISNULL(CONVERT(VARCHAR,@ACCIDENT_DATE,101),'') + ';'+
			'Ins Initial Address  -' + ISNULL(@INSURANCECOMPANY_INITIAL_ADDRESS,'') + ';'+
			'Representetive  -' + ISNULL(@REPRESENTETIVE,'') + ';'+
			'Representative Contact No  -' + ISNULL(@Representative_Contact_Number,'')


		INSERT INTO [tblNotesAAACases] (Notes_Desc, Case_Id, Notes_Date, User_Id, DomainId)
		VALUES (@NOTES_DESC, @Case_ID, GETDATE(), @USERID, @DomainId)

		
	COMMIT;

END

