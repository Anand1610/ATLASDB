/* -----------------------------------------------------------------------------------------------------------------  
 ABBREVIATIONS USED    : START, A-ADD, U-UPDATE, D-DELETE, E-END   
     (E.G. SA1001 FOR START ADDING NEW CONTENTS AND EA1001 FOR END ADDING)  
------------------------------------------------------------------------------------------------------------------  
 NAME OF PROCEDURE  :	DBO.STP_GET_APPLICATION_SETTINGS  
  
 PURPOSE			:	THIS PROCEDURE WILL BE USED TO RETRIEVE APPLICATION SETINGS VALUE FOR  
						SPECIFIED PARAMETER  
  
 DEVELOPED BY		:	ADARSH KR. BAJPAI  
  
 START DATE			:	12 DECEMBER 2007  
  
 PARAMETER(S)		:	(A) INPUT : PARAMETER NAME  
  
						(B) OUTPUT : PARAMETER VALUE  
  
EXECUTION PROCEDURE	: 	DECLARE @PARAMETERVALUE VARCHAR(512)  
     					EXEC STP_GET_APPLICATION_SETTINGS 'TempMailAttachmentFileStoragePath',@PARAMETERVALUE OUT  
     					SELECT @PARAMETERVALUE  
  
-------------------------------------------------- CHANGE HISTORY -------------------------------------------------  
 CHANGE ID CALL NO. CHANGE DATE DEVELOPER'S NAME PURPOSE OF CHANGE  
-------------------------------------------------------------------------------------------------------------------  
   
------------------------------------------------------------------------------------------------------------------*/  
  
CREATE PROCEDURE  [dbo].[STP_GET_APPLICATION_SETTINGS]  
@DomainId NVARCHAR(50),
@PARAMETERNAME VARCHAR(50),  
@PARAMETERVALUE VARCHAR(512) OUTPUT  
AS  
  
SET NOCOUNT ON  
BEGIN  
	SET @PARAMETERVALUE=''

 	SELECT @PARAMETERVALUE=PARAMETERVALUE FROM tblApplicationSettings  WHERE UPPER(PARAMETERNAME)=UPPER(@PARAMETERNAME) and DomainId=@DomainId
END

