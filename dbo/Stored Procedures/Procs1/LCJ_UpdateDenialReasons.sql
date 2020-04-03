CREATE PROCEDURE [dbo].[LCJ_UpdateDenialReasons]
(
@DomainId NVARCHAR(50),
--Adjuster_Id	nvarchar	no	100
@DenialReasons_id int=null,

@Denial_Colorcode	nvarchar(50)=null

--@OperationResult INTEGER OUT
)
AS
BEGIN
	
	BEGIN


		-- Insert the records
		BEGIN TRAN
			
		update  tblDenialReasons 
		set 
	
		Denial_Colorcode=@Denial_Colorcode	,
		DomainId=@DomainId
		where DenialReasons_id=@DenialReasons_id		

		COMMIT TRAN

	END -- END of ELSE	

END

