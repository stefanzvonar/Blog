CREATE TABLE [dbo].[tblLocation](
    [LocationID] [int] IDENTITY(1,1) NOT NULL,
    [LocationDescription] [nvarchar](100) NOT NULL,
    [Address1] [nvarchar](50) NOT NULL,
    [Address2] [nvarchar](50) NULL,
    [Town] [nvarchar](50) NOT NULL,
    [County] [nvarchar](50) NULL,
    [Postcode] [nvarchar](10) NOT NULL,
    [Country] [nvarchar](50) NOT NULL,
    [Latitude] [decimal](10, 7) NOT NULL CONSTRAINT [DF_tblLocation_Latitude]  DEFAULT ((0)),
    [Longitude] [decimal](10, 7) NOT NULL CONSTRAINT [DF_tblLocation_Longitude]  DEFAULT ((0))
 CONSTRAINT [PK_tblLocation] PRIMARY KEY CLUSTERED
(
    [LocationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, 
ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO