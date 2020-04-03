CREATE TABLE [dbo].[MST_Service_Rendered_Location] (
    [Location_Id]      INT            IDENTITY (1, 1) NOT NULL,
    [Provider_Id]      INT            NULL,
    [Location_Address] VARCHAR (200)  NULL,
    [Location_City]    VARCHAR (100)  NULL,
    [Location_State]   VARCHAR (100)  NULL,
    [Location_Zip]     VARCHAR (10)   NULL,
    [DomainId]         NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

