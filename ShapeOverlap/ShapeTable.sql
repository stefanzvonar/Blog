USE [MapExample]
GO

/****** Object:  Table [dbo].[tblShape]    Script Date: 3/03/2013 2:34:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblShape](
	[ID] [int] NOT NULL,
	[Description] [varchar](100) NOT NULL,
	[Shape] [geometry] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


