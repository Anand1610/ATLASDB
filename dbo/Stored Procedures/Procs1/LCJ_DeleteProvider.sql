CREATE PROCEDURE [dbo].[LCJ_DeleteProvider]
(
@DomainId nvarchar(50),
@Provider_Id int,
@OperationResult INT OUTPUT

)


AS

		IF EXISTS(Select Provider_Id  
		
			FROM  tblcase 
			WHERE 
			Provider_Id = @Provider_Id
			and DomainId = @DomainId
		
			  
		)

			BEGIN
				SET @OperationResult = 1
				Return 1
				
			END
	
		ELSE
			BEGIN
				DELETE from tblProvider  where Provider_Id = @Provider_Id and DomainId = @DomainId
				SET @OperationResult = 0
				Return 0
			END

