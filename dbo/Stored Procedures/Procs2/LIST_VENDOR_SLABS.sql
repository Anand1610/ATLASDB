
CREATE PROCEDURE [dbo].[LIST_VENDOR_SLABS]  --[SP_LIST_BILLSGRID] 'FL14-3663'          
 @ProviderId  INT         
AS                  
BEGIN                
  Select ProviderId, SlabFrom AS NewSlabFrom , SlabTo AS NewSlabTo, VendorFee AS NewVendorFEE, AmountType    
  from tblProvider_Slabs  (NOLOCK)          
  where ProviderId=@ProviderId           
END 
