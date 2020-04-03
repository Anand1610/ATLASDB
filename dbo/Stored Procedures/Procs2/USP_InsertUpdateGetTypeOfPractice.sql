CREATE PROCEDURE [dbo].[USP_InsertUpdateGetTypeOfPractice]-- 'select','priya'
(
@Action varchar(10),
@DomainId varchar(50),
@Id int= null,
@Name varchar(50) =null,
@Description varchar(50) =null
)

AS BEGIN
IF (@Action='Insert')
Begin
IF (@Id<=0)	

	  Insert into  tbl_TypeOfPractice
	   (Name,
	    Description,
		Created_Date,
		DomainId		
		)
		VALUES
		 (@Name,
		 @Description,		
		 GETDATE(),
		 @DomainId		
		)			
	   SELECT SCOPE_IDENTITY()	
End
ELSE IF(@Action='Update')
Begin
Update tbl_TypeOfPractice SET 
        Name=@Name,Description=@Description where Id=@id
End

ELSE IF(@Action='Select')
Begin
SELECT * FROM tbl_TypeOfPractice WHERE DomainId=@DomainId
END

ELSE IF(@Action='Edit')
Begin
SELECT* FROM tbl_TypeOfPractice WHERE id=@id
END

ElSE IF (@Action='Delete')
Begin
 DELETE From tbl_TypeOfPractice where id=@Id
End

END
