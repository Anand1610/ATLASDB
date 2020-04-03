CREATE PROCEDURE [dbo].[USP_InsertUpdateGetProgram]
(
@Action varchar(10),
@Id int= null,
@Advance_Rate decimal(18,2) =null,
@Buyout bit=null,
@Fixed_Fee_Rate decimal(18,2) =null,
@Fixed_Fee_Rate_Time int =null,
@Period_Fee_Rate  decimal(18,2) =null,
@Period_Fee_Time_Frame int=null,
@DomainId varchar(50),
@Name varchar(50)=null
)

AS BEGIN

IF (@Action='Insert')
Begin
IF (@Id<=0)	
	--IF Not EXISTS(Select count(*) from tbl_Program where Name=@Name AND DomainId=@DomainId)	
	--BEGIN
	  Insert into  tbl_Program
	   (Advance_Rate,
		Buyout,
		Fixed_Fee_Rate,
		Fixed_Fee_Rate_Time,
		Period_Fee_Rate,
		Period_Fee_Time_Frame,
		Created_Date,
		DomainId,
		Name
		)
		VALUES
		 (@Advance_Rate,
		@Buyout,
		@Fixed_Fee_Rate,
		@Fixed_Fee_Rate_Time,
		@Period_Fee_Rate,
		@Period_Fee_Time_Frame,
		GETDATE(),
		@DomainId,
		@Name
		)	
		--END
	   SELECT SCOPE_IDENTITY()	
	--ELSE	 
	--SELECT -2		 

End

ELSE IF(@Action='Update')
begin
IF(@Id>0)
Begin
Update tbl_Program SET
		Name=@Name,
		Advance_Rate=@Advance_Rate,
		Buyout=@Buyout,
		Fixed_Fee_Rate=@Fixed_Fee_Rate,
		Fixed_Fee_Rate_Time=@Fixed_Fee_Rate_Time,
		Period_Fee_Rate=@Period_Fee_Rate,
		Period_Fee_Time_Frame=@Period_Fee_Time_Frame,
		DomainId=@DomainId
		Where Id=@Id

		select @Id
End	

End
ELSE IF(@Action='Select')
Begin
SELECT * FROM tbl_Program WHERE DomainId=@DomainId
END

ELSE IF(@Action='Edit')
Begin
SELECT ID,Name, Advance_Rate,
Buyout,Fixed_Fee_Rate,Fixed_Fee_Rate_Time,Period_Fee_Rate,Period_Fee_Time_Frame FROM tbl_Program WHERE id=@id
END

ElSE IF (@Action='Delete')
Begin
 DELETE From tbl_Program where id=@Id
End

END
