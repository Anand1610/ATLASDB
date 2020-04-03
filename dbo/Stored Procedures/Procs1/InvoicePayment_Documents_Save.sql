

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[InvoicePayment_Documents_Save] 
	-- Add the parameters for the stored procedure here
	@InvPay_Doc_Name nvarchar(100),
	@InvPay_File_Path nvarchar(200),
	@Provider_Id int,
	@Payment_Id int,
	@CreatedBy nvarchar(50),
	@DomainId nvarchar(50),
	@DocType nvarchar(100),
	@BasePathId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Insert into tblInvoicePayment_Documents(InvPay_Doc_Name,InvPay_File_Path,Provider_Id,Payment_Id,CreatedBy,CreatedDate,DomainId,DocType, BasePathId)
	values (@InvPay_Doc_Name,@InvPay_File_Path,@Provider_Id,@Payment_Id,@CreatedBy,GETDATE(),@DomainId,@DocType, @BasePathId)
END


