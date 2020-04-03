/****** Object:  Stored Procedure dbo.LCJ_DeleteNotesType    Script Date: 3/14/2008 9:52:10 AM ******/




CREATE PROCEDURE [dbo].[LCJ_DeleteNotesType]
(

@Notes_Type nvarchar(300)

)


AS
DELETE from tblNotesType where Notes_Type = + Rtrim(Ltrim(@Notes_Type))

