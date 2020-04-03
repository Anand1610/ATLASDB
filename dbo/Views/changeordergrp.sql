CREATE VIEW [dbo].[changeordergrp]
AS
SELECT     Case_Id, InjuredParty_LastName, InjuredParty_FirstName, Policy_Number, Ins_Claim_Number, Accident_Date, Claim_Amount, Paid_Amount, 
                      Group_All, Caption, Group_Accident, Group_InsClaimNo, Group_PolicyNum, Group_ClaimAmt
FROM         dbo.tblCase
WHERE     (Group_Id IN
                          (SELECT     group_id
                            FROM          tblcase
                            WHERE      Case_Id LIKE '%250.119%'))
