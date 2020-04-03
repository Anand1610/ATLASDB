CREATE PROCEDURE [dbo].[Testing]
AS

Declare     @Nodeid int,
            @Caseid nvarchar(50)


Declare curP cursor For

select nodeid,caseid from tblTags where ParentID is null

OPEN curP 
Fetch Next From curP Into @Nodeid, @Caseid

While @@Fetch_Status = 0 Begin    

    update tblTags SET ParentID =@Nodeid
    where CaseID =@Caseid and ParentID is not null


Fetch Next From curP Into @Nodeid, @Caseid

End -- End of Fetch

Close curP
Deallocate curP

