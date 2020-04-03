CREATE PROCEDURE [dbo].[F_Case_Settlements_Retrive] 
(
	@s_a_case_id NVARCHAR(100)
)
AS
BEGIN		

---------------Table 0 START---------------------------
		SELECT 
			Cas.Claim_Amount,
			Cas.Fee_Schedule,
			Cas.Paid_Amount
		FROM
			Tblcase Cas
		WHERE
			Cas.Case_Id = @s_a_case_id
---------------Table 0 END---------------------------			
		SELECT 
			Cas.Claim_Amount,
			Cas.Fee_Schedule,
			Cas.Paid_Amount,
			Sett.Settlement_Amount,
			Sett.Settlement_Af, 
			Settlement_Int,
			Settlement_Ff,
			Settlement_Total,
			Case When Settled_by='0' Then 'Claim Amount'
			     When Settled_by = '1' Then 'Fee Schedule'
			     Else '' END AS Settled_by,
			SettledWith,
			Settlement_Amount,
			Settlement_Int,
			Settlement_Af,
			Settlement_Ff,
			ISNULL(Settlement_Amount,0) + ISNULL(Settlement_Int, 0)+ISNULL(Settlement_Af, 0)+ISNULL(Settlement_Ff ,0) AS Settlement_Total
			
		FROM Tblsettlements Sett
		INNER JOIN tblcase Cas ON Cas.Case_Id=Sett.Case_Id WHERE  Sett.Case_Id in (Replace(@s_a_case_id,',',''','''))
END

