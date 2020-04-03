CREATE PROCEDURE [dbo].[USP_InsertUpdateGetAttorneyFirm]
(
@Action varchar(10),
@DomainId varchar(50),
@Id int= null,
@Name varchar(50)=null,
@LocationId int =null,
@Type_Of_Practice int =null
)

AS BEGIN
IF (@Action='Insert')
Begin
IF (@Id<=0)	
	--IF Not EXISTS(Select count(*) from tbl_Program where Name=@Name AND DomainId=@DomainId)	
	--BEGIN
	  Insert into  tbl_AttorneyFirm
	   (Name,
		LocationId,
		Type_Of_Practice,
		Created_Date,
		DomainId		
		)
		VALUES
		 (@Name,
		 @LocationId,
		 @Type_Of_Practice,
		 GETDATE(),
		 @DomainId		
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
Update tbl_AttorneyFirm SET
	Name=@Name,
	LocationId=@LocationId,
	Type_Of_Practice=@Type_Of_Practice,
	DomainId=@DomainId
	Where Id=@Id

	select @Id
End	

End
ELSE IF(@Action='Select')
Begin
SELECT AF.ID, AF.Name, AF.LocationId,AF.Type_Of_Practice,L.Location,P.Name 'Practice' FROM tbl_AttorneyFirm AF
left join tbl_Location L ON L.Id=AF.LocationId
LEFT JOIN tbl_TypeOfPractice P ON P.Id =AF.Type_Of_Practice  WHERE AF.DomainId=@DomainId
END

ELSE IF(@Action='Edit')
Begin
SELECT * FROM tbl_AttorneyFirm WHERE id=@id
END

ElSE IF (@Action='Delete')
Begin
 DELETE From tbl_AttorneyFirm where id=@Id
End

END
