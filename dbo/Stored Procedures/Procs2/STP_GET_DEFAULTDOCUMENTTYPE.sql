/* -----------------------------------------------------------------------------------------------------------------
/ ABBREVIATIONS USED  		:	START, A-ADD, U-UPDATE, D-DELETE, E-END 
/								(E.G. SA1001 FOR START ADDING NEW CONTENTS AND EA1001 FOR END ADDING)
/------------------------------------------------------------------------------------------------------------------
/ NAME OF PROCEDURE		:	DBO.[STP_GET_DEFAULTDOCUMENTTYPE]
/ PURPOSE				:	THIS PROCEDURE IS USED TO GET THE USER ID OF A USER BY PROVIDING HIS/HER EMAIL ADDRESS.
/ DEVELOPED BY			:	ADARSH K. BAJPAI
/ START DATE			: 	17 FEB 2008
/ REVIEWED BY			:	
/ REVIEW DATE			:	
/ PARAMETER(S)			:	(A) INPUT	: NA
/							(B) OUTPUT	: NA
/
/ EXECUTION PROCEDURE	:	EXEC [STP_GET_DEFAULTDOCUMENTTYPE]
/-------------------------------------------------- CHANGE HISTORY -------------------------------------------------
/ CHANGE ID	CALL NO.	CHANGE DATE	DEVELOPER'S NAME	PURPOSE OF CHANGE
/-------------------------------------------------------------------------------------------------------------------
/ 
/------------------------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[STP_GET_DEFAULTDOCUMENTTYPE]
AS
declare @maxID INTEGER,
@parentID Integer

Create Table #tmpDocType(ID Int Identity(1,1), TypeName NVarchar(255),ParentID Int, NodeLevel Int, ImageURL NVarchar(255))

Set Identity_Insert  #tmpDocType on

INSERT INTO #tmpDocType(ID, TypeName,ParentID,NodeLevel,ImageURL) VALUES (0,'Not Available',NULL,0,'ROOT.gif')

Set Identity_Insert  #tmpDocType off

set @parentID=0

INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('INTAKE',@parentID,0,'folders.gif')
set @maxID=@@Identity
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Intake Sheet',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Retainer',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Identification',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Insurance Card',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Power of Attorney',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Consent to Change Attorney',@maxid,1,'folder.gif')

------------------------------------------------------------------------

INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('NO FAULT',@parentID,0,'folders.gif')
set @maxID=@@Identity
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('No Fault Application',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('No Fault File',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Lost Wages',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('IMEs',@maxid,1,'folder.gif')

---------------------------------------------------------------------------

INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('PROPERTY DAMAGE',@parentID,0,'folders.gif')

---------------------------------------------------------------------------

INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('WORKERS’ COMPENSATION',@parentID,0,'folders.gif')

set @maxID=@@Identity

	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('IMEs',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Lost Wages',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Workers Comp File',@maxid,1,'folder.gif')

---------------------------------------------------------------------------
INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('MEDICALS',@parentID,0,'folders.gif')
set @maxID=@@Identity
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Medical Records',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Hospital Records',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('MRIs',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('EMGs',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Dates of Treatment',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Experts',@maxid,1,'folder.gif')

---------------------------------------------------------------------------

INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('INVESTIGATIONS',@parentID,0,'folders.gif')
set @maxID=@@Identity
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Police Report',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Property Search',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Witness Statements',@maxid,1,'folder.gif')

---------------------------------------------------------------------------

INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('PHOTOGRAPHS',@parentID,0,'folders.gif')

---------------------------------------------------------------------------

INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('CORRESPONDENCE',@parentID,0,'folders.gif')

---------------------------------------------------------------------------

INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('PLEADINGS',@parentID,0,'folders.gif')

set @maxID=@@Identity

	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Notice of Claim',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Summons & Complaint',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Affidavit of Services',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Bill of Particulars',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Answers',@maxid,1,'folder.gif')

---------------------------------------------------------------------------

INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('DISCOVERY-PLAINTIFF',@parentID,0,'folders.gif')

set @maxID=@@Identity

	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('PC Letter',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Expert Exchange',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Discovery Demands',@maxid,1,'folder.gif')
	
---------------------------------------------------------------------------

INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('DISCOVERY-DEFENDANT',@parentID,0,'folders.gif')

set @maxID=@@Identity

	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('PC Response',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Expert Exchange',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Photographs from Defendant',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Discovery Demands',@maxid,1,'folder.gif')

---------------------------------------------------------------------------

INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('MOTIONS',@parentID,0,'folders.gif')

set @maxID=@@Identity

	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Plaintiffs motions',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Affirmation in Opposition',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Defendants motions',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Affirmation in Opposition',@maxid,1,'folder.gif')

---------------------------------------------------------------------------

INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('COURT',@parentID,0,'folders.gif')

set @maxID=@@Identity

	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Orders',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Memos',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Filings',@maxid,1,'folder.gif')

	set @maxID=@@Identity

		INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Summons',@maxid,2,'notes.gif')
		INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('RJI',@maxid,2,'notes.gif')
		INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Note of Issue',@maxid,2,'notes.gif')

---------------------------------------------------------------------------

INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('TRANSCRIPTS',@parentID,0,'folders.gif')

set @maxID=@@Identity

	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Plaintiff(s)',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Defendant(s)',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('50-H',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('EUO',@maxid,1,'folder.gif')

---------------------------------------------------------------------------

INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('TRIAL PREPARATION',@parentID,0,'folders.gif')

set @maxID=@@Identity

	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Subpoenas',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Note of Issue Review',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('4532A Exchange',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('3122A Exchange',@maxid,1,'folder.gif')

---------------------------------------------------------------------------

INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('EXPENSE',@parentID,0,'folders.gif')

set @maxID=@@Identity
	
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Check stubs',@maxid,1,'folder.gif')

---------------------------------------------------------------------------

INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('LIENS',@parentID,0,'folders.gif')

---------------------------------------------------------------------------

INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('CLOSING PAPERS',@parentID,0,'folders.gif')

set @maxID=@@Identity

	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Closing Statements',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Closing Statement Checks',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Disbursement Checks',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Release',@maxid,1,'folder.gif')
	INSERT INTO #tmpDocType(TypeName,ParentID,NodeLevel,ImageURL) VALUES ('Stip of Discontinuance',@maxid,1,'folder.gif')

SELECT CAST(ID AS NVARCHAR) ID,CAST(ID AS NVARCHAR) + ' | ' + TypeName as TypeName,CAST(ParentID AS NVARCHAR) ParentID,NodeLevel,ImageURL  FROM #tmpDocType 

DROP TABLE #tmpDocType

