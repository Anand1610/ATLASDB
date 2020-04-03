CREATE PROCEDURE [dbo].[F_Get_AnswerExpected_Sheet]		--F_Get_AnswerExpected_Sheet
AS
BEGIN
	SET NOCOUNT ON;
		  select Case_Id,
		  provider_name,
		  ISNULL(cas.InjuredParty_FirstName, N'') + N'  ' + ISNULL(cas.InjuredParty_LastName, N'')   AS injuredparty_name,
		  insurancecompany_name,
		  indexoraaa_number,
		  dateofservice_start,
		  dateofservice_end,
		  CONVERT(money, ISNULL(cas.Claim_Amount, 0))     
                      - CONVERT(float, ISNULL(cas.Paid_Amount, 0)) AS balance_amount,
		  Convert(VARCHAR(10),accident_date,101) AS accident_date,
		  Convert(VARCHAR(10),Date_Opened,101) AS Date_Opened,
		  Convert(VARCHAR(10),date_summons_Sent_court,101) AS date_summons_Sent_court,
		  Convert(VARCHAR(10),date_index_number_purchased,101) AS date_index_number_purchased,
		  Convert(VARCHAR(10),Served_On_Date,101) AS Served_On_Date,
		  Convert(VARCHAR(10),Date_Afidavit_Filed,101) AS Date_Afidavit_Filed,
		  Convert(VARCHAR(10),Date_Ext_Of_Time,101) AS Date_Ext_Of_Time,
		  Convert(VARCHAR(10),Date_Ext_Of_Time_2,101) AS Date_Ext_Of_Time_2,
		  Convert(VARCHAR(10),Date_Ext_Of_Time_3,101) AS Date_Ext_Of_Time_3,
		  Case WHEN Date_Ext_Of_Time_3 is NOT null THEN Convert(VARCHAR(10),Date_Ext_Of_Time_3 +5,101)
				WHEN Date_Ext_Of_Time_2 is NOT null THEN Convert(VARCHAR(10),Date_Ext_Of_Time_2 +5,101)     
				WHEN Date_Ext_Of_Time is NOT null THEN Convert(VARCHAR(10),Date_Ext_Of_Time +5,101) 
				WHEN insurancecompany_name like '%GEICO%' OR InsuranceCompany_Name like 'GOVERNMENT EMPLOYEES%' THEN Convert(VARCHAR(10),Served_On_Date +65,101)
				ELSE Convert(VARCHAR(10),Date_Afidavit_Filed +45,101)
		  END AS [date_answer_due]
	from tblCase cas with(nolock)
	INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON cas.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id 
    INNER JOIN dbo.tblProvider WITH (NOLOCK) ON cas.Provider_Id = dbo.tblProvider.Provider_Id 

	WHERE  ISNULL(cas.IsDeleted,0) = 0 AND
	status='AFFIDAVITS FILED IN COURT'
	AND
	Case WHEN Date_Ext_Of_Time_3 is NOT null THEN Convert(VARCHAR(10),Date_Ext_Of_Time_3 +5,101)
				WHEN Date_Ext_Of_Time_2 is NOT null THEN Convert(VARCHAR(10),Date_Ext_Of_Time_2 +5,101)     
				WHEN Date_Ext_Of_Time is NOT null THEN Convert(VARCHAR(10),Date_Ext_Of_Time +5,101) 
				WHEN insurancecompany_name like '%GEICO%' OR InsuranceCompany_Name like 'GOVERNMENT EMPLOYEES%' THEN Convert(VARCHAR(10),Served_On_Date +65,101)
				ELSE Convert(VARCHAR(10),Date_Afidavit_Filed +45,101)
	END  is not null
	AND
	DATEDIFF(DD,
	Case WHEN Date_Ext_Of_Time_3 is NOT null THEN Convert(VARCHAR(10),Date_Ext_Of_Time_3 +5,101)
				WHEN Date_Ext_Of_Time_2 is NOT null THEN Convert(VARCHAR(10),Date_Ext_Of_Time_2 +5,101)     
				WHEN Date_Ext_Of_Time is NOT null THEN Convert(VARCHAR(10),Date_Ext_Of_Time +5,101) 
				WHEN insurancecompany_name like '%GEICO%' OR InsuranceCompany_Name like 'GOVERNMENT EMPLOYEES%' THEN Convert(VARCHAR(10),Served_On_Date +65,101)
				ELSE Convert(VARCHAR(10),Date_Afidavit_Filed +45,101)
	END,getdate()) < 365
END

