CREATE TABLE [dbo].[tblMotion_Status] (
    [motion_status_id] SMALLINT       IDENTITY (1, 1) NOT NULL,
    [status_desc]      VARCHAR (50)   NOT NULL,
    [status_hierarchy] SMALLINT       CONSTRAINT [DF_tblMotion_Status_status_hierarchy] DEFAULT ((0)) NOT NULL,
    [DomainId]         NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

