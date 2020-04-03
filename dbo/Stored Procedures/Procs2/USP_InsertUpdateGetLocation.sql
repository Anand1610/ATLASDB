CREATE PROCEDURE [dbo].[USP_InsertUpdateGetLocation]-- 'select','priya'
(
@Action varchar(10),
@DomainId varchar(50),
@Id int= null,
@Location varchar(50) =null,
@Address varchar(50) =null,
@State VARCHAR(50)= NULL,
@City VARCHAR(50)=NULL,
@ZipCode VARCHAR(50)= NULL

)

AS BEGIN
IF (@Action='Insert')
Begin
IF (@Id<=0)	

	  Insert into  tbl_Location
	   (Location,
		Address,
		State,
		City,
		ZipCode,
		Created_Date,
		DomainId		
		)
		VALUES
		 (@Location,
		@Address,
		@State,
		@City,
		@ZipCode,
		GETDATE(),
		 @DomainId		
		)			
	   SELECT SCOPE_IDENTITY()	
	

End
ELSE IF(@Action='Update')
Begin
Update tbl_Location SET 
        Location=@Location,
		Address=@Address,
		State=@State,
		City=@City,
		ZipCode=@ZipCode where Id=@id
End
ELSE IF(@Action='Select')
Begin
SELECT * FROM tbl_Location WHERE DomainId=@DomainId
END

ELSE IF(@Action='Edit')
Begin
SELECT * FROM tbl_Location WHERE id=@id
END

ElSE IF (@Action='Delete')
Begin
 DELETE From tbl_Location where id=@Id
End

END
