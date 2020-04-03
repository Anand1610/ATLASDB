CREATE PROCEDURE [dbo].[LCJ_SettlementDetails]  
   
 (  
  @DomainId VARCHAR(40),  
  @Case_Id VARCHAR(40)  
    
 )  
  
AS  
  
BEGIN  
 SET NOCOUNT ON
 

 SELECT    ISNULL(a.InjuredParty_FirstName, N'') + N'  ' + ISNULL(a.InjuredParty_LastName, N'')
	AS InjuredParty_Name,
	Claim_Amount,
	Fee_Schedule,
	Paid_Amount,
	Settlement_Principal,
	Settlement_Interest,
	
	 (SELECT   SUM(ISNULL(DeductibleAmount,0.00))     
                       FROM  dbo.tblTreatment  WITH(nolock)  
                       WHERE    Case_Id = a.Case_Id and domainid=@DomainId) AS Deductible_Amount,
	b.settlement_notes
	FROM      tblcase a WITH (NOLOCK)
	INNER JOIN dbo.tblProvider WITH (NOLOCK) ON a.Provider_Id = dbo.tblProvider.Provider_Id 
	left join tblSettlements  b WITH (NOLOCK) on a.case_id=b.case_id and a.DomainId=b.DomainId
	WHERE    a.Case_Id = @Case_Id
	AND a.DomainId = @DomainId

  SET NOCOUNT OFF
END  
  