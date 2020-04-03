CREATE TABLE [dbo].[TblReviews] (
    [Review_id]     INT            IDENTITY (1, 1) NOT NULL,
    [Case_id]       VARCHAR (50)   NOT NULL,
    [Review_Doctor] INT            NOT NULL,
    [Review_Date]   DATETIME       NOT NULL,
    [Service_type]  TINYINT        NOT NULL,
    [Review_Notes]  VARCHAR (500)  NULL,
    [User_id]       VARCHAR (50)   NOT NULL,
    [DomainId]      NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    CONSTRAINT [PK_TblReviews] PRIMARY KEY CLUSTERED ([Review_id] ASC)
);

