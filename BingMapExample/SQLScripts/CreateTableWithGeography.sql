CREATE TABLE [dbo].[tblLocation](
	[LocationID] [int] IDENTITY(1,1) NOT NULL,
	[LocationDescription] [nvarchar](100) NOT NULL,
	[Address1] [nvarchar](50) NOT NULL,
	[Address2] [nvarchar](50) NULL,
	[Town] [nvarchar](50) NOT NULL,
	[County] [nvarchar](50) NULL,
	[Postcode] [nvarchar](10) NOT NULL,
	[Country] [nvarchar](50) NOT NULL,
	[Latitude] [decimal](10, 7) NOT NULL,
	[Longitude] [decimal](10, 7) NOT NULL,
	[SRID] [int] NOT NULL,
	-- Note:  In SQL Server 2012, you can have this computed columns based on spatial types as PERSISTED, for faster retrieval and calculations.
	[Point]  AS ([geography]::Point([Latitude],[Longitude],[SRID])),  
	
 CONSTRAINT [PK_tblLocation] PRIMARY KEY CLUSTERED 
(
	[LocationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tblLocation] ADD  CONSTRAINT [DF_tblLocation_Latitude]  DEFAULT ((0)) FOR [Latitude]
GO

ALTER TABLE [dbo].[tblLocation] ADD  CONSTRAINT [DF_tblLocation_Longitude]  DEFAULT ((0)) FOR [Longitude]
GO

