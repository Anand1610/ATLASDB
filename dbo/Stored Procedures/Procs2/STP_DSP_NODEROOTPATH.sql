/* -----------------------------------------------------------------------------------------------------------------
/ ABBREVIATIONS USED  		:	START, A-ADD, U-UPDATE, D-DELETE, E-END 
/								(E.G. SA1001 FOR START ADDING NEW CONTENTS AND EA1001 FOR END ADDING)
/------------------------------------------------------------------------------------------------------------------
/ NAME OF PROCEDURE		:	DBO.STP_DSP_NODEROOTPATH
/ PURPOSE				:	RETURNS COMPLET PATH OF SELECTED NOT START FROM CURRENT LEVEL TILL PARENT NODE
/ DEVELOPED BY			:	ADARSH KR. BAJPAI
/ START DATE			: 	14 DECEMBER 2007
/
/ PARAMETER(S)			:	(A) INPUT	: TAGID INT
/							(B) OUTPUT	: FOLDER PATH
/
/ EXECUTION PROCEDURE	:	DECLARE @PATH AS NVARCHAR(255)
							EXEC STP_DSP_NODEROOTPATH 5, @PATH OUT
							SELECT @PATH

/-------------------------------------------------- CHANGE HISTORY -------------------------------------------------
/ CHANGE ID	CALL NO.	CHANGE DATE	DEVELOPER'S NAME	PURPOSE OF CHANGE
/-------------------------------------------------------------------------------------------------------------------
/ 
/------------------------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[STP_DSP_NODEROOTPATH]--54729,'ZDMDM-SOT-0705'
@NODEID INT, 
@PATH  NVARCHAR(255) OUTPUT
AS

DECLARE @NODELEVEL AS INT
DECLARE @NID AS INT
DECLARE @PID AS INT
DECLARE @NODENAME AS NVARCHAR(255)
DECLARE @CASEID AS NVARCHAR(50)

BEGIN

	SET @PATH=''
	SET @NODELEVEL=0

	SELECT @NODELEVEL=ISNULL(NODELEVEL,0), @CASEID=CASEID FROM TBLTAGS WHERE NODEID=@NODEID
	

	WHILE @NODELEVEL>0
	BEGIN

		SELECT @NID=NODEID, @PID=PARENTID, @NODENAME=NODENAME,@NODELEVEL=ISNULL(NODELEVEL,0) FROM TBLTAGS WHERE NODEID=@NODEID

		if @NODELEVEL>0		
			SET @PATH= @NODENAME + '/' + @PATH 

		SET @NODEID=@PID
	END
	
	--IF @PATH=''
		SET @PATH=@CASEID+'/' + @PATH 
	--SET @PATH=@CASEID+'/'+@PATH 
END

