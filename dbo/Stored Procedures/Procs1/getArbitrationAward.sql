--getArbitrationAward @pid = '40654',@iid = '8626'

CREATE PROCEDURE [dbo].[getArbitrationAward](
@pid varchar(50),
@iid int
)
as
begin

seLect * fRoM tblDocImages 
left outer join tblImageTag 
on tblDocImages.imageid=tblImageTag.imageid
left outer join tblTags 
on tblTags.NodeID = tblImageTag.TagID
inner join dbo.tbltransactions 
on tblTags.CaseID =tbltransactions.case_id 
where provider_id = @pid and invoice_id = @iid and transactions_type = 'C'
and NodeName ='Arbitration Awards'
---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
    
AND tblDocImages.IsDeleted=0 AND tblImageTag.IsDeleted=0  
---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  


end

