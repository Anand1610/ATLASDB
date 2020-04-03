/****** Object:  Stored Procedure dbo.LCJ_DeleteCPTCode    Script Date: 3/12/2008 9:52:10 AM ******/




CREATE PROCEDURE [dbo].[LCJ_DeleteCPTCode]
(

@CPT_Code nvarchar(50)

)


AS
DELETE from tblCPT where CPT_Code = + Rtrim(Ltrim(@CPT_Code))

