CREATE PROCEDURE [dbo].[ECMC_List] --'ron','','','','','',''
	@Patient_Name	varchar(100)=null,
	@Account_No varchar(50)=null,
	@UCR_No varchar(50)=null,
	@Account_Type varchar(50)=null,
	@Insurance varchar(50)=null,
	@Policy_No varchar(50)=null,
	@FHKP_Case_Id varchar(50)=null
AS
BEGIN
	DECLARE @STRSQL VARCHAR(4000)
	SET @STRSQL = 'SELECT ID,FHKP_Case_Id,FHKP_Case_Auto_Id,[Patient Name]Patient_Name,[Account] Account_No,[UCR]UCR_No,[Account Type]Account_Type,
	ST,
	convert(varchar(12),[Discharge Date],101) [Discharge_Date],convert(varchar(12),[Age Date],101) [Age_Date],
	[Age In Days]Age_In_Days,
	[Insurance Group]Insurance_Group,[Policy]Policy_No,[Insurance],[Insurance Name]Insurance_Name,[No],[Bill_No],[Bill Charges],[Bill Balance],
	[Bill Receipt],
	[Bill Adjustment],[Bill Expected Reimbursement],[SP Payments],[MCD Insurance Payments],
	[Other Insurance Payments] FROM ECMC ec WHERE 1=1 '
	IF @Patient_Name <> '' and @Patient_Name is not null
	BEGIN
		SET @STRSQL = @STRSQL + ' AND [Patient Name] Like ''%' + @Patient_Name + '%'''
	END
	IF @Account_No <> '' and @Account_No is not null
	BEGIN
		SET @STRSQL = @STRSQL + ' AND [Account] Like ''%' + @Account_No + '%'''
	END
	IF @UCR_No <> '' and @UCR_No is not null
	BEGIN
		SET @STRSQL = @STRSQL + ' AND [UCR] Like ''%' + @UCR_No + '%'''
	END
	IF @Account_Type <> '------' and @Account_Type is not null
	BEGIN
		SET @STRSQL = @STRSQL + ' AND [Account Type] Like ''%' + @Account_Type + '%'''
	END
	IF @Insurance <> '------' and @Insurance is not null
	BEGIN
		SET @STRSQL = @STRSQL + ' AND Insurance Like ''%' + @Insurance + '%'''
	END
	IF @Policy_No <> '' and @Policy_No is not null
	BEGIN
		SET @STRSQL = @STRSQL + ' AND Policy Like ''%' + @Policy_No + '%'''
	END
	IF @FHKP_Case_Id <> '' and @FHKP_Case_Id is not null
	BEGIN
		SET @STRSQL = @STRSQL + ' AND FHKP_Case_Id Like ''%' + @FHKP_Case_Id + '%'''
	END
	PRINT (@STRSQL)
	EXEC (@STRSQL)
END

