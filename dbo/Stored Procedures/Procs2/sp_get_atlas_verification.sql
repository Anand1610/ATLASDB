CREATE PROCEDURE [dbo].[sp_get_atlas_verification]
@Domain nvarchar(50),
@ID bigint=null

as
begin

select vr.I_VERIFICATION_ID [ID],DT_VERIFICATION_RECEIVED [Date],SZ_NOTES [Desc],tre.BILL_NUMBER [Bill] from TXN_VERIFICATION_REQUEST vr
INNER JOIN tblTreatment tre ON  vr.SZ_CASE_ID = tre.Case_Id where tre.DomainID=@Domain 
and I_VERIFICATION_ID>@ID

select
RequestImageFileName=RI.Filename,
		RequestImageFileVirtualPath=RIBP.VirtualBasePath+RI.FilePath+RI.Filename,
		ID=vr.I_VERIFICATION_ID ,
		PhysicalPath=RIBP.PhysicalBasePath+RI.FilePath+RI.Filename
	from
		TXN_VERIFICATION_REQUEST VR (NOLOCK)
		 JOIN tblDocImages RI (NOLOCK) ON RI.ImageID = VR.RequestImageID AND RI.DomainId = @Domain
		 JOIN tblBasePath RIBP (NOLOCK) ON RIBP.BasePathId = RI.BasePathId
		   ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
           AND RI.IsDeleted=0  
         ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude 
		 where  I_VERIFICATION_ID>@ID and vr.DomainID=@Domain
		 select * from tblBasePath

end




