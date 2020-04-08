--getProviderChecks @pid = '40753',@iid = '8623'

CREATE PROCEDURE [dbo].[getProviderChecks](
@DomainId NVARCHAR(50),
@pid varchar(50),
@iid int
)
as
begin

seLect * fRoM tblDocImages 
left outer join tblImageTag 
on tblDocImages.imageid=tblImageTag.imageid
---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
	AND tblDocImages.IsDeleted=0 AND  tblImageTag.IsDeleted=0	
---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
left outer join tblTags 
on tblTags.NodeID = tblImageTag.TagID
inner join dbo.tbltransactions 
on tblTags.CaseID =tbltransactions.case_id 
where provider_id = @pid and invoice_id = @iid and transactions_type = 'C'
and NodeName ='PAYMENTS - PROVIDER'
and tblDocImages.imageid not in(295161,293736)
and tblDocImages.DomainId=@DomainId


end

