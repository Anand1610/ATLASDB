/* -----------------------------------------------------------------------------------------------------------------
/ ABBREVIATIONS USED  		:	START, A-ADD, U-UPDATE, D-DELETE, E-END 
/								(E.G. SA1001 FOR START ADDING NEW CONTENTS AND EA1001 FOR END ADDING)
/------------------------------------------------------------------------------------------------------------------
/ NAME OF PROCEDURE		:	DBO.[STP_DSP_APPLICATION_SETTINGS]
/ PURPOSE				:	THIS PROCEDURE IS USED TO DISPLAY/GET VALUES FROM APPLICATION SETTINGS
/ DEVELOPED BY			:	KAMAL GARG
/ START DATE			: 	22 JAN 2007
/
/ PARAMETER(S)			:	(A) INPUT	: NA
/							(B) OUTPUT	: NA
/
/ EXECUTION PROCEDURE	:	EXEC [STP_DSP_APPLICATION_SETTINGS]
/-------------------------------------------------- CHANGE HISTORY -------------------------------------------------
/ CHANGE ID	CALL NO.	CHANGE DATE	DEVELOPER'S NAME	PURPOSE OF CHANGE
/-------------------------------------------------------------------------------------------------------------------
/ 
/------------------------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[STP_DSP_APPLICATION_SETTINGS]
		
AS
-----------------------------------------------------------------------------
BEGIN
		SELECT		
				PARAMETERID,
				PARAMETERNAME,
				PARAMETERVALUE,
				DISPLAYNAME
			
		FROM 	tblAPPLICATIONSETTINGS
	

END
--------------------------------------------------------------------------------------------------------------------

