  
-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[Get_InvoicePayment_Documents]  -- [Get_InvoicePayment_Documents] 'glf',7,3850,'admin'
 -- Add the parameters for the stored procedure here  
 (
 @DomainId nvarchar(50),  
 @Payment_Id int,  
 @DocType nvarchar(100)
   )
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
 select concat(replace(VirtualBasePath, '/', '\'),'\',InvPay_File_Path,InvPay_Doc_Name) as INVPayFile,CreatedBy,CreatedDate   
 from tblInvoicePayment_Documents (NOLOCK)  
 inner join tblBasePath b (NOLOCK) on b.BasePathId = tblInvoicePayment_Documents.BasePathId
 --inner join tblApplicationSettings on tblInvoicePayment_Documents.DomainId=tblApplicationSettings.DomainId  
 where tblInvoicePayment_Documents.DomainId=@DomainId AND Payment_Id=@Payment_Id AND DocType=@DocType   
 --AND ParameterName='DocumentUploadLocation'  
  
  
   
END  
----------------------------------------------------------------------------------------------------------------------------------

