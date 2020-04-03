CREATE TABLE [dbo].[tblTriggerTypeErrorNotificationUsers] (
    [AutoId]   INT          IDENTITY (1, 1) NOT NULL,
    [UserId]   BIGINT       NULL,
    [DomainId] VARCHAR (50) NULL,
    [IsActive] BIT          NULL,
    CONSTRAINT [PK_tblTriggerTypeErrorNotificationUsers] PRIMARY KEY CLUSTERED ([AutoId] ASC)
);

