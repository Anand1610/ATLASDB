
CREATE PROCEDURE [dbo].[getProviderDetaisForInvoice] --getProviderDetaisForInvoice '4042','AF'
	@provider_id INT
	,@DomainId VARCHAR(10)
	,@Months INT
AS
BEGIN
	--SELECT	
	--		tblprovider.provider_name,
	--		tblprovider.provider_local_address +', '+
	--		tblprovider.provider_local_city+', '+
	--		tblprovider.provider_local_state+' '+ 
	--		tblprovider.provider_local_zip [provider_local_address],
	--		tblprovider.provider_billing,
	--		CASE  WHEN tblprovider.Vendor_Fee_Type ='Flat Fee'	
	--		THEN CONVERT (VARCHAR(50), tblprovider.Vendor_Fee,128) 
	--		WHEN tblprovider.Vendor_Fee_Type ='%' 
	--		THEN CONVERT (VARCHAR(50), tblprovider.Vendor_Fee,128) + '%'
	--		WHEN tblprovider.Vendor_Fee_Type IS NULL 
	--		THEN CONVERT (VARCHAR(50), 0.00,128) 
	--		END AS  VENDOR_FEE ,
	--		ISNULL(sum(Final_Remit),0) -
	--		ISNULL(sum(Payment_Amount),0) AS Cost_Balance
	-- FROM tblprovider (NOLOCK) 
	-- LEFT JOIN tblclientaccount ON tblclientaccount.Provider_Id=tblprovider.provider_id
	-- LEFT JOIN tblClientPayment ON tblClientPayment.Provider_id=tblprovider.provider_id
	-- WHERE tblprovider.provider_id=@provider_id
	-- AND tblprovider.DomainId= @DomainId
	-- GROUP BY 
	--        tblprovider.provider_name,
	--		tblprovider.provider_local_address +', '+
	--		tblprovider.provider_local_city+', '+
	--		tblprovider.provider_local_state+' '+ 
	--		tblprovider.provider_local_zip ,
	--		tblprovider.provider_billing,
	--		tblprovider.Vendor_Fee,
	--		tblprovider.Vendor_Fee_Type
	DECLARE @CostBalanace FLOAT = 0.00

	SELECT tblprovider.provider_name
		,tblprovider.provider_local_address + ', ' + tblprovider.provider_local_city + ', ' + tblprovider.provider_local_state + ' ' + tblprovider.provider_local_zip [provider_local_address]
		,tblprovider.provider_billing
		,CASE 
			WHEN tblprovider.Vendor_Fee_Type = 'Flat Fee'
				THEN CONVERT(VARCHAR(50), tblprovider.Vendor_Fee, 128)
			WHEN tblprovider.Vendor_Fee_Type = '%'
				THEN CONVERT(VARCHAR(50), tblprovider.Vendor_Fee, 128) + '%'
			WHEN tblprovider.Vendor_Fee_Type IS NULL
				THEN CONVERT(VARCHAR(50), 0.00, 128)
			END AS VENDOR_FEE
		,CAST(0.00 AS FLOAT) AS Cost_Balance
	INTO #temp
	FROM tblprovider(NOLOCK)
	WHERE tblprovider.provider_id = @provider_id
		AND tblprovider.DomainId = @DomainId

	IF (UPPER(@DomainId) = 'BT')
	BEGIN
		SELECT @CostBalanace = ISNULL((
					SELECT sum(iSNULL(tblclientaccount.Final_Remit, 0.00))
					FROM tblclientaccount(NOLOCK)
					WHERE tblclientaccount.domainid = @DomainId
						AND tblclientaccount.provider_id = @provider_id
						AND Datediff(m, Account_Date, getdate()) <= @Months
					) - ISNULL((
						SELECT sum(iSNULL(tblClientPayment.Payment_Amount, 0.00))
						FROM tblClientPayment(NOLOCK)
						WHERE tblClientPayment.domainid = @DomainId
							AND tblClientPayment.provider_id = @provider_id
						), 0.00), 0.00)
	END
	ELSE
	BEGIN
		DECLARE @Cost FLOAT = 0.00
		DECLARE @Payment FLOAT = 0.00

		SELECT @Cost = ISNULL(sum(Firm_Fees), 0)
		FROM tblclientaccount(NOLOCK)
		WHERE provider_id = @provider_id
			AND DomainId = @DomainId

		SELECT @Payment = ISNULL(sum(Payment_Amount), 0)
		FROM tblClientPayment(NOLOCK)
		WHERE provider_id = @provider_id
			AND DomainId = @DomainId

		SET @CostBalanace = @Cost - @Payment
	END

	UPDATE #temp
	SET Cost_Balance = @CostBalanace

	SELECT *
	FROM #temp
END
