USE [master]
GO
/****** Object:  Database [Movies]    Script Date: 12/21/2021 12:12:10 AM ******/
CREATE DATABASE [Movies]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Movies', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Movies.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Movies_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Movies_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Movies] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Movies].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Movies] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Movies] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Movies] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Movies] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Movies] SET ARITHABORT OFF 
GO
ALTER DATABASE [Movies] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Movies] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Movies] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Movies] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Movies] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Movies] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Movies] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Movies] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Movies] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Movies] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Movies] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Movies] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Movies] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Movies] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Movies] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Movies] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Movies] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Movies] SET RECOVERY FULL 
GO
ALTER DATABASE [Movies] SET  MULTI_USER 
GO
ALTER DATABASE [Movies] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Movies] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Movies] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Movies] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Movies] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Movies] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Movies', N'ON'
GO
ALTER DATABASE [Movies] SET QUERY_STORE = OFF
GO
USE [Movies]
GO
/****** Object:  UserDefinedFunction [dbo].[CurrentYear]    Script Date: 12/21/2021 12:12:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CurrentYear]()
RETURNS INT
AS
BEGIN
	RETURN year(GetDate())
END
GO
/****** Object:  UserDefinedFunction [dbo].[format_currency]    Script Date: 12/21/2021 12:12:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[format_currency] (@monetary_value decimal(20,2) ) returns varchar(20)
as
begin
	declare @return_value varchar(20)
	declare @is_negative bit
	select @is_negative = case when @monetary_value<0 then 1 else 0 end

	if @is_negative = 1
		set @monetary_value = -1*@monetary_value

	set @return_value = convert(varchar, isnull(@monetary_value, 0))
	
	
		--------------------------------------------------------------------------------
		





	--------------------------------------------------------------------------------
	

	declare @before varchar(20), @after varchar(20)

	if charindex ('.', @return_value )>0 
	begin
		set @after= substring(@return_value,  charindex ('.', @return_value ), len(@return_value))	
		set @before= substring(@return_value,1,  charindex ('.', @return_value )-1)	
	end
	else
	begin
		set @before = @return_value
		set @after=''
	end
	-- after every third character:
	declare @i int
	if len(@before)>3 
	begin
		set @i = 3
		while @i>1 and @i < len(@before)
		begin
			set @before = substring(@before,1,len(@before)-@i) + ',' + right(@before,@i)
			set @i = @i + 4
		end
	end
	set @return_value = @before + @after

	if @is_negative = 1
		set @return_value = '-' + @return_value

	return @return_value 
end
GO
/****** Object:  UserDefinedFunction [dbo].[LeftPad]    Script Date: 12/21/2021 12:12:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LeftPad](
	@stringToPad VARCHAR(8000),
	@finalLength INT,
	@paddingChar CHAR(1)
) 
RETURNS VARCHAR(8000)
AS
BEGIN    
	DECLARE @answer VARCHAR(8000)
	DECLARE @strLength INT
	DECLARE @charsToAdd INT
	
	SELECT @strLength = LEN(@stringToPad)
	SELECT @charsToAdd =  @finalLength - @strLength

	IF @charsToAdd<0 
		SELECT @answer = @stringToPad
	ELSE
		SELECT @answer = REPLICATE (@paddingChar, @charsToAdd) + @stringToPad

	RETURN @answer
END
GO
/****** Object:  UserDefinedFunction [dbo].[UkDate]    Script Date: 12/21/2021 12:12:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[UkDate](
	@DateToFormat AS DATETIME		-- the date to format
)
RETURNS varchar(10)

AS

BEGIN

	DECLARE @DayNo smallint
	DECLARE @MonthNo smallint
	DECLARE @YearNo smallint
	
	SELECT @DayNo = day(@DateToFormat)
	SELECT @MonthNo = month(@DateToFormat)
	SELECT @YearNo = year(@DateToFormat)

	RETURN 
		dbo.LeftPad(@DayNo,2,'0') + '-' +
		dbo.LeftPad(@MonthNo,2,'0') + '-' +
		CAST(@YearNo AS char(4))
END
GO
/****** Object:  Table [dbo].[tblFilm]    Script Date: 12/21/2021 12:12:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblFilm](
	[FilmID] [int] IDENTITY(1,1) NOT NULL,
	[FilmName] [nvarchar](255) NULL,
	[FilmReleaseDate] [varchar](100) NULL,
	[FilmDirectorID] [int] NULL,
	[FilmCountryID] [int] NULL,
	[FilmStudioID] [int] NULL,
	[FilmSynopsis] [nvarchar](max) NULL,
	[FilmImage] [varchar](500) NULL,
	[FilmRating] [varchar](20) NULL,
 CONSTRAINT [PK_tblFilm] PRIMARY KEY CLUSTERED 
(
	[FilmID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwFilmSimple]    Script Date: 12/21/2021 12:12:10 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwFilmSimple]
AS
SELECT     FilmID, FilmName, FilmBoxOfficeDollars
FROM         dbo.tblFilm
WHERE     (FilmBoxOfficeDollars = NULL)
GO
/****** Object:  Table [dbo].[tblCountry]    Script Date: 12/21/2021 12:12:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCountry](
	[CountryID] [int] NOT NULL,
	[CountryName] [nvarchar](255) NULL,
 CONSTRAINT [PK_tblCountry] PRIMARY KEY CLUSTERED 
(
	[CountryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblStudio]    Script Date: 12/21/2021 12:12:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblStudio](
	[StudioID] [int] NOT NULL,
	[StudioName] [nvarchar](255) NULL,
 CONSTRAINT [PK_tblStudio] PRIMARY KEY CLUSTERED 
(
	[StudioID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblDirector]    Script Date: 12/21/2021 12:12:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblDirector](
	[DirectorID] [int] IDENTITY(1,1) NOT NULL,
	[DirectorName] [nvarchar](255) NULL,
	[DirectorDOB] [varchar](200) NULL,
	[DirectorGender] [nvarchar](255) NULL,
	[DirectorImage] [varchar](500) NULL,
 CONSTRAINT [PK_tblDirector] PRIMARY KEY CLUSTERED 
(
	[DirectorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwFilms]    Script Date: 12/21/2021 12:12:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwFilms]
AS
SELECT     dbo.tblFilm.FilmName, dbo.tblDirector.DirectorName, dbo.tblCountry.CountryName, dbo.tblLanguage.Language, dbo.tblCertificate.Certificate, 
                      dbo.tblStudio.StudioName
FROM         dbo.tblCertificate INNER JOIN
                      dbo.tblFilm ON dbo.tblCertificate.CertificateID = dbo.tblFilm.FilmCertificateID INNER JOIN
                      dbo.tblCountry ON dbo.tblFilm.FilmCountryID = dbo.tblCountry.CountryID INNER JOIN
                      dbo.tblDirector ON dbo.tblFilm.FilmDirectorID = dbo.tblDirector.DirectorID INNER JOIN
                      dbo.tblLanguage ON dbo.tblFilm.FilmLanguageID = dbo.tblLanguage.LanguageID INNER JOIN
                      dbo.tblStudio ON dbo.tblFilm.FilmStudioID = dbo.tblStudio.StudioID
GO
/****** Object:  View [dbo].[vwFilmDetails]    Script Date: 12/21/2021 12:12:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwFilmDetails]
AS
SELECT     Certificate
FROM         dbo.tblCertificate
GO
/****** Object:  Table [dbo].[tblActor]    Script Date: 12/21/2021 12:12:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblActor](
	[ActorID] [int] IDENTITY(1,1) NOT NULL,
	[ActorName] [nvarchar](255) NULL,
	[ActorDOB] [varchar](200) NULL,
	[ActorGender] [nvarchar](255) NULL,
	[ActorImage] [varchar](500) NULL,
 CONSTRAINT [PK_tblActor] PRIMARY KEY CLUSTERED 
(
	[ActorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblCast]    Script Date: 12/21/2021 12:12:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCast](
	[CastID] [int] NOT NULL,
	[CastFilmID] [int] NULL,
	[CastActorID] [int] NULL,
	[CastCharacterName] [nvarchar](255) NULL,
 CONSTRAINT [PK_tblCast] PRIMARY KEY CLUSTERED 
(
	[CastID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblGenre]    Script Date: 12/21/2021 12:12:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblGenre](
	[GenreId] [bigint] NOT NULL,
	[GenreName] [varchar](50) NULL,
 CONSTRAINT [PK_tblGenre] PRIMARY KEY CLUSTERED 
(
	[GenreId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[tblActor] ON 

INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (1, N'Tom Cruise', N'1962', N'Male', N'https://i0.wp.com/hipertextual.com/wp-content/uploads/2020/05/hipertextual-elon-musk-tom-cruise-y-nasa-podrian-hacer-primer-filme-historia-grabado-espacio-2020828141.jpg?fit=1200%2C675&ssl=1')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (2, N'Sam Neill', N'1947', N'Male', N'https://imagenes.elpais.com/resizer/an0R6h6tdW7goWFfZaBzrAJt1S8=/1960x0/cloudfront-eu-central-1.images.arcpublishing.com/prisa/XHPCEO5DCLB7AEBXZFMNMZTXQY.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (3, N'Laura Dern', N'1967', N'Female', N'https://phantom-telva.unidadeditorial.es/279a9f712e1d3ed911c056845e47c478/crop/0x88/999x639/resize/828/f/jpg/assets/multimedia/imagenes/2020/02/10/15813644765930.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (4, N'Jeff Goldblum', N'1952', N'Male', N'https://www.cinemascomics.com/wp-content/uploads/2020/04/Jeff-Goldblum-rupauls-drag-race.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (5, N'Richard Attenborough', N'1923', N'Male', N'https://cdn.hobbyconsolas.com/sites/navi.axelspringer.es/public/styles/480/public/media/image/2014/08/373992-fallece-actor-director-richard-attenborough-90-anos.jpg?itok=vorIWxI7')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (6, N'Samuel L. Jackson', N'1948', N'Male', N'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/samuel-l-jackson-fotogramas-1608576340.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (7, N'Tobey Maguire', N'1975', N'Male', N'https://cloudfront-eu-central-1.images.arcpublishing.com/diarioas/35HZBDA54VONZCA3ZMBOLKONIE.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (8, N'Willem Dafoe', N'1955', N'Male', N'https://depor.com/resizer/j35z-7-VftQMB93mJ7eQsjiQDwU=/580x330/smart/filters:format(jpeg):quality(75)/cloudfront-us-east-1.images.arcpublishing.com/elcomercio/XPCW65RH6BE57G6KJHLAJS5CWI.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (9, N'Kirsten Dunst', N'1982', N'Female', N'https://media.revistavanityfair.es/photos/60e82d57ec46354bf4481187/master/w_1600%2Cc_limit/179414.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (10, N'Naomi Watts', N'1968', N'Female', N'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/gettyimages-1126949526.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (11, N'Jack Black', N'1969', N'Male', N'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/jack-black-arrives-at-the-art-of-elysiums-13th-annual-news-photo-1612949849.?crop=1.00xw:0.843xh;0,0.0236xh&resize=640:*')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (12, N'Adrien Brody', N'1973', N'Male', N'https://fotografias.antena3.com/clipping/cmsimages02/2021/10/28/A54F56FB-CB6C-4AD1-B423-474112D9C677/98.jpg?crop=1024,576,x0,y0&width=1900&height=1069&optimize=high&format=webply')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (13, N'Andy Serkis', N'1964', N'Male', N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_a353kaTKanT3dfCvubz60JPrML6PFGNXrOPzI-J-BKGy6PvdUgYCTJnl_PHeOx8N_6A&usqp=CAU')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (14, N'Brandon Routh', N'1979', N'Male', N'https://1.bp.blogspot.com/-KcXDKxMzAx4/X6QiUIRx1XI/AAAAAAAAFnc/_LguRXoBqOM9qhw9HwU2QKBu7pEhvJJWgCLcBGAsYHQ/s2000/a35-1-e1583617906786.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (15, N'Kate Bosworth', N'1983', N'Female', N'https://s.yimg.com/ny/api/res/1.2/QWgJxl.A98Aq35pgJUnzKg--/YXBwaWQ9aGlnaGxhbmRlcjt3PTcwNTtoPTkyMg--/https://s.yimg.com/uu/api/res/1.2/z.ui6jLria6LsCZU_eYWgQ--~B/aD01OTQ7dz00NTQ7YXBwaWQ9eXRhY2h5b24-/http://41.media.tumblr.com/c8c201da42905101f516e02f6a6b9a11/tumblr_inline_o0rm5eB5nR1ttcv7a_540.png')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (16, N'Kevin Spacey', N'1959', N'Male', N'https://www.latercera.com/resizer/zmOuAAULx4rlsr-itFIn2tJRBrU=/900x600/smart/cloudfront-us-east-1.images.arcpublishing.com/copesa/BAPO4O6RJNHH7HKQ2UCSZZ44NA.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (17, N'Leonardo DiCaprio', N'1974', N'Male', N'https://static2.abc.es/media/summum/2021/09/15/1_leonardo_dicaprio_diamantes-kOgF--1200x630@abc.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (18, N'Kate Winslet', N'1975', N'Female', N'https://e00-elmundo.uecdn.es/assets/multimedia/imagenes/2021/07/30/16276615277173.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (19, N'Billy Zane', N'1966', N'Male', N'https://www.bolsamania.com/cine/wp-content/uploads/2018/12/13-25-600x337.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (20, N'Bill Paxton', N'1955', N'Male', N'https://media.revistavanityfair.es/photos/60e8593eec46354bf4482f10/master/pass/20833.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (21, N'Steve Carell', N'1962', N'Male', N'https://i2.wp.com/www.dailycal.org/assets/uploads/2019/03/letter_universal-pictures_courtesy-copy-900x580.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (22, N'Morgan Freeman', N'1937', N'Male', N'https://estaticos-cdn.elperiodico.com/clip/f1cd681a-261b-4af2-81f5-7855d5033e4b_alta-libre-aspect-ratio_default_0.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (23, N'Kevin Costner', N'1955', N'Male', N'http://www.alucine.es/wp-content/uploads/2015/08/67.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (24, N'Dennis Hopper', N'1936', N'Male', N'https://imagenes.20minutos.es/files/image_656_370/uploads/imagenes/2009/10/30/1016024a.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (25, N'Ben Affleck', N'1972', N'Male', N'https://phantom-marca.unidadeditorial.es/58173c6acb6f51353d437b3ea1eccbf7/resize/1320/f/jpg/assets/multimedia/imagenes/2021/05/04/16201551523286.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (26, N'Josh Hartnett', N'1978', N'Male', N'https://estaticos.marie-claire.es/media/cache/1140x_thumb/uploads/images/article/5ed0eb715bafe8e2869425d3/josh-3.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (27, N'Kate Beckinsale', N'1973', N'Female', N'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/kate-beckinsale-attends-the-2020-vanity-fair-oscar-party-news-photo-1601716023.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (28, N'Cuba Gooding Jr.', N'1968', N'Male', N'https://album.mediaset.es/eimg/10000/2021/07/30/clipping_6HtQ45_2517.jpg?w=1200')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (29, N'Jon Voight', N'1938', N'Male', N'https://e00-elmundo.uecdn.es/assets/multimedia/imagenes/2014/08/02/14069989493590.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (30, N'Alec Baldwin', N'1958', N'Male', N'https://cloudfront-us-east-1.images.arcpublishing.com/copesa/WMCRS22JNO4E6FNC5TFHSAO7HM.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (31, N'Tom Sizemore', N'1961', N'Male', N'https://lavisionweb.com/wp-content/uploads/2020/01/gettyimages-463339763-h_2016.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (32, N'Dan Aykroyd', N'1952', N'Male', N'https://www.bolsamania.com/cine/wp-content/uploads/2017/08/48-600x450.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (33, N'Shia LaBeouf', N'1986', N'Male', N'https://imagenes.elpais.com/resizer/AREr2jQw5fVDgVm22vixFnZFQuU=/980x735/cloudfront-eu-central-1.images.arcpublishing.com/prisa/VT7CUGZ46NAR5EQVDYRILP3T74')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (34, N'John Turturro', N'1957', N'Male', N'https://www.biografias.gratis/wp-content/uploads/John_Turturro_1.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (35, N'Peter Cullen', N'1941', N'Male', N'https://media.gettyimages.com/photos/voice-actor-peter-cullen-attends-the-43rd-annual-daytime-creative-picture-id526212816?s=612x612')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (36, N'Hugo Weaving', N'1960', N'Male', N'https://cinematicos.net/wp-content/uploads/l-intro-1638989622.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (37, N'Megan Fox', N'1986', N'Female', N'https://static1.abc.es/media/gente/2021/07/23/megan-kMbH--620x349@abc.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (38, N'Daniel Radcliffe', N'1989', N'Male', N'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/daniel-radcliffe-serie-television-harry-potter-1629472359.jpg?crop=0.997xw:0.455xh;0.00340xw,0.116xh&resize=640:*')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (39, N'Ralph Fiennes', N'1962', N'Male', N'https://www.ecestaticos.com/imagestatic/clipping/af0/ed2/af0ed26da6e0814bb018b34344e680cc/ralph-fiennes-de-su-pasion-por-lord-voldemort-a-sus-polemicas-sentimentales.jpg?mtime=1636036398')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (40, N'Brendan Gleeson', N'1955', N'Male', N'https://media.gettyimages.com/photos/actor-brendan-gleeson-on-stage-at-a-fyc-screening-of-mr-mercedes-at-picture-id946764284?s=612x612')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (41, N'Gary Oldman', N'1958', N'Male', N'https://www.bolsamania.com/cine/wp-content/uploads/2017/02/11-600x375.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (42, N'Michael Gambon', N'1940', N'Male', N'https://pulpfictioncine.com/download/multimedia.normal.8733aa05b4858b72.67616d626f6e5f6e6f726d616c2e6a7067.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (43, N'Alan Rickman', N'1946', N'Male', N'https://cineuropa.org/imgCache/2015/04/10/1428655717254_0620x0435_0x1x946x664_1574317393050.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (44, N'Emma Thompson', N'1959', N'Female', N'https://www.goldenglobes.com/sites/default/files/styles/homepage_carousel/public/articles/cover_images/emma_thompson_052019.jpg?itok=FcGs9NrX')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (45, N'Helena Bonham Carter', N'1966', N'Female', N'https://smoda.elpais.com/wp-content/uploads/2018/06/GettyImages-973383984-591x447.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (46, N'Robbie Coltrane', N'1950', N'Male', N'https://img.allvipp.com/www-promipool-de/image/upload/c_fill,g_faces,w_1200,h_1200,q_auto:eco,f_jpg/Robbie_Coltrane_defiende_a_J_K_Rowling_1_200915_girsmads01')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (47, N'Emma Watson', N'1990', N'Female', N'https://static.elcorreo.com/www/multimedia/202102/25/media/cortadas/emma-watson-se-retira-deja-el-cine-k02B-U130649077462jQE-1248x770@El%20Correo.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (48, N'Rupert Grint', N'1988', N'Male', N'https://fotografias.antena3.com/clipping/cmsimages01/2020/05/08/AFAAD419-5798-463C-96A9-8815F3129032/98.jpg?crop=3756,2113,x0,y0&width=1900&height=1069&optimize=high&format=webply')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (49, N'Robin Wright Penn', N'1966', N'Female', N'https://media.gettyimages.com/photos/in-this-screengrab-robin-wright-speaks-at-the-2021-hfpa-women-picture-id1299507380?s=612x612')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (50, N'Anthony Hopkins', N'1937', N'Male', N'https://as01.epimg.net/meristation/imagenes/2021/11/09/reportajes/1636459094_302009_1636459282_noticia_normal.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (51, N'John Malkovich', N'1953', N'Male', N'https://fotografias.antena3.com/clipping/cmsimages02/2013/06/09/CEF0146F-7598-4C42-A0CD-D40923D3C8A4/98.jpg?crop=1280,720,x0,y66&width=1900&height=1069&optimize=high&format=webply')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (52, N'Ray Winstone', N'1957', N'Male', N'https://i2.wp.com/modogeeks.com/wp-content/uploads/2019/06/ray-winstone.jpg?fit=615%2C409&ssl=1')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (53, N'Angelina Jolie', N'1975', N'Female', N'https://phantom-telva.unidadeditorial.es/f4e132c78e27a37f1797f7ded6702ba0/crop/43x0/1862x1025/resize/828/f/jpg/assets/multimedia/imagenes/2021/12/19/16398684417522.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (54, N'John Goodman', N'1952', N'Male', N'https://img.huffingtonpost.com/asset/61b22926210000edd370124e.jpg?cache=EpziXz5tSm&ops=crop_0_60_2553_2229,scalefit_630_noupscale')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (55, N'Jerry Seinfeld', N'1954', N'Male', N'https://media.ambito.com/adjuntos/239/imagenes/038/152/0038152191.jpg?0000-00-00-00-00-00')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (56, N'Renee Zellweger', N'1969', N'Female', N'https://www.hola.com/imagenes/actualidad/20210625192109/renee-zellweger-novio-ant-anstead/0-968-748/renee-zellweger-cordon-t.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (57, N'Matthew Broderick', N'1962', N'Male', N'https://seriesonday.com/wp-content/uploads/2018/10/Matthew-Broderick-en-The-Conners-Better-Things-y-una-nueva-serie-de-Netflix_series_on_day-752x440.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (58, N'Chris Rock', N'1965', N'Male', N'https://i0.wp.com/www.actuall.com/wp-content/uploads/2017/06/El-actor-Chris-Rock-La-Republica.jpg?fit=949%2C534&ssl=1')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (59, N'Ray Liotta', N'1954', N'Male', N'http://www.diariodevenusville.com/wp-content/uploads/2019/03/RAY-LIOTTA.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (60, N'Rip Torn', N'1931', N'Male', N'https://aisvip-a.akamaihd.net/masters/1214005/1920x1200/rip-torn-ein-hollywood-veteran-ist-tot.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (61, N'Johnny Depp', N'1963', N'Male', N'https://static.independent.co.uk/2020/11/03/14/newFile-2.jpg?width=982&height=726&auto=webp&quality=75')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (62, N'Geoffrey Rush', N'1951', N'Male', N'https://www.bolsamania.com/cine/wp-content/uploads/2021/04/1-5-600x338.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (63, N'Orlando Bloom', N'1977', N'Male', N'https://imagenes.elpais.com/resizer/F9n7YG_BVTe3FX1tje6BUNWScbk=/1960x0/cloudfront-eu-central-1.images.arcpublishing.com/prisa/BIFMEXCTDJC6JBX3AKGJDVW4L4.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (64, N'Keira Knightley', N'1985', N'Female', N'https://media.revistavanityfair.es/photos/60e8501064a1ecf164d075c5/master/w_1600%2Cc_limit/4348.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (65, N'Bill Nighy', N'1949', N'Male', N'https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/Bill_Nighy_2.JPG/1280px-Bill_Nighy_2.JPG')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (66, N'Jonathan Pryce', N'1947', N'Male', N'https://img.huffingtonpost.com/asset/5f1a99c4250000780fc2a443.jpeg?cache=uaqRAQB4Hc&ops=scalefit_630_noupscale')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (67, N'Stellan Skarsgard', N'1951', N'Male', N'https://www.cinemascomics.com/wp-content/uploads/2021/04/Stellan-Skarsgard-revela-por-que-se-ha-unido-a-la-serie-Cassian-Andor.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (68, N'Will Smith', N'1968', N'Male', N'https://www.hola.com/imagenes/belleza/actualidad/20210505188995/will-smith-cambio-fisico/0-948-532/will-smith-gtres2-t.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (69, N'Patton Oswalt', N'1969', N'Male', N'https://areajugones.sport.es/wp-content/uploads/2020/09/patton-oswalt-grief-holiday-loneliness-wife-death.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (70, N'Ian Holm', N'1931', N'Male', N'https://d1iibezb83drel.cloudfront.net/wp-content/uploads/2020/06/Ian-Holm.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (71, N'Brian Dennehy', N'1938', N'Male', N'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/brian-dennehy-2019-1587136259.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (72, N'Peter O''Toole', N'1932', N'Male', N'https://www.alohacriticon.com/wp-content/uploads/2013/09/peter-otoole-fotos.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (73, N'Brian Cox', N'1946', N'Male', N'https://www.quever.news/u/fotografias/m/2021/10/28/f608x342-17923_47646_9.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (75, N'Brad Pitt', N'1963', N'Male', N'https://cloudfront-us-east-1.images.arcpublishing.com/infobae/GYFD2VAG6RC6NE2YTANMF2TMHE.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (76, N'Diane Kruger', N'1976', N'Female', N'https://dam.harpersbazaar.mx/wp-content/uploads/2020/07/diane-Kruger-frases-actriz-modelo.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (77, N'Eric Bana', N'1968', N'Male', N'https://hips.hearstapps.com/es.h-cdn.co/fotoes/images/cinefilia/eric-bana-estrella-errante/14648702-2-esl-ES/Eric-Bana-estrella-errante.jpg?crop=1xw:0.670690811535882xh;center,top&resize=1200:*')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (78, N'Christian Bale', N'1974', N'Male', N'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/christian-bale-fotogramas-1611954338.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (79, N'Michael Caine', N'1933', N'Male', N'https://www.lavanguardia.com/files/og_thumbnail/files/fp/uploads/2021/10/16/616aa46534774.r_d.406-217-0.jpeg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (80, N'Liam Neeson', N'1952', N'Male', N'https://ichef.bbci.co.uk/news/640/cpsprodpb/6750/production/_105484462_gettyimages-902692114_crop.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (81, N'Katie Holmes', N'1978', N'Female', N'https://www.hola.com/imagenes/actualidad/20200908174876/kate-holmes-nuevo-romance/0-862-834/katie-holmes-getty3-t.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (82, N'Rutger Hauer', N'1944', N'Male', N'https://imagenes.elpais.com/resizer/Zk4uvk8uWr17zFv8um4csdjQfdo=/1960x1103/ep01.epimg.net/cultura/imagenes/2019/07/24/actualidad/1563988029_132240_1564045057_noticia_fotograma.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (83, N'Ken Watanabe', N'1959', N'Male', N'https://i1.wp.com/modogeeks.com/wp-content/uploads/2018/01/Ken-Watanabe.jpg?fit=1600%2C970&ssl=1')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (84, N'James Fox', N'1939', N'Male', N'https://es.web.img3.acsta.net/r_1280_720/medias/nmedia/18/92/70/57/20416394.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (85, N'Christopher Lee', N'1922', N'Male', N'https://media.vozpopuli.com/2021/02/Christopher-Lee-ataque-clones-Gtresonline_704339625_3269376_1020x574.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (86, N'Pierce Brosnan', N'1953', N'Male', N'https://i1.wp.com/modogeeks.com/wp-content/uploads/2021/03/pierce-brosnan.jpg?fit=900%2C600&ssl=1')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (87, N'Halle Berry', N'1966', N'Female', N'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/halle-berry-attends-the-2021-afi-fest-official-screening-of-news-photo-1636994299.jpg?width=640&auto=webp&optimize=medium&io=1')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (88, N'Rosamund Pike', N'1979', N'Female', N'https://resizer.glanacion.com/resizer/VAt733ao_aDfX2e_9-Exq7NPhng=/1920x0/filters:quality(80)/cloudfront-us-east-1.images.arcpublishing.com/lanacionar/DZI6WAH2UBFX7A64GWFCI67MPY.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (89, N'Judi Dench', N'1934', N'Female', N'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/gettyimages-1051766664.jpg?crop=1.00xw:0.448xh;0,0.0139xh&resize=480:*')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (90, N'John Cleese', N'1939', N'Male', N'https://media.timeout.com/images/105598480/image.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (91, N'Michael Madsen', N'1958', N'Male', N'https://s03.s3c.es/imag/_v0/770x420/9/b/f/Michael-Madsen-the-independent.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (92, N'Samantha Bond', N'1961', N'Female', N'https://static.independent.co.uk/s3fs-public/thumbnails/image/2016/04/06/17/gettyimages-185725112.jpg?width=1200')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (93, N'Mel Gibson', N'1956', N'Male', N'https://media.revistavanityfair.es/photos/60e831a2af2c957f3eff021a/16:9/w_1280,c_limit/234360.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (94, N'Danny Glover', N'1946', N'Male', N'https://cdn.hobbyconsolas.com/sites/navi.axelspringer.es/public/styles/480/public/media/image/2020/07/arma-letal-roger-murtaugh-1984149.jpg?itok=U9yA6x-w')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (95, N'Joe Pesci', N'1943', N'Male', N'https://www.premios-cine.com/oscars/2020/media/nominados/big/joe_pesci.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (96, N'Rene Russo', N'1954', N'Female', N'https://media.gettyimages.com/photos/rene-russo-arrives-at-the-los-angeles-premiere-screening-of-velvet-picture-id1125833334?s=612x612')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (97, N'Jet Li', N'1963', N'Male', N'https://arc-anglerfish-arc2-prod-copesa.s3.amazonaws.com/public/BWU6LQJVWRA5PAD3XFT3ZCVO7Y.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (98, N'Bruce Willis', N'1955', N'Male', N'https://media.gettyimages.com/photos/bruce-willis-attends-the-comedy-central-roast-of-bruce-willis-at-on-picture-id999468408?s=612x612')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (99, N'Billy Bob Thornton', N'1955', N'Male', N'https://media.gettyimages.com/photos/billy-bob-thornton-attends-goliath-during-2019-tribeca-tv-festival-at-picture-id1174568875?s=594x594')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (100, N'Liv Tyler', N'1977', N'Female', N'https://hips.hearstapps.com/es.h-cdn.co/fotoes/images/noticias-cine/liv-tyler-a-mi-edad-eres-una-ciudadana-de-segunda-en-hollywood/73758335-1-esl-ES/Liv-Tyler-a-mi-edad-eres-una-ciudadana-de-segunda-en-Hollywood.jpg?crop=1xw:0.6666666666666666xh;center,top&resize=1200:*')
GO
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (101, N'Steve Buscemi', N'1957', N'Male', N'https://img.europapress.es/fotoweb/fotonoticia_20180911122042_1200.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (102, N'Owen Wilson', N'1968', N'Male', N'https://salaguamotors.com/wp-content/uploads/2021/05/shutterstock_71835799-e1594985171464.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (103, N'Michael Clarke Duncan', N'1957', N'Male', N'https://static1.abc.es/media/201209/05/michael_clarke--644x362.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (104, N'Peter Stormare', N'1953', N'Male', N'https://lh3.googleusercontent.com/proxy/be0lmiru_EkC2WZPoDU08FcpFhnR_hM_-9Un-gtxTLN6pTko9z4V3RCLG0uKGdsDiOkfvjCqfaAUlPuWlt5vyMPoMhGw7uzrWGRuI5czpOgM_mEzRYu39lbcVm3bB0hW5a9ejN3OeIE')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (105, N'Tommy Lee Jones', N'1946', N'Male', N'https://lamagazin.com/wp-content/uploads/2020/09/image-original.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (106, N'Jamie Foxx', N'1967', N'Male', N'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/jamie-foxx-attends-american-black-film-festival-honors-news-photo-1607070648.')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (107, N'Jessica Biel', N'1982', N'Female', N'https://www.hola.com/imagenes/belleza/actualidad/20200428166803/jessica-biel-broma-look-cuarentena-perro/0-817-137/jessica-biel-getty-t.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (108, N'Ving Rhames', N'1959', N'Male', N'https://www.horoscopodehoy.com/images/famosos/ving-rhames.jpeg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (109, N'Donald Sutherland', N'1935', N'Male', N'https://static3.abc.es/media/play/2019/08/26/donald-sutherland-kP4E--620x349@abc.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (110, N'James Woods', N'1947', N'Male', N'https://www.currentschoolnews.com/wp-content/uploads/2020/03/james-woods-.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (111, N'Colin Farrell', N'1976', N'Male', N'https://espanol.news24viral.com/wp-content/uploads/2021/05/%C2%BFQue-esta-pasando-realmente-con-Colin-Farrell-y-su-hijo.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (112, N'Ciaran Hinds', N'1953', N'Male', N'http://www.diariodevenusville.com/wp-content/uploads/2017/04/CIARAN-HINDS.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (113, N'Sophie Marceau', N'1966', N'Female', N'https://theluxonomist.es/wp-content/uploads/2020/07/sophie-marceau-gtres-b.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (114, N'Robert Carlyle', N'1961', N'Male', N'https://www.nme.com/wp-content/uploads/2021/10/Robert_Carlyle_Getty.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (115, N'Denise Richards', N'1971', N'Female', N'https://arc-anglerfish-arc2-prod-infobae.s3.amazonaws.com/public/DUATCIZVTFGUXAGKFQTJR5WNFM.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (116, N'Desmond Llewelyn', N'1913', N'Male', N'https://famousinheaven.nl/wp-content/uploads/2021/03/Desmond-Llewelyn-1-1.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (117, N'Russell Crowe', N'1964', N'Male', N'https://imagenes.elpais.com/resizer/eqQEdm7RW-kpxor505WqlbkQk_k=/1960x0/cloudfront-eu-central-1.images.arcpublishing.com/prisa/KQKIVEHH65AYRDNSUATO5JPBSQ.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (118, N'Paul Bettany', N'1971', N'Male', N'https://imagenes.20minutos.es/files/article_amp/uploads/imagenes/2014/02/07/3af423f_Transcendence_Paul_Bettany.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (119, N'Dakota Fanning', N'1994', N'Female', N'https://estaticos-cdn.elperiodico.com/clip/70dd7358-f5e1-4ef4-a0e5-e44dbb7dc970_alta-libre-aspect-ratio_default_0.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (120, N'Tim Robbins', N'1958', N'Male', N'https://www.biografiasyvidas.com/biografia/r/fotos/robbins_tim.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (121, N'Matt Damon', N'1970', N'Male', N'https://img.ecartelera.com/noticias/fotos/65800/65802/1.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (122, N'Julia Stiles', N'1981', N'Female', N'https://celebrity.land/wp-content/uploads/2021/05/%C2%BFQue-paso-con-Julia-Stiles-Esto-es-lo-que-esta.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (123, N'David Strathairn', N'1949', N'Male', N'https://elintranews.com/wp-content/uploads/2019/09/david-strathairn-1024x576.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (124, N'Paddy Considine', N'1974', N'Male', N'https://imagenes.heraldo.es/files/og_thumbnail/uploads/imagenes/2020/10/06/paddy-considine.jpeg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (125, N'Albert Finney', N'1936', N'Male', N'https://cnnespanol.cnn.com/wp-content/uploads/2019/02/190208094109-01-albert-finney-exlarge-169.jpg?quality=100&strip=info&w=460&h=260&crop=1')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (126, N'Monica Bellucci', N'1964', N'Female', N'https://imagenes.elpais.com/resizer/1uZqFQ8K4J_XqwAcsGi7P9DLtFI=/980x735/arc-anglerfish-eu-central-1-prod-prisa.s3.amazonaws.com/public/F4HBKV4ZLPCN4SZ3DP7XUGIDRM.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (127, N'Laurence Fishburne', N'1961', N'Male', N'https://forucinema.com/wp-content/uploads/2021/07/Laurence-Fishburne.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (128, N'Carrie-Anne Moss', N'1967', N'Female', N'https://imagenes.20minutos.es/files/article_amp/uploads/imagenes/2021/04/12/la-actriz-carrie-anne-moss.jpeg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (129, N'Keanu Reeves', N'1964', N'Male', N'https://imagenes.20minutos.es/files/article_amp/uploads/imagenes/2021/06/10/keanu-reeves.jpeg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (130, N'Tom Hanks', N'1956', N'Male', N'https://static.independent.co.uk/s3fs-public/thumbnails/image/2018/01/10/12/tom-hanks.jpg?width=1200&auto=webp&quality=75')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (131, N'Audrey Tautou', N'1976', N'Female', N'https://cl.buscafs.com/www.tomatazos.com/public/uploads/images/113976/113976.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (132, N'Ian McKellen', N'1939', N'Male', N'https://www.diariodesevilla.es/2018/07/09/ocio/Ian-McKellen-escena-documental_1261984156_86872476_667x375.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (133, N'Jean Reno', N'1948', N'Male', N'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/jean-reno-fotogramas-1623948977.jpg?crop=1.00xw:0.751xh;0,0.0839xh&resize=1200:*')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (134, N'Jurgen Prochnow', N'1941', N'Male', N'https://static.dw.com/image/19305907_401.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (135, N'Richard Harris', N'1930', N'Male', N'https://www.dcine.org/sites/default/files/styles/personas/public/personas/Richard%20Harris.jpg?itok=_hOMu6jh')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (136, N'John Hurt', N'1940', N'Male', N'https://i0.wp.com/www.vinilonegro.com/wp-content/uploads/2017/01/John-Hurt-e1485599966202.jpg?resize=599%2C381&ssl=1')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (137, N'Dennis Quaid', N'1954', N'Male', N'https://cloudfront-eu-central-1.images.arcpublishing.com/diarioas/RALRUIA6ORLA7LZRZDZP7HPSVA.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (138, N'Jake Gyllenhaal', N'1980', N'Male', N'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/jake-gyllenhaal-attends-the-2021-lacma-art-film-gala-on-news-photo-1636365212.jpg?crop=1.00xw:1.00xh;0,0&resize=640:*')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (139, N'Billy Connolly', N'1942', N'Male', N'https://hubimages.itv.com/episode/10_0577_0001?w=1366&h=769&q=80&blur=0&bg=false&image_format=jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (140, N'Hiroyuki Sanada', N'1960', N'Male', N'https://i.kinja-img.com/gawker-media/image/upload/c_fill,f_auto,fl_progressive,g_center,h_675,pg_1,q_80,w_1200/0dbf54aeef07cc5677c6abb3374894f5.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (141, N'Cillian Murphy', N'1976', N'Male', N'https://sm.ign.com/ign_es/screenshot/default/cillian-murphy-oppenheimer-nolan_ffsx.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (142, N'Michelle Yeoh', N'1962', N'Female', N'https://cdn.hobbyconsolas.com/sites/navi.axelspringer.es/public/styles/hc_480x270/public/media/image/2021/07/michelle-yeoh-2397687.jpg?itok=6D6_WgvN')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (143, N'George Clooney', N'1961', N'Male', N'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/elle-george-clooney-1591169036.jpg?crop=1.00xw:1.00xh;0,0&resize=640:*')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (144, N'Mark Wahlberg', N'1971', N'Male', N'https://assets.entrepreneur.com/content/3x2/2000/20200206202747-mark-walberg.jpeg?crop=1:1')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (145, N'John C. Reilly', N'1965', N'Male', N'https://img.vixdata.io/pd/jpg-large/es/sites/default/files/btg/cine.batanga.com/files/John-C-Reilly-se-acerca-a-Los-Guardianes-de-la-Galaxia-4.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (146, N'Mary Elizabeth Mastrantonio', N'1958', N'Female', N'https://elfinalde.s3-accelerate.amazonaws.com/2016/05/jNIGODCEy216bbPnj28ky5E4L3Q.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (147, N'Michael Ironside', N'1950', N'Male', N'https://i2.wp.com/www.hugozapata.com.ar/wp-content/uploads/2019/02/michael-ironside.jpg?resize=678%2C380')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (148, N'Philip Seymour Hoffman', N'1967', N'Male', N'https://espanol.news24viral.com/wp-content/uploads/2020/02/Philip-Seymour-Hoffman-%C2%BFQue-ha-salido-de-el-desde-que.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (149, N'Michelle Monaghan', N'1976', N'Female', N'https://seriesonday.com/wp-content/uploads/2021/07/michelle-monaghan-protagonizara-la-serie-echoes-para-netflix-seriesonday.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (150, N'Simon Pegg', N'1970', N'Male', N'https://media.gettyimages.com/photos/actor-simon-pegg-attends-the-paramount-pictures-celebration-of-the-picture-id180283605?s=612x612')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (151, N'Nicolas Cage', N'1964', N'Male', N'https://imagenes.elpais.com/resizer/AUS2w-6NBbOz1-YZH0Fd1uHM94c=/1960x0/cloudfront-eu-central-1.images.arcpublishing.com/prisa/LL3KKOVYQN5NFSMWTE4J3MD6ME.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (152, N'Christian Slater', N'1969', N'Male', N'https://espanol.news24viral.com/wp-content/uploads/2021/03/l-intro-1614795000.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (153, N'Ewan McGregor', N'1971', N'Male', N'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/ewan-mcgregor-obi-wan-kenobi-1572271864.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (154, N'Natalie Portman', N'1981', N'Female', N'https://img2.rtve.es/i/?w=1600&i=1623238663304.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (155, N'Hayden Christensen', N'1981', N'Male', N'https://phantom-marca.unidadeditorial.es/061eaf243be79cce3078cefbac16d8e6/resize/1320/f/jpg/assets/multimedia/imagenes/2020/12/11/16076579948679.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (156, N'Frank Oz', N'1944', N'Male', N'https://as01.epimg.net/meristation/imagenes/2021/08/31/noticias/1630409487_516005_1630409646_sumario_normal.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (157, N'Ian McDiarmid', N'1944', N'Male', N'https://i.guim.co.uk/img/media/ddaf393fb3194b1849ef6b2f87b9c712f1828c72/0_448_6720_4032/master/6720.jpg?width=465&quality=45&auto=format&fit=max&dpr=2&s=f28bc401bb26cf9a4bffdfb2e053cca3')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (158, N'Temuera Morrison', N'1960', N'Male', N'https://espanol.news24viral.com/wp-content/uploads/2021/02/Cuan-rica-es-Temuera-Morrison-en-la-vida-real.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (159, N'Rena Owen', N'1962', N'Female', N'https://es.web.img3.acsta.net/r_1280_720/pictures/19/09/19/10/57/4623004.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (160, N'Billy Crystal', N'1948', N'Male', N'https://celebrity.land/wp-content/uploads/2021/06/Billy-Crystal-Skewers-Ceremonia-de-los-Oscar-2021-The.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (161, N'James Coburn', N'1928', N'Male', N'https://es.web.img3.acsta.net/r_1280_720/medias/nmedia/18/36/22/50/18844014.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (162, N'Ray Park', N'1974', N'Male', N'https://www.cinepremiere.com.mx/wp-content/uploads/2020/07/ray_park-900x506.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (163, N'Anthony Daniels', N'1946', N'Male', N'https://i1.wp.com/www.lafosadelrancor.com/wp-content/uploads/2020/04/Anthony-Daniels.jpg?fit=677%2C380&ssl=1')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (164, N'Kenny Baker', N'1934', N'Male', N'https://www.prensalibre.com/wp-content/uploads/2018/12/f78cd3a2-43d1-406a-9f2c-cc11615b40c1.jpg?quality=52&w=520&h=500&crop=1')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (165, N'Peter Mayhew', N'1944', N'Male', N'https://es.web.img3.acsta.net/r_654_368/newsv7/19/05/03/09/52/2650670.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (166, N'Joe Don Baker', N'1936', N'Male', N'https://offradranch.com/images/actors/who-is-joe-don-baker-is-he-still-alive-his-wife-family-and-net-worth_2.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (167, N'Elliott Gould', N'1938', N'Male', N'https://i.guim.co.uk/img/media/d13743e4a213d09ab54992f5cdc92267dd1ad97d/7_229_2901_1741/master/2901.jpg?width=1200&height=900&quality=85&auto=format&fit=crop&s=347fe96953fe24714665204c1a37a19e')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (168, N'Andy Garcia', N'1956', N'Male', N'https://phantom-elmundo.unidadeditorial.es/4f5c2b9bdede7e6655415b3941f3e87f/resize/414/f/jpg/assets/multimedia/imagenes/2019/03/26/15536046534390.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (169, N'Julia Roberts', N'1967', N'Female', N'https://i0.wp.com/hipertextual.com/wp-content/uploads/2020/12/julia-roberts.jpg?fit=2165%2C1443&ssl=1')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (170, N'Don Cheadle', N'1964', N'Male', N'https://i1.wp.com/modogeeks.com/wp-content/uploads/2019/07/don-cheadle.jpg?fit=800%2C450&ssl=1')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (171, N'Timothy Olyphant', N'1968', N'Male', N'https://i2.wp.com/modogeeks.com/wp-content/uploads/2020/05/timothy-olyphant.jpg?resize=996%2C640&ssl=1')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (172, N'Jackie Chan', N'1954', N'Male', N'https://cdn.hobbyconsolas.com/sites/navi.axelspringer.es/public/styles/1200/public/media/image/2020/10/jackie-chan-2113345.jpg?itok=qubNafpe')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (173, N'Steve Coogan', N'1965', N'Male', N'https://variety.com/wp-content/uploads/2021/09/steve-coogan.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (174, N'Arnold Schwarzenegger', N'1947', N'Male', N'https://media.ambito.com/p/693c41c04d6ee53f83c85ae16769fb74/adjuntos/239/imagenes/038/108/0038108128/1200x900/smart/arnold-schwarzenegger.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (175, N'Maggie Q', N'1979', N'Female', N'https://super-ficcion.com/wp-content/uploads/2020/12/Maggie-Q-scaled.jpeg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (176, N'Sammo Hung', N'1952', N'Male', N'http://cdn.shopify.com/s/files/1/0646/4097/files/Sammo_Hung_2_1024x1024.jpg?v=1606478033')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (177, N'Jim Broadbent', N'1949', N'Male', N'https://variety.com/wp-content/uploads/2021/02/Jim-Broadbent.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (178, N'Luke Wilson', N'1971', N'Male', N'https://www.bolsamania.com/seriesadictos/wp-content/uploads/2019/01/luke-wilson-stargirl-450x305.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (179, N'Jeremy Irons', N'1948', N'Male', N'https://staticr1.blastingcdn.com/media/photogallery/2020/9/3/os/b_1200x630/el-actor-ingles-jeremy-irons-screendailycom_2510814.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (180, N'Edward Norton', N'1969', N'Male', N'https://vader.news/__export/1621569480309/sites/gadgets/img/2021/05/20/edward_norton_portada.jpeg_1609522738.jpeg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (181, N'Vince Vaughan', N'1970', N'Male', N'https://imagenes.elpais.com/resizer/xJgCqdsuRcAIk88jPZycqYFOPQQ=/414x0/arc-anglerfish-eu-central-1-prod-prisa.s3.amazonaws.com/public/IITUOOSEZZJSX3G6TMP2PXABEI.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (182, N'Cate Blanchett', N'1969', N'Female', N'https://e00-elmundo.uecdn.es/assets/multimedia/imagenes/2021/05/11/16207205135737.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (183, N'Jude Law', N'1972', N'Male', N'https://imagenes.elpais.com/resizer/ajkRPq8r1Tjoa6QGqy-RpQT7e_E=/1960x0/cloudfront-eu-central-1.images.arcpublishing.com/prisa/4K2NJ3P6TJENHMVO2ONWXLBBTQ.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (184, N'Brent Spiner', N'1949', N'Male', N'https://areajugones.sport.es/wp-content/uploads/2015/04/brentspiner.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (185, N'Viggo Mortensen', N'1958', N'Male', N'https://smoda.elpais.com/wp-content/uploads/2020/06/viggo4-591x447.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (186, N'Elijah Wood', N'1981', N'Male', N'https://e00-elmundo.uecdn.es/assets/multimedia/imagenes/2021/01/27/16117699396075.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (187, N'James Cromwell', N'1940', N'Male', N'https://www.latercera.com/resizer/UivGcbOEy7kgtL5F4CJslKHTWno=/900x600/smart/arc-anglerfish-arc2-prod-copesa.s3.amazonaws.com/public/INJ667YMUFF6PANIVBYY3E2RQY.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (188, N'Bridget Moynahan', N'1971', N'Female', N'https://phantom-marca.unidadeditorial.es/a183edbc4812deb682aa75eedf126bce/resize/414/f/jpg/assets/multimedia/imagenes/2020/03/27/15853088868381.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (189, N'Daniel Craig', N'1968', N'Male', N'https://media.revistagq.com/photos/615988f78af707562878054c/16:9/w_2560%2Cc_limit/GettyImages-1343682803.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (190, N'Max von Sydow', N'1929', N'Male', N'https://cdn.elnacional.com/wp-content/uploads/2020/03/gettyimages-77820605.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (191, N'Linda Hamilton', N'1956', N'Female', N'https://static1.abc.es/media/estilo/2019/09/04/linda-kQkF--620x349@abc.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (192, N'Edward Furlong', N'1977', N'Male', N'https://img.ecartelera.com/noticias/fotos/55300/55380/1.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (193, N'Robert Patrick', N'1958', N'Male', N'https://www.cine.com/media/noticias/2021/11/202111053701321.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (194, N'Kenneth Branagh', N'1960', N'Male', N'https://cineuropa.org/imgCache/2021/07/27/1627378241046_0620x0435_0x24x1000x702_1627378285310.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (195, N'Denzel Washington', N'1954', N'Male', N'https://media.revistavanityfair.es/photos/60e849b106a9cde9aea6c430/master/w_1600%2Cc_limit/47849.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (196, N'Djimon Hounsou', N'1964', N'Male', N'https://i1.wp.com/modogeeks.com/wp-content/uploads/2018/07/djimon-hounsou.jpg?fit=1000%2C563&ssl=1')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (197, N'Jennifer Connelly', N'1970', N'Female', N'https://phantom-telva.unidadeditorial.es/c146ebd573e8ae3363f0493d283b8d44/crop/0x4/2046x1234/resize/828/f/jpg/assets/multimedia/imagenes/2020/05/12/15892661257746.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (198, N'Arnold Vosloo', N'1962', N'Male', N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTuKUKgDKi5o6y7yudixaYahzovFHkf-aM68A&usqp=CAU')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (199, N'Joaquin Phoenix', N'1974', N'Male', N'https://media.revistagq.com/photos/5e410c5051036000083a6075/16:9/w_2560%2Cc_limit/curiosidades-joaquin-phoenix-oscar.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (200, N'Connie Nielsen', N'1965', N'Female', N'https://www.lacasadeel.net/wp-content/uploads/2016/01/connie-nielsen.jpg')
GO
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (201, N'Oliver Reed', N'1937', N'Male', N'https://hips.hearstapps.com/es.h-cdn.co/fotoes/images/cinefilia/paul-walker-y-otros-9-actores-que-acabaron-sus-peliculas-despues-de-morir/oliver-reed-en-gladiator-2000/66233464-1-esl-ES/Oliver-Reed-en-Gladiator-2000.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (202, N'Jamie Lee Curtis', N'1958', N'Female', N'https://cnnespanol.cnn.com/wp-content/uploads/2021/10/2F210730042027-jamie-lee-curtis-2020-file-super-tease.jpg?quality=100&strip=info')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (203, N'Tom Arnold', N'1959', N'Male', N'https://media.gettyimages.com/photos/actor-tom-arnold-attends-safe-kids-day-2017-at-smashbox-studios-on-picture-id672010314?s=594x594')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (204, N'Charlton Heston', N'1924', N'Male', N'https://www.exordio.com/blog/wp-content/uploads/2017/03/charlton-heston.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (205, N'Tia Carrere', N'1967', N'Female', N'https://images.squarespace-cdn.com/content/v1/587bab73579fb30248953af4/1487312083797-QDHS8R9YDZV34Z0IF24L/red+strapless2.jpg?format=2500w')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (206, N'Art Malik', N'1952', N'Male', N'https://www.heraldscotland.com/resources/images/4810496.jpg?display=1&htype=0&type=responsive-gallery')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (207, N'Eliza Dushku', N'1980', N'Female', N'https://www.lavanguardia.com/files/og_thumbnail/uploads/2018/01/15/5fa434b73fe51.jpeg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (208, N'Daniel Day-Lewis', N'1957', N'Male', N'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/daniel-day-lewis-fotogramas-1619707012.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (209, N'Cameron Diaz', N'1972', N'Female', N'https://media.revistagq.com/photos/5ca5f469d71dd925d8957a38/master/pass/cameron_diaz_2618.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (210, N'Milla Jovovich', N'1975', N'Female', N'https://s03.s3c.es/imag/_v0/770x420/a/a/a/700x420_milla-jovovich-embarazada-770.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (211, N'Chris Tucker', N'1972', N'Male', N'https://espanol.news24viral.com/wp-content/uploads/2021/02/Por-que-ya-no-tienes-noticias-de-Chris-Tucker.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (212, N'Sean Bean', N'1959', N'Male', N'https://mma.prnewswire.com/media/830184/Sean_Bean.jpg?w=500')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (213, N'Karl Urban', N'1972', N'Male', N'https://as01.epimg.net/deporteyvida/imagenes/2020/10/17/portada/1602916076_189329_1602916256_noticia_normal_recorte1.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (214, N'Linda Fiorentino', N'1958', N'Female', N'https://s.yimg.com/ny/api/res/1.2/GX6zxuOEjOO2PJ6rS18jPA--/YXBwaWQ9aGlnaGxhbmRlcjt3PTY0MDtoPTUwMQ--/https://media-mbst-pub-ue1.s3.amazonaws.com/creatr-uploaded-images/2020-09/d7138660-f36c-11ea-bfbd-0024d4d87b27')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (215, N'Jack Nicholson', N'1937', N'Male', N'https://fotografias.antena3.com/clipping/cmsimages01/2021/06/02/640AE4C5-A170-457B-802D-19EDE5D227CF/98.jpg?crop=1200,675,x0,y1&width=1900&height=1069&optimize=high&format=webply')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (216, N'Martin Sheen', N'1940', N'Male', N'https://www.lavanguardia.com/files/image_948_465/uploads/2020/07/31/5faa5baf2b4a4.jpeg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (217, N'Paul Giamatti', N'1967', N'Male', N'https://cm-ob.pt/img/news/92/has-paul-giamatti-lost-weight-billions-season-5.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (218, N'F. Murray Abraham', N'1939', N'Male', N'https://filasiete.com/wp-content/uploads/2021/11/fmurrayabraham.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (219, N'Charles Dance', N'1946', N'Male', N'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/game-thrones-charles-dance-tywin-1558698033.jpg?crop=1.00xw:0.333xh;0,0.0999xh&resize=640:*')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (221, N'Catherine Zeta-Jones', N'1969', N'Female', N'https://www.ecestaticos.com/imagestatic/clipping/c15/5e6/c155e65c1fd0711bd21f71ccfb0264a7/catherine-zeta-jones-revela-lo-que-no-come-para-mantenerse-tan-en-forma-a-los-51.jpg?mtime=1617952396')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (222, N'Adam Sandler', N'1966', N'Male', N'https://www.cinemascomics.com/wp-content/uploads/2021/01/adam-sandler-netflix.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (223, N'Christopher Walken', N'1943', N'Male', N'https://www.lavanguardia.com/files/image_449_220/uploads/2016/10/13/5fa2fe105632d.jpeg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (224, N'David Hasselhoff', N'1952', N'Male', N'https://media.gettyimages.com/photos/season-3-pictured-david-hasselhoff-as-michael-knight-photo-by-gary-picture-id141271020?s=612x612')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (225, N'Henry Winkler', N'1945', N'Male', N'https://media.npr.org/assets/img/2019/01/27/gettyimages-1078332640_custom-8603fbaf80a936876a9e578d2ec61a4ecfe4da9f.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (226, N'Jim Carrey', N'1962', N'Male', N'https://fotografias.antena3.com/clipping/cmsimages01/2016/09/23/B143CC86-AB12-4645-814D-2409F471BA9B/98.jpg?crop=1200,675,x0,y0&width=1900&height=1069&optimize=high&format=webply')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (227, N'Jennifer Aniston', N'1969', N'Female', N'https://fotos00.noticiasdegipuzkoa.eus/mmp/2021/12/10/690x278/europapress219883510june2019uswestwoodamericanactressjenniferanistonattendsthe.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (228, N'Emmanuelle Beart', N'1963', N'Female', N'https://media.gettyimages.com/photos/actress-emmanuelle-beart-attends-the-letreinte-photocall-at-13th-picture-id1269777109?s=612x612')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (229, N'Robert Duvall', N'1931', N'Male', N'https://phantom-elmundo.unidadeditorial.es/602425bcbb835d09acd250f77f83dc61/resize/1200/f/jpg/assets/multimedia/imagenes/2021/01/04/16097912439119.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (230, N'Tea Leoni', N'1966', N'Female', N'https://br.web.img2.acsta.net/medias/nmedia/18/91/49/81/20148628.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (231, N'Jon Favreau', N'1966', N'Male', N'https://www.cinemascomics.com/wp-content/uploads/2021/04/Jon-Favreau-hace-historia-en-Marvel-Studios.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (232, N'Vanessa Redgrave', N'1937', N'Female', N'https://upload.wikimedia.org/wikipedia/commons/2/26/Vanessa_Redgrave_Cannes_2016.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (233, N'Paul Newman', N'1925', N'Male', N'https://www.theplace2.ru/archive/paul_newman/img/1_(2)-2.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (234, N'Stanley Tucci', N'1960', N'Male', N'https://img2.rtve.es/imagenes/stanley-tucci-relata-su-durisima-batalla-contra-cancer/1630911690406.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (235, N'Ed Harris', N'1950', N'Male', N'https://media.gettyimages.com/photos/pictured-ed-harris-on-dec-12-2019-picture-id1192750262?s=612x612')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (236, N'Christopher Plummer', N'1929', N'Male', N'https://static1.abc.es/media/play/2021/02/05/sonrisas-lagrimas-kYfD--620x349@abc.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (237, N'Clive Owen', N'1964', N'Male', N'https://cdnb.20m.es/sites/144/2020/09/clive-owen-los-angeles-620x430.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (238, N'Bill Pullman', N'1953', N'Male', N'https://es.web.img3.acsta.net/r_1280_720/pictures/20/08/26/17/31/3746868.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (239, N'Mary McDonnell', N'1952', N'Female', N'https://kmesh.io/img/biography/90/mary-mcdonnell-biography.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (240, N'Randy Quaid', N'1950', N'Male', N'https://st1.uvnimg.com/2c/62/09b965e24eefb4137e7858bcf0ec/randyquaid.PNG')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (241, N'Hugh Jackman', N'1968', N'Male', N'https://img.ecartelera.com/noticias/fotos/65500/65517/1.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (242, N'Patrick Stewart', N'1940', N'Male', N'https://i0.wp.com/hipertextual.com/wp-content/uploads/2018/08/image.jpeg?fit=1200%2C900&ssl=1')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (243, N'Famke Janssen', N'1965', N'Female', N'https://es.web.img3.acsta.net/r_1280_720/pictures/17/03/17/13/57/422254.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (244, N'Sean Connery', N'1930', N'Male', N'https://www.hola.com/imagenes/actualidad/20201031178382/sean-connery-muere/0-884-409/sean-gtres-t.jpg?filter=w600')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (245, N'Michael Biehn', N'1956', N'Male', N'https://www.bolsamania.com/seriesadictos/wp-content/uploads/2020/03/michael-biehn-the-mandalorian-1-450x319.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (246, N'Rachel Weisz', N'1971', N'Female', N'https://cineuropa.org/imgCache/2019/11/05/1572952609589_0620x0435_0x0x0x0_1573329281710.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (247, N'Will Ferrell', N'1967', N'Male', N'https://espanol.news24viral.com/wp-content/uploads/2020/10/l-intro-1602433851.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (248, N'Sacha Baron Cohen', N'1971', N'Male', N'https://e00-elmundo.uecdn.es/assets/multimedia/imagenes/2021/02/08/16127906430955.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (249, N'Dan Castellaneta', N'1957', N'Male', N'https://vz.cnwimg.com/thumb-1200x/wp-content/uploads/2009/12/dan.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (250, N'Julie Kavner', N'1950', N'Female', N'https://media.gettyimages.com/photos/julie-kavner-stars-as-brenda-morgenstern-on-rhoda-image-dated-1975-picture-id170136054?s=612x612')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (251, N'Nancy Cartwright', N'1957', N'Female', N'https://cdnph.upi.com/svc/sv/i/9171622046953/2021/1/16220474176451/Nancy-Cartwright-juggles-voices-of-Rugrats-Chuckie-Bart-Simpson.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (252, N'Yeardley Smith', N'1964', N'Female', N'https://m.media-amazon.com/images/M/MV5BYmRkNjBkOTEtMWE1MC00NGI2LWE1YmQtYzgxMGRkNGYxZWI2XkEyXkFqcGdeQXVyNDkyNjE2Nw@@._V1_.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (253, N'Patrick McGoohan', N'1928', N'Male', N'https://i.blogs.es/4ff551/mcgoohananniversary/1366_2000.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (254, N'William Hurt', N'1950', N'Male', N'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/william-hurt-1584727346.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (255, N'Sigourney Weaver', N'1949', N'Female', N'https://phantom-elmundo.unidadeditorial.es/5e4600662a345768b70abf2393bf39e8/resize/1200/f/jpg/assets/multimedia/imagenes/2021/05/29/16223023679669.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (256, N'Mike Myers', N'1963', N'Male', N'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/mike-myers-fotogramas-1621972172.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (257, N'Eddie Murphy', N'1961', N'Male', N'https://www.cinemascomics.com/wp-content/uploads/2021/07/eddie-murphy-scaled-1-e1627554989709.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (258, N'Antonio Banderas', N'1960', N'Male', N'https://imagenes.elpais.com/resizer/nGj_XkebxQ8NtT7bW3Gh8NzL6Dw=/1200x0/cloudfront-eu-central-1.images.arcpublishing.com/prisa/XSSGAROT5FCBTO26OAX3DHLF3I.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (259, N'Jonathan Frakes', N'1952', N'Male', N'https://www.bolsamania.com/seriesadictos/wp-content/uploads/2019/05/william-riker-star-trek-picard-1068x632-450x266.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (260, N'LeVar Burton', N'1957', N'Male', N'https://media.gettyimages.com/photos/levar-burton-attends-the-2020-breakthrough-prize-at-nasa-ames-center-picture-id1185337741?s=612x612')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (261, N'Michael Dorn', N'1952', N'Male', N'http://images.wikia.com/memoryalpha/en/images/6/67/Michael_Dorn.jpg?w=144')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (262, N'Gates McFadden', N'1949', N'Female', N'https://pbs.twimg.com/profile_images/1160250835747639296/Pnt7sRZM_400x400.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (263, N'Marina Sirtis', N'1955', N'Female', N'https://img.discogs.com/_leC3QkZp11QCmpmfmEiyNefsbc=/fit-in/300x300/filters:strip_icc():format(jpeg):mode_rgb():quality(40)/discogs-images/A-6068486-1556915751-6770.jpeg.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (264, N'Bob Hoskins', N'Oct 26 1942 ', N'Male', N'https://imagenes.heraldo.es/files/image_990_v1/uploads/imagenes/2014/04/30/_filephotoofbobhosk14701677_4666c7d4.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (265, N'Christopher Lloyd', N'1938', N'Male', N'https://i.ytimg.com/vi/c_qtBpIKKIo/maxresdefault.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (266, N'Kathleen Turner', N'1954', N'Female', N'https://media.revistavanityfair.es/photos/60e84aecfccef075722a3fff/master/w_1600%2Cc_limit/47829.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (267, N'Christina Ricci', N'1980', N'Female', N'https://imagenes.elpais.com/resizer/KRZKlto-SXWAt3pMRsW3MHlZFwc=/414x0/cloudfront-eu-central-1.images.arcpublishing.com/prisa/KXVW6FTXLY4R23LKDT5GQHACEU.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (268, N'Vin Diesel', N'1967', N'Male', N'https://areajugones.sport.es/wp-content/uploads/2021/06/vin-diesel-en-fast-furious-9.jpeg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (269, N'William Sadler', N'1950', N'Male', N'https://www.bolsamania.com/seriesadictos/wp-content/uploads/2016/04/timthumb.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (270, N'Bonnie Bedelia', N'1948', N'Female', N'https://www.bolsamania.com/seriesadictos/wp-content/uploads/2017/09/bonnie-bedelia.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (271, N'Geena Davis', N'1956', N'Female', N'https://cdnb.20m.es/sites/144/2016/07/geena-davis.png')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (272, N'Kevin Bacon', N'1958', N'Male', N'https://media.revistavanityfair.es/photos/60e83dc7b710ef1e877f7d89/master/w_1648,h_1361,c_limit/179257.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (273, N'Gary Sinise', N'1955', N'Male', N'https://www.formulatv.com/images/noticias/95300/95316/1_MsP8meEJkLc0vF7a4iWB1U352qY6xNRgo.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (274, N'Sharon Stone', N'1958', N'Female', N'https://imagenes.elpais.com/resizer/7_Nhv2X_0hV4Lh0Xw-iI6siAjmg=/1200x0/cloudfront-eu-central-1.images.arcpublishing.com/prisa/JRYMUBPASZC6RFARRK2SINNH7Q.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (275, N'Sylvester Stallonea', N'1946', N'Male', N'https://resizer.glanacion.com/resizer/PWGSq5_bTUJAnRQuNr0VnPWtMBk=/1119x746/smart/filters:quality(80)/cloudfront-us-east-1.images.arcpublishing.com/lanacionar/EHKUBS2IJRHMBJJ6UO3FGRXJD4.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (276, N'John Lithgow', N'1945', N'Male', N'https://www.soydemac.com/wp-content/uploads/2021/08/John-Lithgow-Apple-TV-Plus.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (277, N'Michael Rooker', N'Apr  6 1955 12:00AM', N'Male', N'https://www.latercera.com/resizer/EGcTGik1kZ3W_oOTR7nYMgXVOjk=/900x600/filters:focal(483x501:493x491)/cloudfront-us-east-1.images.arcpublishing.com/copesa/MLJMIV257FAEHGIONJS25SA3BQ.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (278, N'Harrison Ford', N'1942', N'Male', N'https://static.independent.co.uk/2021/06/23/16/newFile-2.jpg?width=982&height=726&auto=webp&quality=75')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (279, N'Scarlett Johansson', N'1984', N'Female', N'https://imagenes.elpais.com/resizer/2B4vY8Sqk86136UitgDX4EnR86g=/1960x0/cloudfront-eu-central-1.images.arcpublishing.com/prisa/PGBMKHXGEGL26ZIPY5MA74DXEY.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (280, N'Hilary Swank', N'Jul 30 1974 12:00AM', N'Female', N'https://fotografias.antena3.com/clipping/cmsimages01/2020/08/12/F03D2B53-9BBD-45A9-A437-7DA656B31223/98.jpg?crop=1919,1080,x0,y0&width=1900&height=1069&optimize=high&format=webply')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (281, N'Kathleen Quinlan', N'1954', N'Female', N'https://st.depositphotos.com/1814084/1773/i/950/depositphotos_17738677-stock-photo-kathleen-quinlan.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (282, N'Joely Richardson', N'1965', N'Female', N'https://www.ecured.cu/images/1/1b/Joelikim.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (283, N'Sean Pertwee', N'1964', N'Male', N'https://www.oldvic.ac.uk/wp-content/uploads/2020/03/19635409-high_res-the-pale-horse-mischief-screen-limited-2019BenBlackall.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (284, N'Ron Perlman', N'1950', N'Male', N'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/ron-perlman-attends-the-premiere-of-vertical-entertainments-news-photo-1593597395.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (285, N'Selma Blair', N'1972', N'Female', N'https://www.hola.com/imagenes/actualidad/20211011197566/selma-blair-emotivo-estreno-documental-introducing/1-5-813/selma-blair-getty-t.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (286, N'Ben Stiller', N'1965', N'Male', N'https://i0.wp.com/hipertextual.com/wp-content/uploads/2019/11/hipertextual-severance-es-nueva-serie-ben-stiller-apple-tv-2019423871.jpg?fit=1200%2C750&ssl=1')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (287, N'Juliette Lewis', N'1973', N'Female', N'https://media.revistavanityfair.es/photos/60e8476cc596c065cebfb385/master/w_1600%2Cc_limit/140699.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (288, N'Fred Williamson', N'1938', N'Male', N'https://theundefeated.com/wp-content/uploads/2017/01/gettyimages-476919683.jpg?w=700')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (289, N'Snoop Dogg', N'1971', N'Male', N'https://cdni.rt.com/actualidad/public_images/2021.07/article/60f85adee9ff7150525b4b73.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (290, N'Chris Penn', N'1965', N'Male', N'https://media.giphy.com/media/bmNxjetp7naJq/giphy.gif')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (291, N'Gerard Butler', N'1969', N'Male', N'https://i1.wp.com/observadorlatino.com/wp-content/uploads/2021/09/imagen243476-1629819242.jpg?resize=696%2C363&ssl=1')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (292, N'Dominic West', N'1969', N'Male', N'https://fotografias.antena3.com/clipping/cmsimages02/2020/10/20/44A98395-4410-48B7-A109-83BF7BF14516/98.jpg?crop=3333,1875,x0,y214&width=1900&height=1069&optimize=high&format=webply')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (293, N'David Wenham', N'1965', N'Male', N'https://www.wikye.com/wp-content/uploads/2020/03/The-image-of-David-Wenham.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (294, N'Lena Headey', N'1973', N'Female', N'https://imagenes.20minutos.es/files/image_656_370/uploads/imagenes/2017/10/18/233232.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (295, N'Malcolm McDowell', N'1943', N'Male', N'https://static3.elcorreo.com/www/multimedia/202110/26/media/cortadas/malcolm-mcdowell-kdiC-U150958202929u1G-1248x770@RC.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (296, N'James Doohan', N'1920', N'Male', N'https://estaticos-cdn.sport.es/clip/4e8f5b6f-1b01-4e6e-b5cf-b0cbab431a0d_alta-libre-aspect-ratio_default_0.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (297, N'Walter Koenig', N'1936', N'Male', N'https://images.mubicdn.net/images/cast_member/34108/cache-135219-1462627941/image-w856.jpg?size=800x')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (298, N'William Shatner', N'Mar 22 1931 12:00AM', N'Male', N'https://actualidadaeroespacial.com/wp-content/uploads/2021/10/Willian-Shatner-061021.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (299, N'Leonard Nimoy', N'1931', N'Male', N'https://estaticos-cdn.prensaiberica.es/clip/8289c747-2661-48ed-83a1-d8f4f0fd6dba_16-9-aspect-ratio_default_0.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (300, N'DeForest Kelley', N'1920', N'Male', N'https://media.gettyimages.com/photos/deforest-kelley-as-dr-leonard-bones-mccoy-in-the-movie-star-trek-ii-picture-id691253248?s=612x612')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (301, N'George Takei', N'1937', N'Male', N'https://espanol.news24viral.com/wp-content/uploads/2020/02/1581566867_479_La-verdad-no-contada-de-George-Takei.jpg')
GO
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (302, N'Nichelle Nichols', N'1932', N'Female', N'https://silverspock.files.wordpress.com/2012/03/nichelle_nichols1-e1315569324861vys1.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (303, N'Ricardo Montalban', N'1920', N'Male', N'https://e00-elmundo.uecdn.es/elmundo/imagenes/2009/01/15/1232017334_0.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (305, N'Marlon Brando', N'1924', N'Male', N'https://cdn.zendalibros.com/wp-content/uploads/marlon-brando.jpeg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (306, N'Gene Hackman', N'1930', N'Male', N'https://jornada.com.bo/wp-content/uploads/2020/01/Gene-Hackman.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (307, N'Christopher Reeve', N'1952', N'Male', N'https://imagenes.elpais.com/resizer/Ed7N_C8DlnrIojwSmPaDSmwINIo=/1200x0/cloudfront-eu-central-1.images.arcpublishing.com/prisa/PXG6BI6S2TBAZWB6LOFVTUGVTM.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (308, N'Margot Kidder', N'1948', N'Female', N'https://arc-anglerfish-eu-central-1-prod-prisa.s3.amazonaws.com/public/VGN6Q7TGQ7NQKJUKFPM2VMFHHI.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (309, N'James Gandolfini', N'1961', N'Male', N'https://i2.wp.com/fueradeseries.com/wp-content/uploads/2021/07/james-gandolfini-los-soprano.jpg?fit=1202%2C800&ssl=1')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (310, N'Val Kilmer', N'1959', N'Male', N'https://estaticos-cdn.elperiodico.com/clip/7b0ebff7-4079-4db3-a35f-cf2f17ef8dd3_alta-libre-aspect-ratio_default_0.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (311, N'Jim Caviezel', N'1968', N'Male', N'https://cloudfront-us-east-1.images.arcpublishing.com/eluniverso/PM6QCWSA65BX5DOFZ5AQ6EUAKU.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (312, N'Uma Thurman', N'1970', N'Female', N'https://www.lavanguardia.com/files/image_449_220/uploads/2020/04/28/5fa8fc8a3600c.jpeg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (313, N'Lucy Liu', N'1968', N'Female', N'https://img.allvipp.com/www-promipool-de/image/upload/c_fill,g_faces,w_1200,h_900,q_auto:eco,f_jpg/Lucy_Liu_201201_gl8y3qx5wl')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (314, N'Daryl Hannah', N'1960', N'Female', N'https://media.gettyimages.com/photos/daryl-hannah-attends-the-paradox-premiere-2018-sxsw-conference-and-picture-id932575552?s=594x594')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (315, N'David Carradine', N'1936', N'Male', N'https://resizer.glanacion.com/resizer/0nyoM9GOgI_9lNUhg2NHXtd_eqI=/1119x746/smart/filters:quality(80)/cloudfront-us-east-1.images.arcpublishing.com/lanacionar/JJRDVL4KWJGWRJ4XVI5KKLFMVU.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (316, N'Charles S. Dutton', N'1951', N'Male', N'https://blogdesuperheroes.es/imagen-noti/bds_powers_charles-s-dutton-se-une.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (317, N'Pete Postlethwaite', N'1946', N'Male', N'https://imagenes.heraldo.es/files/image_990_v1/uploads/imagenes/2011/01/03/_pete_postlethwaite_5a3b7dce.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (318, N'Wesley Snipes', N'1962', N'Male', N'https://i.blogs.es/912cb1/wesley-snipes/1366_2000.jpeg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (319, N'Kris Kristofferson', N'1936', N'Male', N'https://i.ytimg.com/vi/Cq9wJnw0PGU/maxresdefault.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (320, N'Donnie Yen', N'1963', N'Male', N'https://cinematicos.net/wp-content/uploads/l-intro-1629984580.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (321, N'Ryan Phillippe', N'1974', N'Male', N'https://imagenes.20minutos.es/files/article_amp/uploads/imagenes/2015/04/30/ryanphillippe.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (322, N'Robert De Niro', N'1943', N'Male', N'https://phantom-marca.unidadeditorial.es/a18db01ab7bf873c5531fafb5702bcda/crop/0x0/657x369/resize/1320/f/jpg/assets/multimedia/imagenes/2021/01/26/16116550912013.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (323, N'John Rhys-Davies', N'1944', N'Male', N'https://es.web.img3.acsta.net/pictures/17/10/03/02/37/4061373.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (324, N'Stephen Dorff', N'1973', N'Male', N'https://imagenes.elpais.com/resizer/2ez6z6Mztdcx8va-CgCd9ZU0MJE=/414x0/cloudfront-eu-central-1.images.arcpublishing.com/prisa/H5DCXM4WYBDE3MHWN6YEONPUHY.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (325, N'James Earl Jones', N'1931', N'Male', N'https://cronicasdelmultiverso.com/wp-content/uploads/2015/08/james_earl_jones_headshot.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (326, N'Julianne Moore', N'1960', N'Female', N'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/julianne-moore-1-1632379645.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (327, N'Joe Pantoliano', N'1951', N'Male', N'https://cdnb.20m.es/sites/144/2019/10/joe-pantoliano-matrix-620x393.jpeg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (328, N'Madeleine Stowe', N'1958', N'Female', N'https://hips.hearstapps.com/es.h-cdn.co/fotoes/images/cinefilia/que-fue-de-madeleine-stowe/134211430-2-esl-ES/Que-fue-de-Madeleine-Stowe.jpg?crop=1xw:0.7420289855072464xh;center,top&resize=480:*')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (329, N'Russell Means', N'1939', N'Male', N'https://cdn.britannica.com/97/164297-050-E9B6606E/Russell-Means-Oglala-Sioux.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (330, N'Wes Studi', N'1947', N'Male', N'https://cdn.aarp.net/content/dam/aarp/entertainment/celebrities/2019/11/1140-wes-studi-esp.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (331, N'Rudy Youngblood', N'1982', N'Male', N'https://cdn.allfamous.org/people/avatars/rudy-youngblood-d1jo-allfamous.org.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (332, N'Dalia Hernandez', N'1985', N'Female', N'https://pbs.twimg.com/profile_images/1366923339516833796/SgubzjPL_400x400.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (333, N'Rachel McAdams', N'1976', N'Female', N'https://cnnespanol.cnn.com/wp-content/uploads/2018/12/171026123506-rachel-mcadams-exlarge-169.jpg?quality=100&strip=info&w=460&h=260&crop=1')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (334, N'Isla Fisher', N'1976', N'Female', N'https://ca.hellomagazine.com/imagenes//celebrities/20211106125756/isla-fisher-unexpected-photo-with-redhead-sisters-triplets-twins-children/0-606-458/isla-fisher-dress-t.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (335, N'Jane Seymour', N'1951', N'Female', N'https://images.ecestaticos.com/CJaw7-mib8PdgPz5D47_BBjcBks=/0x0:2272x1571/1200x900/filters:fill(white):format(jpg)/f.elconfidencial.com%2Foriginal%2Fefc%2F598%2F831%2Fefc598831aecbe2e024b2355b22a0e90.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (336, N'Michael J. Fox', N'1961', N'Male', N'https://los40.com/los40/imagenes/2020/11/05/cinetv/1604617166_859146_1604619083_gigante_normal.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (337, N'Thomas F. Wilson', N'1959', N'Male', N'https://cdnb.20m.es/sites/144/2019/04/tom-wilson.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (338, N'Timothy Dalton', N'1944', N'Male', N'https://i0.wp.com/modogeeks.com/wp-content/uploads/2018/09/dalton-1.jpg?fit=742%2C450&ssl=1')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (339, N'Benicio Del Toro', N'1967', N'Male', N'https://media.revistagq.com/photos/5ca60324932b580a4610ff5d/3:2/w_645,h_430,c_limit/benicio_del_toro_premio_donostia_san_sebastian_8639.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (340, N'Robert Brown', N'1921', N'Male', N'http://www.aveleyman.com/Gallery/2017/B/49230.jpg')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender], [ActorImage]) VALUES (341, N'David Hedison', N'1927', N'Male', N'https://cloudfront-us-east-1.images.arcpublishing.com/eluniverso/TUPRAWX5DBHG7EAHT66LMOTLI4.jpg')
SET IDENTITY_INSERT [dbo].[tblActor] OFF
GO
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (1, 33, 1, N'Ray Ferrier')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (2, 1, 2, N'Dr. Alan Grant')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (3, 1, 3, N'Dr. Ellie Sattler')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (4, 1, 4, N'Dr. Ian Malcolm')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (5, 1, 5, N'John Hammond')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (6, 1, 6, N'Ray Arnold')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (7, 2, 7, N'Peter Parker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (8, 2, 8, N'Norman Osborn')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (9, 2, 9, N'Mary Jane Watson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (10, 3, 10, N'Ann Darrow')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (11, 3, 11, N'Carl Denham')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (12, 3, 12, N'Jack Driscoll')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (13, 3, 13, N'Kong')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (14, 5, 14, N'Clark Kent')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (15, 5, 15, N'Lois Lane')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (16, 5, 16, N'Lex Luthor')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (17, 6, 17, N'Jack Dawson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (18, 6, 18, N'Rose DeWitt Bukater')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (19, 6, 19, N'Caledon ''Cal'' Hockley')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (20, 6, 20, N'Brock Lovett')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (21, 7, 21, N'Evan Baxter')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (22, 7, 22, N'God')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (23, 8, 23, N'Mariner')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (24, 8, 24, N'Deacon')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (25, 8, 11, N'Pilot')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (26, 9, 25, N'Captain Rafe McCawley')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (27, 9, 26, N'Captain Danny Walker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (28, 9, 27, N'Nurse Lt. Evelyn Johnson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (29, 9, 28, N'Petty Officer Doris Miller')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (30, 9, 29, N'President Franklin Delano Roosevelt')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (31, 9, 30, N'Lt. Col. James Doolittle')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (32, 9, 31, N'Sgt. Earl Sistern')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (33, 9, 32, N'Captain Thurman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (34, 10, 33, N'Sam Witwicky')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (35, 10, 37, N'Mikaela Banes')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (36, 10, 29, N'Defense Secretary John Keller')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (37, 10, 34, N'Agent Simmons')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (38, 10, 35, N'Optimus Prime')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (39, 10, 36, N'Megatron')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (40, 11, 38, N'Harry Potter')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (41, 11, 39, N'Lord Voldemort')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (42, 11, 40, N'Alastor ''Mad-Eye'' Moody')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (43, 11, 41, N'Sirius Black')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (44, 11, 47, N'Hermione Granger')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (45, 11, 48, N'Ron Weasley')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (46, 11, 42, N'Albus Dumbledore')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (47, 11, 43, N'Severus Snape')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (48, 11, 44, N'Sybil Trelawney')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (49, 11, 45, N'Bellatrix Lestrange')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (50, 11, 46, N'Rubeus Hagrid')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (51, 12, 49, N'Wealthow')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (52, 12, 50, N'Hrothgar')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (53, 12, 51, N'Unferth')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (54, 12, 52, N'Beowulf')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (55, 12, 40, N'Wiglaf')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (56, 12, 53, N'Grendel''s Mother')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (57, 7, 54, N'Congressman Long')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (58, 13, 55, N'Barry B. Benson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (59, 13, 56, N'Vanessa Bloome')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (60, 13, 57, N'Adam Flayman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (61, 13, 54, N'Layton T. Montgomery')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (62, 13, 58, N'Mooseblood')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (63, 13, 59, N'Ray Liotta')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (64, 13, 60, N'Lou Lo Duca')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (65, 14, 61, N'Captain Jack Sparrow')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (66, 14, 62, N'Captain Barbossa')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (67, 14, 63, N'Will Turner')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (68, 14, 64, N'Elizabeth Swann')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (69, 14, 65, N'Davy Jones')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (70, 14, 66, N'Governor Weatherby Swann')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (71, 14, 67, N'''Bootstrap'' Bill Turner')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (72, 15, 68, N'Robert Neville')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (73, 15, 44, N'Dr. Alice Krippin')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (74, 16, 69, N'Remy')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (75, 16, 70, N'Skinner')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (76, 16, 71, N'Django')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (77, 16, 72, N'Anton Ego')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (78, 17, 73, N'Agamemnon')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (79, 17, 75, N'Achilles')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (80, 17, 40, N'Menelaus')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (81, 17, 76, N'Helen')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (82, 17, 77, N'Hector')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (83, 17, 63, N'Paris')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (84, 18, 38, N'Harry Potter')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (85, 18, 47, N'Hermione Granger')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (86, 18, 48, N'Ron Weasley')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (87, 18, 46, N'Rubeus Hagrid')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (88, 18, 42, N'Albus Dumbledore')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (89, 18, 43, N'Severus Snape')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (90, 18, 40, N'Professor Alastor ''Mad­Eye'' Moody')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (91, 18, 41, N'Sirius Black')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (92, 18, 39, N'Lord Voldemort')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (93, 19, 78, N'Bruce Wayne')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (94, 19, 79, N'Alfred')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (95, 19, 80, N'Henri Ducard')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (96, 19, 81, N'Rachel Dawes')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (97, 19, 41, N'Jim Gordon')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (98, 19, 82, N'Earle')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (99, 19, 83, N'Ra''s Al Ghul')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (100, 19, 22, N'Lucius Fox')
GO
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (101, 20, 61, N'Willy Wonka')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (102, 20, 45, N'Mrs. Bucket')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (103, 20, 84, N'Mr. Salt')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (104, 20, 85, N'Dr. Wonka')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (105, 21, 61, N'Captain Jack Sparrow')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (106, 21, 63, N'Will Turner')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (107, 21, 64, N'Elizabeth Swann')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (108, 21, 65, N'Davy Jones')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (109, 21, 66, N'Governor Weatherby Swann')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (110, 21, 67, N'''Bootstrap'' Bill Turner')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (111, 22, 86, N'James Bond')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (112, 22, 89, N'M')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (113, 22, 90, N'R')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (114, 22, 87, N'Jinx')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (115, 22, 88, N'Miranda Frost')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (116, 22, 91, N'Damian Falco')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (117, 22, 92, N'Miss Moneypenny')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (118, 23, 93, N'Martin Riggs')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (119, 23, 94, N'Roger Murtaugh')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (120, 23, 95, N'Leo Getz')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (121, 23, 96, N'Lorna Cole')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (122, 23, 58, N'Detective Lee Butters')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (123, 23, 97, N'Wah Sing Ku')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (124, 24, 98, N'Harry S. Stamper')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (125, 24, 99, N'Dan Truman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (126, 24, 25, N'A.J. Frost')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (127, 24, 100, N'Grace Stamper')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (128, 24, 101, N'Rockhound')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (129, 24, 102, N'Oscar Choi')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (130, 24, 103, N'Jayotis ''Bear'' Kurleenbear')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (131, 24, 104, N'Lev Andropov')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (132, 25, 68, N'Agent Jay')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (133, 25, 105, N'Agent Kay')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (134, 25, 60, N'Zed')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (135, 26, 7, N'Peter Parker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (136, 26, 9, N'Mary Jane Watson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (137, 27, 7, N'Peter Parker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (138, 27, 9, N'Mary Jane Watson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (139, 27, 8, N'Norman Osborn')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (140, 28, 106, N'Lt. Henry Purcell')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (141, 28, 107, N'Lt. Kara Wade')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (142, 29, 30, N'Captain Gray Edwards')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (143, 29, 108, N'Sgt. Ryan Whitaker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (144, 29, 101, N'Officer Neil Fleming')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (145, 29, 109, N'Dr. Cid')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (146, 29, 110, N'General Hein')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (147, 30, 111, N'Sonny Crockett')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (148, 30, 106, N'Ricardo Tubbs')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (149, 30, 112, N'FBI Agent Fujima')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (150, 31, 86, N'James Bond')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (151, 31, 113, N'Elektra')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (152, 31, 114, N'Renard')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (153, 31, 115, N'Christmas Jones')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (154, 31, 46, N'Valentin Zukovsky')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (155, 31, 116, N'Q')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (156, 31, 89, N'M')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (157, 31, 90, N'R')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (158, 31, 92, N'Miss Moneypenny')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (159, 32, 117, N'Captain Jack Aubrey')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (160, 32, 118, N'Dr. Stephen Maturin')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (161, 33, 119, N'Rachel Ferrier')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (162, 33, 120, N'Harlan Ogilvy')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (163, 34, 121, N'Jason Bourne')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (164, 34, 122, N'Nicky Parsons')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (165, 34, 123, N'Deputy Director Noah Vosen')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (166, 34, 124, N'Simon Ross')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (167, 34, 125, N'Dr. Albert Hirsch')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (168, 35, 38, N'Harry Potter')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (169, 35, 47, N'Hermione Granger')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (170, 35, 48, N'Ron Weasley')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (171, 35, 41, N'Sirius Black')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (172, 35, 43, N'Professor Severus Snape')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (173, 35, 46, N'Rubeus Hagrid')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (174, 35, 44, N'Professor Sybil Trelawney')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (175, 36, 126, N'Persephone')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (176, 36, 127, N'Morpheus')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (177, 36, 128, N'Trinity')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (178, 36, 129, N'Neo')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (179, 36, 36, N'Agent Smith')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (180, 37, 130, N'Dr. Robert Langdon')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (181, 37, 131, N'Agent Sophie Neveu')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (182, 37, 132, N'Sir Leigh Teabing')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (183, 37, 133, N'Captain Bezu Fache')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (184, 37, 118, N'Silas')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (185, 37, 134, N'Andre Vernet')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (186, 38, 135, N'Professor Albus Dumbledore')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (187, 38, 46, N'Rubeus Hagrid')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (188, 38, 38, N'Harry Potter')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (189, 38, 136, N'Mr. Ollivander')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (190, 38, 48, N'Ron Weasley')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (191, 38, 47, N'Hermione Granger')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (192, 38, 90, N'Nearly Headless Nick')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (193, 38, 43, N'Professor Severus Snape')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (194, 39, 137, N'Jack Hall')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (195, 39, 138, N'Sam Hall')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (196, 39, 70, N'Terry Rapson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (197, 40, 61, N'Captain Jack Sparrow')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (198, 40, 63, N'Will Turner')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (199, 40, 64, N'Elizabeth Swann')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (200, 40, 66, N'Governor Weatherby Swann')
GO
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (201, 40, 62, N'Captain Barbossa')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (202, 41, 1, N'Nathan Algren')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (203, 41, 83, N'Katsumoto')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (204, 264, 140, N'Kaneda')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (205, 264, 141, N'Capa')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (206, 264, 142, N'Corazon')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (207, 19, 141, N'Dr. Jonathan Crane')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (208, 41, 140, N'Ujio')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (209, 41, 139, N'Zebulon Gant')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (210, 42, 143, N'Captain Billy Tyne')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (211, 42, 144, N'Bobby Shatford')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (212, 42, 145, N'Dale ''Murph'' Murphy')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (213, 42, 146, N'Linda Greenlaw')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (214, 42, 147, N'Bob Brown')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (215, 43, 1, N'Ethan Hunt')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (216, 43, 148, N'Owen Davian')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (217, 43, 108, N'Luther')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (218, 43, 149, N'Julia')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (219, 43, 150, N'Benji')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (220, 43, 127, N'Theodore Brassel')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (221, 44, 1, N'Ethan Hunt')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (222, 44, 108, N'Luther Stickell')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (223, 44, 40, N'John C. McCloy')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (224, 45, 151, N'Christian Slater')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (225, 45, 104, N'Gunnery Sergeant Hjelmstad')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (226, 45, 152, N'Sgt. Pete ''Ox'' Anderson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (227, 46, 153, N'Obi-Wan Kenobi')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (228, 46, 154, N'Senator Padme Amidala')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (229, 46, 155, N'Anakin Skywalker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (230, 46, 85, N'Count Dooku')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (231, 46, 6, N'Mace Windu')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (232, 46, 156, N'Yoda')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (233, 46, 157, N'Chancellor Palpatine')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (234, 46, 158, N'Jango Fett')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (235, 265, 158, N'Jake Heke')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (236, 265, 159, N'Beth Heke')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (237, 47, 54, N'James P. "Sulley" Sullivan')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (238, 47, 160, N'Mike Wazowski')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (239, 47, 101, N'Randall Boggs')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (240, 47, 161, N'Henry J. Waternoose')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (241, 47, 156, N'Fungus')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (242, 48, 80, N'Qui-Gon Jinn')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (243, 48, 153, N'Obi-Wan Kenobi')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (244, 48, 154, N'Queen Padme Amidala')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (245, 48, 156, N'Yoda')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (246, 48, 157, N'Senator Palpatine')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (247, 48, 162, N'Darth Maul')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (248, 48, 163, N'C-3PO')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (249, 48, 164, N'R2-D2')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (250, 48, 6, N'Mace Windu')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (251, 48, 64, N'Sabé')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (252, 49, 153, N'Obi-Wan Kenobi')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (253, 49, 154, N'Padme')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (254, 49, 155, N'Anakin Skywalker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (255, 49, 157, N'Supreme Chancellor Palpatine')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (256, 49, 6, N'Mace Windu')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (257, 49, 156, N'Yoda')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (258, 49, 163, N'C-3PO')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (259, 49, 164, N'R2-D2')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (260, 49, 85, N'Count Dooku')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (261, 49, 158, N'Commander Cody')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (262, 49, 165, N'Chewbacca')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (263, 49, 159, N'Nee Alavar')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (264, 50, 126, N'Persephone')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (265, 50, 127, N'Morpheus')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (266, 50, 128, N'Trinity')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (267, 50, 129, N'Neo')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (268, 50, 36, N'Agent Smith')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (269, 51, 86, N'James Bond')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (270, 51, 66, N'Elliot Carver')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (271, 51, 142, N'Wai Lin')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (272, 51, 166, N'Jack Wade')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (273, 51, 89, N'M')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (274, 51, 116, N'Q')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (275, 51, 92, N'Miss Moneypenny')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (276, 52, 143, N'Danny Ocean')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (277, 52, 75, N'Rusty Ryan')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (278, 52, 167, N'Reuben Tishkoff')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (279, 52, 121, N'Linus Caldwell')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (280, 52, 168, N'Terry Benedict')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (281, 52, 169, N'Tess Ocean')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (282, 52, 170, N'Basher Tarr')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (283, 53, 98, N'John McClane')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (284, 53, 171, N'Thomas Gabriel')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (285, 53, 175, N'Mai')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (286, 54, 172, N'Passepartout')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (287, 54, 173, N'Phileas Fogg')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (288, 54, 177, N'Lord Kelvin')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (289, 54, 174, N'Prince Hapi')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (290, 54, 175, N'Female Agent')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (291, 54, 176, N'Wong Fei Hung')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (292, 54, 102, N'Wilbur Wright')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (293, 54, 90, N'Grizzled Sergeant')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (294, 54, 178, N'Orville Wright')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (295, 55, 80, N'Godfrey de Ibelin')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (296, 55, 63, N'Balian de Ibelin')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (297, 55, 40, N'Reynald')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (298, 55, 179, N'Tiberias')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (299, 55, 180, N'King Baldwin')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (300, 56, 75, N'John Smith')
GO
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (301, 56, 53, N'Jane Smith')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (302, 56, 181, N'Eddie')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (303, 56, 149, N'Gwen')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (304, 57, 17, N'Howard Hughes')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (305, 57, 182, N'Katharine Hepburn')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (306, 57, 27, N'Ava Gardner')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (307, 57, 145, N'Noah Dietrich')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (308, 57, 30, N'Juan Trippe')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (309, 57, 70, N'Professor Fitz')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (310, 57, 183, N'Errol Flynn')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (311, 57, 184, N'Robert Gross')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (312, 57, 8, N'Roland Sweet')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (313, 58, 68, N'Muhammad Ali')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (314, 58, 106, N'Drew ''Bundini'' Brown')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (315, 58, 29, N'Howard Cosell')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (316, 59, 182, N'Galadriel')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (317, 59, 63, N'Legolas Greenleaf')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (318, 59, 70, N'Bilbo Baggins')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (319, 59, 85, N'Saruman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (320, 59, 13, N'Gollum')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (321, 59, 132, N'Gandalf the Grey')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (322, 59, 185, N'Aragorn')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (323, 59, 100, N'Arwen')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (324, 59, 36, N'Elrond')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (325, 59, 186, N'Frodo Baggins')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (326, 60, 68, N'Del Spooner')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (327, 60, 33, N'Farber')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (328, 60, 188, N'Susan Calvin')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (329, 60, 187, N'Dr. Alfred Lanning')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (330, 61, 189, N'James Bond')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (331, 61, 89, N'M')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (332, 62, 1, N'Chief John Anderton')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (333, 62, 190, N'Director Lamar Burgess')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (334, 62, 111, N'Danny Witwer')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (335, 62, 104, N'Dr. Solomon Eddie')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (336, 63, 174, N'The Terminator')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (337, 63, 191, N'Sarah Connor')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (338, 63, 192, N'John Connor')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (339, 63, 193, N'T-1000')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (340, 64, 87, N'Patience Phillips')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (341, 65, 38, N'Harry Potter')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (342, 65, 48, N'Ron Weasley')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (343, 65, 47, N'Hermione Granger')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (344, 65, 46, N'Rubeus Hagrid')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (345, 65, 194, N'Professor Gilderoy Lockhart')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (346, 65, 43, N'Professor Snape')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (347, 65, 135, N'Professor Albus Dumbledore')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (348, 65, 90, N'Nearly Headless Nick')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (349, 66, 195, N'Frank Lucas')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (350, 66, 117, N'Detective Richie Roberts')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (351, 67, 17, N'Danny Archer')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (352, 67, 196, N'Solomon Vandy')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (353, 67, 197, N'Maddy Bowen')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (354, 67, 198, N'Colonel Coetzee')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (355, 68, 117, N'Maximus')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (356, 68, 199, N'Commodus')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (357, 68, 200, N'Lucilla')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (358, 68, 201, N'Proximo')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (359, 68, 135, N'Marcus Aurelius')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (360, 68, 196, N'Juba')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (361, 69, 174, N'Harry Tasker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (362, 69, 202, N'Helen Tasker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (363, 69, 203, N'Albert Gibson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (364, 69, 20, N'Simon')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (365, 69, 204, N'Spencer Trilby')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (366, 69, 205, N'Juno Skinner')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (367, 69, 206, N'Salim Abu Aziz')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (368, 69, 207, N'Dana Tasker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (369, 70, 17, N'Amsterdam Vallon')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (370, 70, 208, N'Bill ''The Butcher'' Cutting')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (371, 70, 209, N'Jenny Everdeane')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (372, 70, 177, N'Boss Tweed')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (373, 70, 145, N'Happy Jack')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (374, 70, 80, N'''Priest'' Vallon')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (375, 70, 40, N'Walter ''Monk'' McGinn')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (376, 71, 26, N'Eversmann')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (377, 71, 153, N'Grimes')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (378, 71, 31, N'McKnight')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (379, 71, 77, N'Hoot')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (380, 72, 98, N'Korben Dallas')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (381, 72, 41, N'Jean-Baptiste Emanuel Zorg')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (382, 72, 70, N'Father Vito Cornelius')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (383, 72, 210, N'Leeloo')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (384, 72, 211, N'Ruby Rhod')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (385, 59, 212, N'Boromir')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (386, 73, 212, N'Boromir')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (387, 73, 182, N'Galadriel')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (388, 73, 63, N'Legolas Greenleaf')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (389, 73, 70, N'Bilbo Baggins')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (390, 73, 132, N'Gandalf the White')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (391, 73, 185, N'Aragorn')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (392, 73, 13, N'Gollum')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (393, 73, 100, N'Arwen')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (394, 73, 36, N'Elrond')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (395, 73, 186, N'Frodo Baggins')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (396, 73, 85, N'Saruman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (397, 74, 182, N'Galadriel')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (398, 74, 63, N'Legolas Greenleaf')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (399, 74, 85, N'Saruman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (400, 74, 132, N'Gandalf the White')
GO
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (401, 74, 185, N'Aragorn')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (402, 74, 13, N'Gollum')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (403, 74, 100, N'Arwen')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (404, 74, 213, N'Eomer')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (405, 73, 213, N'Eomer')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (406, 74, 36, N'Elrond')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (407, 74, 186, N'Frodo Baggins')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (408, 74, 212, N'Boromir')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (409, 75, 172, N'Chief Inspector Lee')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (410, 75, 211, N'Detective James Carter')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (411, 75, 190, N'Varden Reynard')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (412, 75, 140, N'Kenji')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (413, 76, 172, N'Chief Inspector Lee')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (414, 76, 211, N'Detective James Carter')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (415, 76, 175, N'Girl in Car')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (416, 76, 170, N'Kenny')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (417, 77, 105, N'Agent Kay')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (418, 77, 68, N'Agent Jay')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (419, 77, 60, N'Zed')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (420, 77, 214, N'Dr. Laurel Weaver')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (421, 78, 17, N'William M. ''Billy'' Costigan Jr.')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (422, 78, 121, N'Colin')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (423, 78, 215, N'Costello')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (424, 78, 144, N'Dignam')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (425, 78, 216, N'Queenan')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (426, 78, 52, N'Mr. French')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (427, 78, 30, N'Ellerby')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (428, 79, 98, N'John McClane')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (429, 79, 179, N'Simon Gruber')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (430, 79, 6, N'Zeus Carver')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (431, 80, 117, N'Jim Braddock')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (432, 80, 56, N'Mae Braddock')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (433, 80, 217, N'Joe Gould')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (434, 80, 124, N'Mike Wilson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (435, 81, 121, N'Jason Bourne')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (436, 81, 73, N'Ward Abbott')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (437, 81, 122, N'Nicky Parsons')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (438, 81, 213, N'Kirill')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (439, 81, 149, N'Kim')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (440, 82, 174, N'Jack Slater')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (441, 82, 218, N'John Practice')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (442, 82, 132, N'Death')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (443, 82, 219, N'Benedict')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (444, 83, 130, N'Chuck Noland')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (445, 84, 75, N'Rusty Ryan')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (446, 84, 221, N'Isabel Lahiri')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (447, 84, 143, N'Danny Ocean')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (448, 84, 169, N'Tess Ocean')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (449, 84, 168, N'Terry Benedict')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (450, 84, 170, N'Basher Tarr')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (451, 84, 121, N'Linus Caldwell')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (452, 84, 167, N'Reuben Tishkoff')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (453, 84, 125, N'Gaspar LeMarque')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (454, 85, 222, N'Michael Newman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (455, 85, 27, N'Donna Newman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (456, 85, 223, N'Morty')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (457, 85, 224, N'Ammer')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (458, 85, 225, N'Ted Newman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (459, 86, 226, N'Bruce Nolan')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (460, 86, 22, N'God')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (461, 86, 227, N'Grace Connelly')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (462, 86, 21, N'Evan Baxter')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (463, 87, 1, N'Ethan Hunt')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (464, 87, 29, N'Jim Phelps')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (465, 87, 228, N'Claire Phelps')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (466, 87, 133, N'Franz Krieger')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (467, 87, 108, N'Luther Stickell')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (468, 87, 232, N'Max')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (469, 88, 229, N'Captain Spurgeon ''Fish'' Tanner')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (470, 88, 230, N'Jenny Lerner')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (471, 88, 186, N'Leo Beiderman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (472, 88, 232, N'Robin Lerner')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (473, 88, 22, N'President Tom Beck')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (474, 88, 187, N'Alan Rittenhouse')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (475, 88, 231, N'Dr. Gus Partenza')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (476, 89, 130, N'Michael Sullivan')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (477, 89, 233, N'John Rooney')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (478, 89, 189, N'Connor Rooney')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (479, 89, 112, N'Finn McGovern')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (480, 89, 183, N'Harlen Maguire')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (481, 89, 234, N'Frank Nitti')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (482, 90, 117, N'John Nash')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (483, 90, 235, N'Parcher')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (484, 90, 197, N'Alicia Nash')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (485, 90, 236, N'Dr. Rosen')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (486, 90, 118, N'Charles')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (487, 91, 79, N'Jasper')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (488, 91, 237, N'Theo Faron')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (489, 92, 77, N'Avner')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (490, 92, 189, N'Steve')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (491, 92, 112, N'Carl')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (492, 92, 62, N'Ephraim')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (493, 93, 68, N'Captain Steven Hiller')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (494, 93, 238, N'President Thomas J. Whitmore')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (495, 93, 4, N'David Levinson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (496, 93, 239, N'First Lady Marilyn Whitmore')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (497, 93, 240, N'Russell Casse')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (498, 93, 184, N'Dr. Brackish Okun')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (499, 94, 241, N'Wolverine')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (500, 94, 242, N'Professor Charles Xavier')
GO
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (501, 94, 132, N'Magneto')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (502, 94, 243, N'Jean Grey')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (503, 94, 87, N'Storm')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (504, 94, 162, N'Toad')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (505, 95, 242, N'Professor Charles Xavier')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (506, 95, 241, N'Wolverine')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (507, 95, 132, N'Magneto')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (508, 95, 87, N'Storm')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (509, 95, 243, N'Jean Grey')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (510, 95, 73, N'William Stryker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (511, 96, 244, N'John Patrick Mason')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (512, 96, 151, N'Dr. Stanley Goodspeed')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (513, 96, 235, N'Brigadier General Francis X. Hummel')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (514, 96, 245, N'Commander Anderson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (515, 97, 129, N'John Constantine')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (516, 97, 246, N'Angela Dodson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (517, 97, 33, N'Chas Kramer')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (518, 97, 196, N'Midnite')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (519, 97, 104, N'Satan')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (520, 98, 98, N'David Dunn')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (521, 98, 6, N'Elijah Price')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (522, 98, 49, N'Audrey Dunn')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (523, 99, 103, N'Lucius Washington')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (524, 99, 247, N'Ricky Bobby')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (525, 99, 145, N'Cal Naughton, Jr.')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (526, 99, 248, N'Jean Girard')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (527, 100, 249, N'Homer')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (528, 100, 251, N'Bart')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (529, 100, 250, N'Marge')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (530, 100, 252, N'Lisa')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (531, 101, 93, N'William Wallace')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (532, 101, 73, N'Argyle Wallace')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (533, 101, 253, N'King Edward I')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (534, 101, 113, N'Princess Isabelle')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (535, 101, 40, N'Hamish Campbell')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (536, 102, 138, N'Anthony Swofford')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (537, 102, 106, N'Staff Sergeant Sykes')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (538, 103, 199, N'Lucius Hunt')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (539, 103, 12, N'Noah Percy')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (540, 103, 254, N'Edward Walker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (541, 103, 255, N'Alice Hunt')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (542, 103, 40, N'August Nicholson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (543, 104, 256, N'Shrek')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (544, 104, 257, N'Donkey')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (545, 104, 258, N'Puss in Boots')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (546, 104, 90, N'King')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (547, 105, 256, N'Shrek')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (548, 105, 257, N'Donkey')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (549, 105, 258, N'Puss in Boots')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (550, 105, 90, N'King')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (551, 105, 209, N'Princess Fiona')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (552, 104, 209, N'Princess Fiona')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (553, 106, 235, N'Virgil ''Bud'' Brigman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (554, 106, 146, N'Lindsey Brigman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (555, 106, 245, N'Lt. Hiram Coffey')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (556, 107, 242, N'Captain Jean-Luc Picard')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (557, 107, 259, N'Commander William T. Riker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (558, 107, 184, N'Lt. Commander Data')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (559, 107, 260, N'Lt. Commander Geordi La Forge')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (560, 107, 261, N'Lt. Commander Worf')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (561, 107, 262, N'Dr. Beverly Crusher')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (562, 107, 263, N'Commander Deanna Troi')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (563, 107, 218, N'Ad''har Ru''afo')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (564, 108, 264, N'Eddie Valiant')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (565, 108, 265, N'Judge Doom')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (566, 108, 266, N'Jessica Rabbit')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (567, 108, 251, N'Dipped Shoe')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (568, 109, 61, N'Ichabod Crane')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (569, 109, 267, N'Katrina Van Tassel')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (570, 109, 42, N'Baltus Van Tassel')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (571, 109, 157, N'Doctor Lancaster')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (572, 109, 223, N'Hessian Horseman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (573, 109, 85, N'Burgomaster')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (574, 110, 268, N'Xander Cage')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (575, 110, 6, N'Agent Augustus Gibbons')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (576, 111, 98, N'John McClane')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (577, 111, 270, N'Holly McClane')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (578, 111, 269, N'Colonel Stuart')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (579, 111, 193, N'O''Reilly')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (580, 112, 271, N'Samantha Caine')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (581, 112, 6, N'Mitch Henessey')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (582, 112, 73, N'Dr. Nathan Waldman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (583, 113, 130, N'Jim Lovell')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (584, 113, 20, N'Fred Haise')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (585, 113, 272, N'Jack Swigert')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (586, 113, 273, N'Ken Mattingly')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (587, 113, 235, N'Gene Kranz')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (588, 114, 130, N'Captain John H. Miller')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (589, 114, 31, N'Sergeant Mike Horvath')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (590, 114, 268, N'Private Adrian Caparzo')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (591, 114, 121, N'Private James Francis Ryan')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (592, 114, 217, N'Sergeant Hill')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (593, 115, 180, N'The Narrator')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (594, 115, 75, N'Tyler Durden')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (595, 115, 45, N'Marla Singer')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (596, 116, 129, N'Neo')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (597, 116, 128, N'Trinity')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (598, 116, 127, N'Morpheus')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (599, 116, 36, N'Agent Smith')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (600, 117, 174, N'Douglas Quaid')
GO
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (601, 64, 274, N'Laurel Hedare')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (602, 82, 274, N'Catherine Tramell')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (603, 117, 274, N'Lori')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (604, 117, 147, N'Richter')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (605, 118, 275, N'Gabe Walker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (606, 118, 276, N'Eric Qualen')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (607, 118, 277, N'Hal Tucker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (608, 119, 278, N'Jack Ryan')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (609, 119, 8, N'John Clark')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (610, 120, 86, N'James Bond')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (611, 120, 212, N'Alec Trevelyan')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (612, 120, 243, N'Xenia Zirgavna Onatopp')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (613, 120, 166, N'Jack Wade')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (614, 120, 89, N'M')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (615, 120, 116, N'Q')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (616, 120, 92, N'Miss Moneypenny')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (617, 121, 26, N'Dwight ''Bucky'' Bleichert')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (618, 121, 279, N'Kay Lake')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (619, 121, 280, N'Madeleine Linscott')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (620, 122, 226, N'Truman Burbank')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (621, 122, 235, N'Christof')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (622, 122, 217, N'Control Room Director')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (623, 123, 127, N'Captain Miller')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (624, 123, 2, N'Dr. William Weir')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (625, 123, 281, N'Peters, Med Tech')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (626, 113, 281, N'Marilyn Lovell')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (627, 123, 282, N'Lt. Starck')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (628, 123, 283, N'Smith')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (629, 124, 121, N'Jason Bourne')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (630, 124, 237, N'The Professor')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (631, 124, 73, N'Ward Abbott')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (632, 124, 122, N'Nicky Parsons')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (633, 125, 284, N'Hellboy')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (634, 125, 136, N'Trevor ''Broom'' Bruttenholm')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (635, 125, 285, N'Liz Sherman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (637, 126, 102, N'Ken Hutchinson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (638, 126, 286, N'David Starsky')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (639, 126, 289, N'Huggy Bear')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (640, 126, 288, N'Captain Doby')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (641, 126, 181, N'Reese Feldman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (642, 126, 287, N'Kitty')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (643, 126, 290, N'Manetti')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (644, 126, 69, N'Disco DJ')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (645, 127, 143, N'Miles')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (646, 127, 221, N'Marylin')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (647, 127, 62, N'Donovan Donaly')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (648, 127, 99, N'Howard D. Doyle')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (649, 73, 293, N'Faramir')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (650, 74, 293, N'Faramir')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (651, 128, 291, N'King Leonidas')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (652, 128, 294, N'Queen Gorgo')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (653, 128, 292, N'Theron')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (654, 128, 293, N'Dilios')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (655, 129, 242, N'Captain Jean-Luc Picard')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (656, 129, 259, N'Commander William T. Riker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (657, 129, 184, N'Lt. Commander Data')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (658, 129, 260, N'Lt. Commander Geordi La Forge')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (659, 129, 261, N'Lt. Commander Worf')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (660, 129, 262, N'Dr. Beverly Crusher')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (661, 129, 263, N'Commander Deanna Troi')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (662, 129, 284, N'The Reman Viceroy')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (663, 146, 242, N'Captain Jean-Luc Picard')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (664, 146, 259, N'Commander William T. Riker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (665, 146, 184, N'Lt. Commander Data')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (666, 146, 260, N'Lt. Commander Geordi La Forge')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (667, 146, 261, N'Lt. Commander Worf')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (668, 146, 262, N'Dr. Beverly Crusher')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (669, 146, 263, N'Commander Deanna Troi')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (670, 146, 187, N'Dr. Zefram Cochrane')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (671, 160, 242, N'Captain Jean-Luc Picard')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (672, 160, 259, N'Commander William T. Riker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (673, 160, 184, N'Lt. Commander Data')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (674, 160, 260, N'Lt. Commander Geordi La Forge')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (675, 160, 261, N'Lt. Commander Worf')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (676, 160, 262, N'Dr. Beverly Crusher')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (677, 160, 263, N'Commander Deanna Troi')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (678, 160, 298, N'Captain James T. Kirk')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (679, 160, 295, N'Dr. Tolian Soran')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (680, 160, 296, N'Captain Montgomery "Scotty" Scott')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (681, 160, 297, N'Commander Pavel Chekov')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (682, 225, 298, N'Admiral James T. Kirk')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (683, 225, 299, N'Captain Spock')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (684, 225, 300, N'Dr. Leonard "Bones" McCoy')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (685, 225, 296, N'Commander Montgomery "Scotty" Scott')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (686, 225, 297, N'Commander Pavel Chekov')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (688, 225, 301, N'Commander Hikaru Sulu')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (689, 225, 302, N'Commander Uhura')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (690, 225, 303, N'Khan')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (700, 162, 296, N'Commander Montgomery "Scotty" Scott')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (701, 162, 297, N'Lt. Pavel Chekov')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (702, 162, 301, N'Lt. Commander Hikaru Sulu')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (703, 162, 302, N'Lt. Commander Uhura')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (704, 162, 298, N'Admiral James T. Kirk')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (705, 162, 299, N'Mr Spock')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (706, 162, 300, N'Dr. Leonard "Bones" McCoy')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (708, 201, 265, N'Commander Kruge')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (709, 201, 296, N'Commander Montgomery "Scotty" Scott')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (710, 201, 297, N'Commander Pavel Chekov')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (711, 201, 301, N'Commander Hikaru Sulu')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (712, 201, 302, N'Commander Uhura')
GO
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (713, 201, 298, N'Admiral James T. Kirk')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (714, 201, 299, N'Captain Spock')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (715, 201, 300, N'Dr. Leonard "Bones" McCoy')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (716, 174, 298, N'Captain James T. Kirk')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (717, 174, 299, N'Captain Spock')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (718, 174, 300, N'Dr. Leonard "Bones" McCoy')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (719, 174, 296, N'Captain Montgomery "Scotty" Scott')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (720, 174, 297, N'Commander Pavel Chekov')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (721, 174, 302, N'Commander Uhura')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (722, 174, 301, N'Commander Hikaru Sulu')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (723, 180, 298, N'Captain James T. Kirk')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (724, 180, 299, N'Captain Spock')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (725, 180, 300, N'Dr. Leonard "Bones" McCoy')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (726, 180, 296, N'Captain Montgomery "Scotty" Scott')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (727, 180, 297, N'Commander Pavel Chekov')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (728, 180, 302, N'Commander Uhura')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (729, 180, 301, N'Captain Hikaru Sulu')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (730, 180, 236, N'General Chang')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (731, 180, 261, N'Colonel Worf')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (732, 180, 152, N'Excelsior Communications Officer')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (733, 191, 298, N'Captain James T. Kirk')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (734, 191, 299, N'Captain Spock')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (735, 191, 300, N'Dr. Leonard "Bones" McCoy')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (736, 191, 296, N'Commander Montgomery "Scotty" Scott')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (737, 191, 301, N'Commander Hikaru Sulu')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (738, 191, 297, N'Commander Pavel Chekov')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (739, 191, 302, N'Commander Uhura')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (740, 130, 307, N'Clark Kent')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (741, 130, 305, N'Jor-El')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (742, 130, 306, N'Lex Luthor')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (743, 130, 308, N'Lois Lane')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (744, 131, 195, N'Lt. Commander Ron Hunter')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (745, 131, 306, N'Captain Frank Ramsey')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (746, 131, 185, N'Lt. Peter ''WEAPS'' Ince')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (747, 131, 309, N'Lt. Bobby Dougherty')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (748, 132, 195, N'Agent Doug Carlin')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (749, 132, 310, N'Agent Paul Pryzwarra')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (750, 132, 311, N'Carroll Oerstadt')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (751, 133, 195, N'Creasy')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (752, 133, 119, N'Pita')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (753, 133, 223, N'Rayburn')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (754, 134, 68, N'Robert Clayton Dean')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (755, 134, 306, N'Brill')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (756, 134, 29, N'Reynolds')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (757, 134, 11, N'Fiedler')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (758, 134, 31, N'Boss Paulie Pintero')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (759, 135, 312, N'The Bride')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (760, 135, 313, N'O-Ren Ishii')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (761, 135, 314, N'Elle Driver')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (762, 135, 315, N'Bill')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (763, 135, 91, N'Budd')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (764, 136, 255, N'Ellen Ripley')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (765, 136, 316, N'Dillon')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (766, 136, 219, N'Clemens')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (767, 136, 317, N'David')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (768, 137, 172, N'Chon Wang')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (769, 137, 102, N'Roy O''Bannon')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (770, 137, 313, N'Princess Pei Pei')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (771, 138, 312, N'The Bride')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (772, 138, 315, N'Bill')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (773, 138, 313, N'O-Ren Ishii')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (774, 138, 91, N'Budd')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (775, 138, 314, N'Elle Driver')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (776, 138, 6, N'Rufus')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (777, 139, 318, N'Blade')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (778, 139, 319, N'Abraham Whistler')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (779, 139, 284, N'Reinhardt')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (780, 139, 320, N'Snowman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (781, 140, 321, N'John "Doc" Bradley')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (782, 140, 193, N'Colonel Chandler Johnson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (783, 141, 322, N'Sam ''Ace'' Rothstein')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (784, 141, 274, N'Ginger McKenna')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (785, 141, 95, N'Nicky Santoro')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (786, 141, 110, N'Lester Diamond')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (787, 142, 23, N'Robin of Locksley')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (788, 142, 22, N'Azeem')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (789, 142, 146, N'Marian Dubois')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (790, 142, 152, N'Will Scarlett')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (791, 142, 43, N'Sheriff of Nottingham')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (792, 142, 244, N'King Richard')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (793, 143, 256, N'Shrek')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (794, 143, 257, N'Donkey')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (795, 143, 209, N'Princess Fiona')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (796, 143, 276, N'Lord Farquaad')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (797, 144, 172, N'Chon Wang')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (798, 144, 102, N'Roy O''Bannon')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (799, 144, 320, N'Wu Chow')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (800, 145, 278, N'Indiana Jones')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (801, 145, 244, N'Professor Henry Jones')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (802, 145, 323, N'Sallah')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (803, 59, 323, N'Gimli')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (804, 73, 323, N'Gimli')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (805, 74, 323, N'Gimli')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (806, 147, 318, N'Blade')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (807, 147, 319, N'Abraham Whistler')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (808, 147, 324, N'Deacon Frost')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (809, 148, 278, N'Jack Ryan')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (810, 148, 212, N'Sean Miller')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (811, 148, 6, N'Lt. Cmdr. Robby Jackson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (812, 148, 135, N'Paddy O''Neil')
GO
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (813, 148, 325, N'Admiral James Greer')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (814, 149, 278, N'Dr. Richard David Kimble')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (815, 149, 105, N'Marshal Samuel Gerard')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (816, 149, 326, N'Dr. Anne Eastman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (817, 149, 327, N'Deputy Marshal Cosmo Renfro')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (818, 150, 241, N'Robert Angier')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (819, 150, 78, N'Alfred Borden')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (820, 150, 79, N'Cutter')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (821, 150, 279, N'Olivia Wenscombe')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (822, 150, 13, N'Alley')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (823, 151, 208, N'Hawkeye')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (824, 151, 328, N'Cora Munro')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (825, 151, 329, N'Chinachgook')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (826, 151, 330, N'Magua')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (827, 152, 331, N'Jaguar Paw')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (828, 152, 332, N'Seven')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (829, 153, 102, N'John Beckwith')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (830, 153, 181, N'Jeremy Grey')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (831, 153, 223, N'Secretary William Cleary')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (832, 153, 333, N'Claire Cleary')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (833, 153, 334, N'Gloria Cleary')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (834, 153, 335, N'Kathleen Cleary')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (835, 154, 336, N'Marty McFly')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (836, 154, 265, N'Dr. Emmett Brown')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (837, 154, 337, N'Buford ''Mad Dog'' Tannen')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (838, 155, 336, N'Marty McFly')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (839, 155, 265, N'Dr. Emmett Brown')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (840, 155, 337, N'Biff Tannen')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (841, 156, 338, N'James Bond')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (842, 156, 339, N'Dario')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (843, 156, 116, N'Q')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (844, 156, 340, N'M')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (845, 156, 341, N'Felix Leiter')
GO
INSERT [dbo].[tblCountry] ([CountryID], [CountryName]) VALUES (48, N'China')
INSERT [dbo].[tblCountry] ([CountryID], [CountryName]) VALUES (79, N'France')
INSERT [dbo].[tblCountry] ([CountryID], [CountryName]) VALUES (118, N'Japan')
INSERT [dbo].[tblCountry] ([CountryID], [CountryName]) VALUES (167, N'New Zealand')
INSERT [dbo].[tblCountry] ([CountryID], [CountryName]) VALUES (240, N'United Kingdom')
INSERT [dbo].[tblCountry] ([CountryID], [CountryName]) VALUES (241, N'United States')
INSERT [dbo].[tblCountry] ([CountryID], [CountryName]) VALUES (257, N'Germany')
INSERT [dbo].[tblCountry] ([CountryID], [CountryName]) VALUES (258, N'Russia')
GO
SET IDENTITY_INSERT [dbo].[tblDirector] ON 

INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (4, N'Steven Spielberg', N'1946', N'Male', N'https://media.ambito.com/p/a158ad38334963c1307ab286d1593e91/adjuntos/239/imagenes/038/088/0038088299/steven-spielberg-03jpg.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (5, N'Joel Coen', N'1954', N'Male', N'https://static.toiimg.com/photo/msid-75157503/75157503.jpg?556529')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (6, N'Ethan Coen', N'1957', N'Male', N'https://images.moviefit.me/p/o/15476-ethan-coen.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (7, N'George Lucas', N'1944', N'Male', N'https://tentulogo.com/wp-content/uploads/lucas.png')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (8, N'Ang Lee', N'1954', N'Male', N'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/ang-lee-attends-paramount-pictures-premiere-of-gemini-man-news-photo-1570563590.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (9, N'Martin Scorsese', N'1942', N'Male', N'https://as01.epimg.net/meristation/imagenes/2021/08/22/reportajes/1629583520_865544_1629583728_noticia_normal.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (10, N'Clint Eastwood', N'1930', N'Male', N'https://e00-elmundo.uecdn.es/assets/multimedia/imagenes/2021/10/04/16333559885237.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (11, N'Sam Raimi', N'1959', N'Male', N'https://media.vandalsports.com/i/640x360/10-2021/2021104104148_1.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (12, N'Peter Jackson', N'1961', N'Male', N'https://hips.hearstapps.com/es.h-cdn.co/fotoes/images/noticias-cine/peter-jackson-volver-tierra-media-superheroes-dc/138042116-1-esl-ES/Peter-Jackson-no-sabe-si-volver-a-la-Tierra-Media-o-pasarse-a-los-superheroes-de-DC.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (14, N'Bryan Singer', N'1965', N'Male', N'https://pbs.twimg.com/media/DxtJVcQXQAIvUPJ.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (15, N'James Cameron', N'1954', N'Male', N'https://i0.wp.com/35milimetros.es/wp-content/uploads/2017/12/35-milimetros-james-cameron-e1513423781195.jpg?fit=1036%2C629&ssl=1')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (16, N'Tom Shadyac', N'1958', N'Male', N'https://i.guim.co.uk/img/static/sys-images/Guardian/Pix/pictures/2011/1/15/1295125408465/Invisible-Childrens-The-R-007.jpg?width=620&quality=85&auto=format&fit=max&s=d5b9c013cf3cdfd5d42cf297fe682f49')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (17, N'Kevin Reynolds', N'1952', N'Male', N'https://static.vix.com/es/sites/default/files/styles/1x1/public/btg/cine.batanga.com/files/Kevin-Reynolds-dirigira-Resurreccion-1.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (18, N'Michael Bay', N'1965', N'Male', N'https://as01.epimg.net/meristation/imagenes/2021/09/27/reportajes/1632736352_643211_1632736517_noticia_normal.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (19, N'David Yates', N'1963', N'Male', N'https://hips.hearstapps.com/es.h-cdn.co/fotoes/images/noticias-cine/david-yates-quiere-dirigir-las-5-entregas-de-animales-fantasticos/119541115-1-esl-ES/David-Yates-quiere-dirigir-las-5-entregas-de-Animales-fantasticos.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (20, N'Robert Zemeckis', N'1952', N'Male', N'https://loff.it/wp-content/uploads/2016/05/loffit-robert-zemeckis-director-de-cine-02-600x450-1526231140.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (21, N'Steve Hickner', N'1961', N'Male', N'https://images.mubicdn.net/images/cast_member/37735/cache-73767-1366368991/image-w856.jpg?size=800x')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (22, N'Gore Verbinski', N'1964', N'Male', N'https://elcomercio.pe/resizer/MLyxZnz13iD9zHRsmweOn26NVxI=/580x330/smart/filters:format(jpeg):quality(75)/arc-anglerfish-arc2-prod-elcomercio.s3.amazonaws.com/public/XYSDASA3ARD45BTCYE6NMDE624.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (23, N'Francis Lawrence', N'1971', N'Male', N'https://i0.wp.com/cuatrobastardos.com/wp-content/uploads/2020/04/main_1.jpg?resize=620%2C381&ssl=1')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (24, N'Brad Bird', N'1957', N'Male', N'http://www.elcinedeloqueyotediga.net/wp-content/uploads/2019/01/brad-bird-variety-creative-impact-honor.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (25, N'Wolfgang Petersen', N'1941', N'Male', N'https://cineuropa.org/imgCache/2015/11/24/1448372597652_0570x0400_0x0x0x0_1573603230460.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (26, N'Mike Newell', N'1942', N'Male', N'https://img.europapress.es/fotoweb/fotonoticia_20181026123438_420.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (27, N'Christopher Nolan', N'1970', N'Male', N'https://phantom-marca.unidadeditorial.es/92f61797297a8a9bdb68b5cf611300ef/resize/1320/f/jpg/assets/multimedia/imagenes/2020/12/08/16074183033056.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (28, N'Tim Burton', N'1958', N'Male', N'https://cdn.zendalibros.com/wp-content/uploads/tim-burton.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (29, N'Lee Tamahori', N'1950', N'Male', N'https://d6scj24zvfbbo.cloudfront.net/e6804250f7a5f633cc993a6d9b11ca5b/200003781-6acc36bc6b/Lee_Tamahori_3.jpg?ph=5b55b4c566')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (30, N'Richard Donner', N'1930', N'Male', N'https://www.24-horas.mx/wp-content/uploads/2021/07/AFP.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (31, N'Barry Sonnenfeld', N'1953', N'Male', N'https://images.wsj.net/im-175118?width=1280&size=1.33333333')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (32, N'Rob Cohen', N'1949', N'Male', N'https://images.mubicdn.net/images/cast_member/35936/cache-61510-1338229678/image-w856.jpg?size=800x')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (33, N'Hironobu Sakaguchi', N'1962', N'Male', N'https://as01.epimg.net/meristation/imagenes/2017/07/04/noticia/1499155200_858449_1532089154_portada_normal.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (34, N'Michael Mann', N'1943', N'Male', N'https://hips.hearstapps.com/es.h-cdn.co/fotoes/images/noticias-cine/michael-mann-paul-le-roux/137985965-1-esl-ES/Michael-Mann-vuelve-al-cine-criminal.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (35, N'Michael Apted', N'1941', N'Male', N'https://www.eluniversal.com.mx/sites/default/files/2021/01/08/michael_apted.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (36, N'Peter Weir', N'1944', N'Male', N'http://www.lacabecita.com/wp-content/uploads/Peter-Weir.png')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (37, N'Paul Greengrass', N'1955', N'Male', N'https://nosomosnonos.com/wp-content/uploads/2021/01/Paul-Greengrass.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (38, N'Alfonso Cuaron', N'1961', N'Male', N'https://www.eluniverso.com/resizer/Mdi8WEzlnyza9puNk1iDelCIrbA=/894x670/smart/filters:quality(70)/cloudfront-us-east-1.images.arcpublishing.com/eluniverso/CZR43GDDKREQ5HWAGPCOWODQK4.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (39, N'Andy Wachowski', N'1967', N'Male', N'https://static1.purepeople.com/articles/8/17/49/28/@/2121121-andy-wachowski-devenu-lilly-a-beverly-624x600-2.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (40, N'Ron Howard', N'1954', N'Male', N'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/ron-howard-1580504026.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (41, N'Chris Columbus', N'1958', N'Male', N'http://pulpfictioncine.com/download/multimedia.normal.834326b034a83497.63687269732d636f6c756d6275735f6e6f726d616c2e77656270.webp')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (42, N'Roland Emmerich', N'1955', N'Male', N'https://decine21.com/images/noticias/267/Roland-Emmerich.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (43, N'Edward Zwick', N'1952', N'Male', N'https://www.thefamouspeople.com/profiles/images/edward-zwick-1.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (44, N'J. J. Abrams', N'1966', N'Male', N'https://www.cinemascomics.com/wp-content/uploads/2021/05/jj-abrams.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (45, N'John Woo', N'1946', N'Male', N'https://imagenes.20minutos.es/files/article_amp/uploads/imagenes/2019/11/17/john-woo.jpeg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (46, N'Pete Docter', N'1968', N'Male', N'https://www.lavanguardia.com/files/image_948_465/uploads/2015/08/01/5fa28314d9dc4.jpeg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (47, N'Roger Spottiswoode', N'1945', N'Male', N'https://cdn.onebauer.media/one/empire-legacy/uploaded/roger-spottiswoode-director.jpg?format=jpg&quality=80&width=960&height=540&ratio=16-9&resize=aspectfill')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (48, N'Steven Soderbergh', N'1963', N'Male', N'https://www.bolsamania.com/seriesadictos/wp-content/uploads/2021/08/24203_01-intervista-a-steven-soderbergh.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (49, N'Len Wiseman', N'1973', N'Male', N'https://images.mubicdn.net/images/cast_member/54113/cache-73764-1366368535/image-w856.jpg?size=800x')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (50, N'Frank Coraci', N'1966', N'Male', N'https://deadline.com/wp-content/uploads/2019/02/frank-coraci-e1549972124323.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (51, N'Ridley Scott', N'1937', N'Male', N'https://i.blogs.es/0cf7d9/ridley-scott-enfadado/1366_2000.jpeg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (52, N'Doug Liman', N'1965', N'Male', N'https://modogeeks.com/wp-content/uploads/2016/08/doug_liman.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (53, N'Alex Proyas', N'1963', N'Male', N'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/alex-proyas-nocturna-madrid-1571822051.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (54, N'Martin Campbell', N'1940', N'Male', N'https://www.comingsoon.net/assets/uploads/2021/08/The-Protege-Martin-Campbell.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (55, N'Jean-Christophe Comar', N'1957', N'Male', N'https://m.media-amazon.com/images/M/MV5BZDM3MTRiZjctMmM1MC00YWFhLWE1MWYtMjQzZWI2MTQzODQ1XkEyXkFqcGdeQXVyMjAyNzEwNzg@._V1_.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (56, N'Luc Besson', N'1959', N'Male', N'https://i2.wp.com/www.sectorcine.com/wp-content/uploads/sectorcine/articulos/lucy-luc-besson.jpg?fit=700%2C390&ssl=1')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (57, N'Brett Ratner', N'1969', N'Male', N'https://noticieros.televisa.com/wp-content/uploads/2017/11/brett-ratner-productor-de-cine-acusado-de-acoso-sexual.png')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (58, N'John McTiernan', N'1951', N'Male', N'https://lebeauleblog.com/wp-content/uploads/2015/05/john_mctiernan-1280x720.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (59, N'Brian De Palma', N'1940', N'Male', N'https://hips.hearstapps.com/es.h-cdn.co/fotoes/images/cinefilia/brian-de-palma-para-principiantes/137573803-1-esl-ES/Brian-de-Palma-para-principiantes.jpg?crop=1.00xw:0.753xh;0,0.151xh&resize=480:*')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (60, N'Mimi Leder', N'1952', N'Female', N'https://cdn.macrumors.com/article-new/2018/07/mimileder-800x450.jpg?retina')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (61, N'Sam Mendes', N'1965', N'Male', N'https://media.timeout.com/images/105601960/750/422/image.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (62, N'M. Night Shyamalan', N'1970', N'Male', N'https://www.granadahoy.com/2019/02/24/cine/director-guionista-Night-Shyamalan-fotografia_1330977381_95571049_667x375.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (63, N'Adam McKay', N'1968', N'Male', N'https://elrincondehbo.com/wp-content/uploads/sites/3/2020/07/adam-mckay-2011397.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (64, N'David Silverman', N'1957', N'Male', N'https://upload.wikimedia.org/wikipedia/commons/c/cc/David_Silverman.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (65, N'Mel Gibson', N'1956', N'Male', N'https://media.revistavanityfair.es/photos/60e831a2af2c957f3eff021a/16:9/w_1280,c_limit/234360.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (66, N'Chris Miller', N'1975', N'Male', N'https://upload.wikimedia.org/wikipedia/commons/thumb/e/eb/Chris_Miller_%2817049939622%29.jpg/1200px-Chris_Miller_%2817049939622%29.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (67, N'Andrew Adamson', N'1966', N'Male', N'https://cdn.cumpleañosdefamosos.com/people/2017/1/ap4jA0AbTxVEOXeqK1UbZrSJ2T409xssrtkv_L.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (68, N'Jonathon Frakes', N'1952', N'Male', N'https://www.bolsamania.com/seriesadictos/wp-content/uploads/2019/05/william-riker-star-trek-picard-1068x632-450x266.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (69, N'Renny Harlin', N'1959', N'Male', N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlf4dSlXMfv12m1SWzjHeNIgjasZw_D8G9Iw&usqp=CAU')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (70, N'David Fincher', N'1962', N'Male', N'https://as01.epimg.net/meristation/imagenes/2021/09/29/reportajes/1632906056_913864_1632906597_noticia_normal.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (71, N'Guillermo del Toro', N'1964', N'Male', N'https://www.lavanguardia.com/files/image_449_253/uploads/2019/02/25/5fa517961ffbd.jpeg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (72, N'Paul Verhoeven', N'1938', N'Male', N'https://cineuropa.org/imgCache/2016/12/09/1481295869310_0570x0400_0x0x0x0_1573350044920.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (73, N'Phillip Noyce', N'1950', N'Male', N'http://www.funcinema.com.ar/wp-content/uploads/2017/10/phillip_noyce.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (74, N'Paul Anderson', N'1965', N'Male', N'https://lh3.googleusercontent.com/proxy/LosxEGFO5uOsEF2MPkrbGtXQTDoGTxOV28oXVYRZLskgnvrRTqedB0VdpOm0QAlxHwbwqXB0baPu2HqIvw8aqWvhdJiiYlATyPpQPUtWpza0eDK_jlLnSqM')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (75, N'Todd Phillips', N'1970', N'Male', N'https://cinematicos.net/wp-content/uploads/l-intro-1623694154.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (76, N'Zack Snyder', N'1966', N'Male', N'https://www.cinemascomics.com/wp-content/uploads/2021/02/zack-snyder-liga-de-la-justicia-sueldo-960x560.jpg?mrf-size=m')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (77, N'Stuart Baird', N'1947', N'Male', N'https://images.mubicdn.net/images/cast_member/28551/cache-92110-1393785128/image-w856.jpg?size=800x')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (78, N'Tony Scott', N'1944', N'Male', N'https://lh3.googleusercontent.com/proxy/vq659r5nARf9A7K0RfwrnXkUYecLOYFiB_CdXZOKj3j1ioRYjRnGIXcxo2ESNIt-Dz5BIrHp2IytOErPxZ5Wb-tvgaBnW2qF2CbSztWOIqQ_UcqcaL2OJUUatUv0U5iOsa_cxmYcftJXMdZDduNJ7d3ZX4_hdfdmV9Beu6rjPSIPkVHSV0cKzM-PgRxfbZI')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (79, N'Quentin Tarantino', N'1963', N'Male', N'https://as01.epimg.net/meristation/imagenes/2021/08/17/reportajes/1629196667_954060_1629200842_noticia_normal.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (80, N'Tom Dey', N'1965', N'Male', N'https://gcdn.lanetaneta.com/wp-content/uploads/2021/02/Tom-Dey-dirigira-el-largometraje-Wedding-Season-en-Netflix.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (81, N'David Dobkin', N'1969', N'Male', N'https://images.amcnetworks.com/amctv.la/wp-content/uploads/2015/07/David-Dobkin.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (82, N'Stephen Norrington', N'1964', N'Male', N'https://m.media-amazon.com/images/M/MV5BNzNhM2U3MjgtOTNjNy00MWQ0LTkyZmMtYWEzYjQ2NmEzNjMwXkEyXkFqcGdeQXVyMjUyNDk2ODc@._V1_.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (83, N'Andrew Davis', N'1946', N'Male', N'https://www.plateamagazine.com/images/fotos/andrew-davis.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (84, N'John Glen', N'1932', N'Male', N'https://ichef.bbci.co.uk/news/640/cpsprodpb/16287/production/_92895709_gettyimages-139419656.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (85, N'Frank Miller', N'1957', N'Male', N'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/iconic-illustrator-frank-miller-visits-the-build-series-to-news-photo-1594490415.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (86, N'Joss Whedon', N'1964', N'Male', N'https://static3.abc.es/media/play/2021/02/17/whedon-k2BI--620x349@abc.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (87, N'David Carson', N'1955', N'Male', N'http://dissenycv.es/wp-content/uploads/2017/02/dissenycv-es-davidcarson.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (88, N'Irvin Kershner', N'1923', N'Male', N'https://fotos00.noticiasdenavarra.com/2020/01/22/690x278/muere-irvin.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (89, N'Robert Wise', N'1914', N'Male', N'https://img.ecartelera.com/noticias/fotos/56300/56308/1.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (90, N'Richard Marquand', N'1938', N'Male', N'https://es.web.img3.acsta.net/medias/nmedia/18/35/41/62/18831488.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (91, N'David Cronenberg', N'1943', N'Male', N'https://sm.ign.com/ign_es/screenshot/default/cronenberg_eeat.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (92, N'Lewis Gilbert', N'1920', N'Male', N'https://estaticos-cdn.elperiodico.com/clip/018574bc-7f28-4619-ab08-72b9888be205_alta-libre-aspect-ratio_default_0.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (93, N'Andrew Dominik', N'1967', N'Male', N'https://www.frases333.com/wp-content/uploads/2019/01/Andrew-Dominik.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (94, N'Ivan Reitman', N'1946', N'Male', N'https://pbs.twimg.com/profile_images/542049271382417408/PsBGC9gm_400x400.jpeg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (95, N'William Shatner', N'1931', N'Male', N'https://actualidadaeroespacial.com/wp-content/uploads/2021/10/Willian-Shatner-061021.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (96, N'Nicholas Meyer', N'1945', N'Male', N'https://blog.trekcore.com/wp-content/uploads/2018/05/header-nicholas-meyer.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (97, N'Paul Michael Glaser', N'1943', N'Male', N'https://s.libertaddigital.com/fotos/noticias/1920/1080/fit/paul-michael-glaser-091013.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (98, N'Kevin Costner', N'1955', N'Male', N'https://images.ecestaticos.com/R6rKEXZYZze4Cy5vqoLgI_cc03g=/337x6:2272x1457/1200x899/filters:fill(white):format(jpg)/f.elconfidencial.com%2Foriginal%2F26f%2F0bc%2Fd66%2F26f0bcd668473acac76ce8dfc17746a4.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (99, N'Leonard Nimoy', N'1931', N'Male', N'https://estaticos-cdn.prensaiberica.es/clip/8289c747-2661-48ed-83a1-d8f4f0fd6dba_16-9-aspect-ratio_default_0.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (100, N'John Guillermin', N'1925', N'Male', N'https://upload.wikimedia.org/wikipedia/en/d/d5/John_Guillermin.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (101, N'Richard Attenborough', N'1923', N'Male', N'https://cdn.hobbyconsolas.com/sites/navi.axelspringer.es/public/styles/480/public/media/image/2014/08/373992-fallece-actor-director-richard-attenborough-90-anos.jpg?itok=vorIWxI7')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (102, N'Kurt Wimmer', N'1964', N'Male', N'https://deadline.com/wp-content/uploads/2021/09/kurt-wimmer-e1632238399414.jpg?w=1024')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (103, N'Robert Rodriguez', N'1968', N'Male', N'https://ca-times.brightspotcdn.com/dims4/default/ba3de4e/2147483647/strip/true/crop/4417x2945+0+0/resize/2400x1600!/quality/90/?url=https%3A%2F%2Fcalifornia-times-brightspot.s3.amazonaws.com%2Fd2%2Fe5%2F97f637e442d8b385971d15bdc5c9%2Fla-et-robert-rodriguez-handout-27.JPG')
GO
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (104, N'Larry Charles', N'1956', N'Male', N'https://lh3.googleusercontent.com/proxy/q5rUBOwT74zoMAKseknHYMci_XMGkXBfKvG349bYTRrMTceaSpMJwY1m_bSkPEgDkcemNeFl9s-g4gbD5zvPf7pqagL-__WxR5kz2wHTPUs3v4W-ilii-48Yn_ZDkkkmn7Eu')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (105, N'Yimou Zhang', N'1951', N'Male', N'https://static3.abc.es/media/play/2019/02/11/zhang-yimou-kN7--1248x698@abc.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (106, N'Edgar Wright', N'1974', N'Male', N'https://cineuropa.org/Files/2021/02/03/1612352647412.jpg?1612352660053')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (107, N'Ang Lee', N'1954', N'Male', N'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/ang-lee-attends-paramount-pictures-premiere-of-gemini-man-news-photo-1570563590.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (108, N'Danny Boyle', N'1956', N'Male', N'https://applauss.com/wp-content/uploads/2015/10/Danny-Boyle--770x511.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (109, N'Oliver Hirschbiegel', N'1957', N'Male', N'https://estaticos-cdn.elperiodico.com/clip/da4d30bf-838c-4fbd-a7ad-8967f6a575d7_alta-libre-aspect-ratio_default_0.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (110, N'Val Guest', N'1911', N'Male', N'https://static.filmin.es/images/director/4991/1/profile_0_3_500x0.webp')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (111, N'Jean-Pierre Jeunet', N'1953', N'Male', N'https://imagenes.elpais.com/resizer/Sp_qnM_O5cy9-0nBnyFjbZ-ucXE=/414x0/arc-anglerfish-eu-central-1-prod-prisa.s3.amazonaws.com/public/TIZNIIUOMAMHZSVIMLV7QJSPQU.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (112, N'Terence Young', N'1915', N'Male', N'https://www.biografiasyvidas.com/biografia/y/fotos/young_terence_2.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (113, N'Peter R. Hunt', N'1925', N'Male', N'https://m.media-amazon.com/images/M/MV5BMmI0MmIzZDAtNzc2MC00OTkzLWFlMzctOWJjNGI3ZGRjMGE2XkEyXkFqcGdeQXVyMTQxMjk0Mg@@._V1_.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (114, N'Stanley Tong', N'1960', N'Male', N'https://media.gettyimages.com/photos/director-stanley-tong-participates-in-a-press-conference-for-the-film-picture-id55589659?s=612x612')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (115, N'Guy Hamilton', N'1922', N'Male', N'https://estaticos-cdn.prensaiberica.es/clip/dd37c5b6-810d-4099-a3be-4feee7a9128d_16-9-aspect-ratio_default_0.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (116, N'George Clooney', N'1961', N'Male', N'https://media.revistavanityfair.es/photos/60e83186af2c957f3eff020b/master/w_1600%2Cc_limit/211248.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (117, N'Michael Anderson', N'1920', N'Male', N'https://www.davidlynch.es/wp-content/uploads/2017/06/tp-michael-j-anderson-1080x675.jpeg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (118, N'Sammo Hung', N'1952', N'Male', N'http://cdn.shopify.com/s/files/1/0646/4097/files/Sammo_Hung_2_1024x1024.jpg?v=1606478033')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (119, N'Timur Bekmambetov', N'1961', N'Male', N'https://deadline.com/wp-content/uploads/2020/02/10452391bg.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (120, N'Florian Henckel von Donnersmarck', N'1973', N'Male', N'https://s1.eestatic.com/2019/04/05/cultura/cine/entrevistas-directores_de_cine-estrenos_de_cine_388722566_119663036_1706x1280.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (121, N'Merian C. Cooper', N'1893', N'Male', N'https://wikidat.com/img/merian-c-cooper-b60dc35a88006372650e9170b23fa5ec.jpg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (122, N'Akira Kurosawa', N'1910', N'Male', N'https://www.lavanguardia.com/files/image_449_220/uploads/2020/03/20/5f15efaba54ec.jpeg')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender], [DirectorImage]) VALUES (123, N'Morgan Spurlock', N'1970', N'Male', N'https://imagenes.elpais.com/resizer/mdHbnTXwMnD9OMx7yQN5senJ-a0=/414x0/arc-anglerfish-eu-central-1-prod-prisa.s3.amazonaws.com/public/AI5YYNRCI7HPO3MRPGX4JQQV2U.jpg')
SET IDENTITY_INSERT [dbo].[tblDirector] OFF
GO
SET IDENTITY_INSERT [dbo].[tblFilm] ON 

INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (1, N'Jurassic Park', N'1993 ', 4, 241, 1, N'Scientists clone dinosaurs to populate a theme park which suffers a major security breakdown and releases the dinosaurs.', N'https://www.hollywoodreporter.com/wp-content/uploads/2015/04/mcdjupa_ec032_h.jpg', N'4.8')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (2, N'Spider-Man', N'2002 ', 11, 241, 5, N'When bitten by a genetically modified spider, a nerdy, shy, and awkward high school student gains spider-like abilities that he eventually must use to fight evil as a superhero after tragedy befalls his family.', N'https://cdn.hobbyconsolas.com/sites/navi.axelspringer.es/public/styles/hc_1440x810/public/media/image/2021/07/spider-man-2002-2413817.jpg?itok=-4c5P6Qd', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (3, N'King Kong', N'2005 ', 12, 241, 1, N'In 1933 New York, an overly ambitious movie producer coerces his cast and hired ship crew to travel to mysterious Skull Island, where they encounter Kong, a giant ape who is immediately smitten with leading lady Ann Darrow.', N'https://cartelera.elpais.com/assets/uploads/2020/01/24030124/F_09681.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (5, N'Superman Returns', N'2006 ', 14, 241, 6, N'After a long visit to the lost remains of the planet Krypton, the Man of Steel returns to earth to become the peoples savior once again and reclaim the love of Lois Lane.', N'https://i0.wp.com/updatemexico.com/wp-content/uploads/2021/06/superman-returns-2006-banner-02.jpg?fit=1280%2C1024&ssl=1', N'2.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (6, N'Titanic', N'1998 ', 15, 241, 4, N'Fictional romantic tale of a rich girl and poor boy who meet on the ill-fated voyage of the ''unsinkable'' ship.', N'https://s1.eestatic.com/2017/12/02/cultura/cine/cine-libros-titanic_266484540_56157411_1024x576.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (7, N'Evan Almighty', N'2007 ', 16, 241, 1, N'God (Freeman) contacts Congressman Evan Baxter (Carell) and tells him to build an ark in preparation for a great flood.', N'https://cfm.yidio.com/images/movie/26459/backdrop-640x360.jpg', N'2.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (8, N'Waterworld', N'1995 ', 17, 241, 1, N'In a future where the polar ice caps have melted and most of Earth is underwater, a mutated mariner fights starvation and outlaw "smokers," and reluctantly helps a woman and a young girl find dry land.', N'https://www.soundtrackcollector.com/img/cd/large/Waterworld-LLLCD1426a.jpg', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (9, N'Pearl Harbor', N'2001 ', 18, 241, 7, N'Pearl Harbor follows the story of two best friends, Rafe and Danny, and their love lives as they go off to join the war.', N'https://cdn.onebauer.media/one/empire-tmdb/films/676/images/cDctk61tUeQz4LX7tTFPknI28ea.jpg?format=jpg&quality=80&width=960&height=540&ratio=16-9&resize=aspectfill', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (10, N'Transformers', N'2007 ', 18, 241, 8, N'A war re-erupts on Earth between two robotic clans, the heroic Autobots and the evil Decepticons, leaving the fate of mankind hanging in the balance.', N'https://i1.wp.com/www.sectorcine.com/wp-content/uploads/sectorcine/articulos/transformers-5-optimus-prime-bumblebee%20(1).jpg?fit=1400%2C780&ssl=1', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (11, N'Harry Potter and the Order of the Phoenix', N'2007 ', 19, 240, 6, N'With their warning about Lord Voldemort''s return scoffed at, Harry and Dumbledore are targeted by the Wizard authorities as an authoritarian bureaucrat slowly seizes power at Hogwarts.', N'http://gonewiththetwins.com/new/wp-content/uploads/2015/08/harrypotterandtheorderofthephoenix.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (12, N'Beowulf', N'2007 ', 20, 241, 2, N'The warrior Beowulf must fight and defeat the monster Grendel who is terrorizing towns, and later, Grendel''s mother, who begins killing out of revenge.', N'https://mutantreviewers.files.wordpress.com/2011/03/beowulf.jpg?w=723&h=341', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (13, N'Bee Movie', N'2007 ', 21, 241, 8, N'Barry B. Benson, a bee who has just graduated from college, is disillusioned at his lone career choice: making honey. On a special trip outside the hive, Barry''s life is saved by Vanessa, a florist in New York City. As their relationship blossoms, he discovers humans actually eat honey, and subsequently decides to sue us.', N'https://variety.com/wp-content/uploads/2020/10/bee-movie.jpg', N'2.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (14, N'Pirates of the Caribbean: At World''s End', N'2007 ', 22, 241, 3, N'Captain Barbossa, Will Turner and Elizabeth Swann must sail off the edge of the map, navigate treachery and betrayal, and make their final alliances for one last decisive battle.', N'https://pbs.twimg.com/media/Ek2Se2TXUAEKS6v.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (15, N'I am Legend', N'2007 ', 23, 241, 6, N'Years after a plague kills most of humanity and transforms the rest into monsters, the sole survivor in New York City struggles valiantly to find a cure.', N'https://gonewiththetwins.com/new/wp-content/uploads/2016/05/iamlegend.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (16, N'Ratatouille', N'2007 ', 24, 241, 10, N'Remy is a young rat in the French countryside who arrives in Paris, only to find out that his cooking idol is dead. When he makes an unusual alliance with a restaurant''s new garbage boy, the culinary and personal adventures begin despite Remy''s family''s skepticism and the rat-hating world of humans.', N'https://ievenn.com/wp-content/uploads/ratatouille-2007-ievenn-1.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (17, N'Troy', N'2004 ', 25, 241, 6, N'An adaptation of Homer''s great epic, the film follows the assault on Troy by the united Greek forces and chronicles the fates of the men involved.', N'http://1.bp.blogspot.com/-7iRutzBNsr4/UAwK6wapzdI/AAAAAAAAAKo/JgjvhaVOvws/s1600/Troy+Movie.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (18, N'Harry Potter and the Goblet of Fire', N'2005 ', 26, 241, 6, N'Harry finds himself selected as an underaged competitor in a dangerous multi-wizardary school competition.', N'https://movieeez.files.wordpress.com/2016/11/maxresdefault.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (19, N'Batman Begins', N'2005 ', 27, 241, 6, N'The story of how Bruce Wayne became what he was destined to be: Batman.', N'https://mutantreviewers.files.wordpress.com/2012/08/batman-begins.jpg?w=723&h=362', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (20, N'Charlie and the Chocolate Factory', N'2005 ', 28, 241, 6, N'A young boy wins a tour through the most magnificent chocolate factory in the world, led by the world''s most unusual candy maker.', N'https://m.media-amazon.com/images/M/MV5BMTkxNjg2ODgxOV5BMl5BanBnXkFtZTcwMzEyNTIyMw@@._V1_.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (21, N'Pirates of the Caribbean: Dead Man''s Chest', N'2006 ', 22, 241, 3, N'Jack Sparrow races to recover the heart of Davy Jones to avoid enslaving his soul to Jones'' service, as other friends and foes seek the heart for their own agenda as well.', N'https://image.tmdb.org/t/p/w1280/10ephihGpbvRD4RFSlloLii0HQK.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (22, N'Die Another Day', N'2002 ', 29, 240, 11, N'James Bond is sent to investigate the connection between a North Korean terrorist and a diamond mogul who is funding the development of an international space weapon.', N'https://main.net955305.contentfabric.io/q/iq__2d3wSxzdyid7QYfwACZicbvJT2cn/meta/public/asset_metadata/images/title_detail_hero_desktop/default?authorization=eyJxc3BhY2VfaWQiOiJpc3BjMlJVb1JlOWVSMnYzM0hBUlFVVlNwMXJZWHp3MSIsImFkZHIiOiIweGZhNTM5Yzg0ODY5MWVjMmYwN2U3ZWFkNDBkZmJkN2RlZTZjZTZlMDQiLCJxbGliX2lkIjoiaWxpYjM2OTFMZWNEaDl5TnlxS0hwd1h0bWVqOGtTNHYifQ==.RVMyNTZLX1A4TEx2VGRUV0pvZnppNlJoN0ExQ2g1aWZaUnVoY2RrWG5UWExGUkFWWFFXZmlDVDc2c2hQR3dTSkVFWXg3MmNoSDNKc3RGcFIzNkpyM2laUmoydlZnSGFq', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (23, N'Lethal Weapon 4', N'1998 ', 30, 241, 6, N'With personal crises and age weighing in on them, LAPD officers Riggs and Murtaugh must contend with a deadly Chinese crimelord trying to get his brother out of prison.', N'http://gonewiththetwins.com/new/wp-content/uploads/2015/04/lethalweapon4.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (24, N'Armageddon', N'1998 ', 18, 241, 7, N'When an asteroid the size of Texas is headed for Earth the world''s best deep core drilling team is sent to nuke the rock from the inside.', N'https://lh3.googleusercontent.com/proxy/g3s8waJg4ynDeEdgIIRWpUg-e0z36zTeFuClJH5CODeVMVdliMcIqDfrfZrU_vinHFncHmZ-13W2uE5BwPwrNv-5gcJp8Em8bFq2FYdKqN1--ApSqVkhRtGpShOdnGt47o5URg', N'2')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (25, N'Men in Black 2', N'2002 ', 31, 241, 5, N'Agent J needs help so he is sent to find Agent K and restore his memory.', N'https://noescinetodoloquereluce.com/wp-content/uploads/2017/10/men-in-black.jpg', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (26, N'Spider-Man 3', N'2007 ', 11, 241, 5, N'A strange black entity from another world bonds with Peter Parker and causes inner turmoil as he contends with new villains, temptations, and revenge.', N'https://cdn.onebauer.media/one/empire-tmdb/films/559/images/4dLA0LgN7tOMSsGwSUSZM7VG7AP.jpg?format=jpg&quality=80&width=850&ratio=16-9&resize=aspectfill', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (27, N'Spider-Man 2', N'2004 ', 11, 241, 5, N'Peter Parker is beset with troubles in his failing personal life as he battles a brilliant scientist named Doctor Otto Octavius, who becomes Doctor Octopus (aka Doc Ock), after an accident causes him to bond psychically with mechanical tentacles that do his bidding.', N'https://images.moviesanywhere.com/980ffe0de224551b0dd5db82d98ac700/cbd116cc-afe8-4067-98e4-5082348a277b.jpg?w=2560&r=16x9', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (28, N'Stealth', N'2005 ', 32, 241, 5, N'Deeply ensconced in a top-secret military program, three pilots struggle to bring an artificial intelligence program under control ... before it initiates the next world war.', N'https://images-na.ssl-images-amazon.com/images/S/pv-target-images/7529a3adf995959d2f3d07eec2ff7293d690e8a6cc2141162345069b4de71921._UY500_UX667_RI_V_TTW_.jpg', N'2.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (29, N'Final Fantasy: The Spirits Within', N'2001 ', 33, 118, 12, N'A female scientist makes a last stand on Earth with the help of a ragtag team of soldiers against an invasion of alien phantoms.', N'https://images-na.ssl-images-amazon.com/images/S/pv-target-images/0c588abcf17cbc8c6ce00552379290dfb899a4533dcae2b26453b51386940e19._V_SX1080_.jpg', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (30, N'Miami Vice', N'2006 ', 34, 241, 1, N'Based on the 1980''s TV action/drama, this update focuses on vice detectives Crockett and Tubbs as their respective personal and professional lives become dangerously intertwined.', N'https://a.ltrbxd.com/resized/sm/upload/yp/z4/la/qy/miami-vice-1200-1200-675-675-crop-000000.jpg?k=32222b1bfb', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (31, N'The World Is Not Enough', N'1999 ', 35, 240, 11, N'James Bond uncovers a nuclear plot when he protects an oil heiress from her former kidnapper, an international terrorist who can''t feel pain.', N'https://a.ltrbxd.com/resized/sm/upload/68/f6/uz/79/world-not-enough-1200-1200-675-675-crop-000000.jpg?k=2183c9ff2a', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (32, N'Master and Commander: The Far Side of the World', N'2003 ', 36, 241, 4, N'During the Napoleonic Wars, a brash British captain pushes his ship and crew to their limits in pursuit of a formidable French war vessel around South America.', N'https://img.hulu.com/user/v3/artwork/95ff2899-b3ed-4834-b525-cf0064b78007?base_image_bucket_name=image_manager&base_image=360cf2fc-d87a-4de8-a0e2-d8a5b785f167&region=US&format=jpeg&size=952x536', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (33, N'War of the Worlds', N'2005 ', 4, 241, 2, N'As Earth is invaded by alien tripod fighting machines, one family fights for survival.', N'https://images.static-bluray.com/reviews/20953_5.jpg', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (34, N'The Bourne Ultimatum', N'2007 ', 37, 241, 1, N'Bourne dodges new, superior assassins as he searches for his unknown past while a government agent tries to track him down.', N'https://upl.roob.la/2019/09/The-Bourne-Ultimatum-2007.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (35, N'Harry Potter and the Prisoner of Azkaban', N'2004 ', 38, 240, 6, N'It''s Harry''s third year at Hogwarts; not only does he have a new "Defense Against the Dark Arts" teacher, but there is also trouble brewing. Convicted murderer Sirius Black has escaped the Wizards'' Prison and is coming after Harry.', N'https://image.tmdb.org/t/p/w1280/obKmfNexgL4ZP5cAmzdL4KbHHYX.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (36, N'The Matrix Reloaded', N'2003 ', 39, 241, 6, N'Neo and the rebel leaders estimate that they have 72 hours until 250,000 probes discover Zion and destroy it and its inhabitants. During this, Neo must decide how he can save Trinity from a dark fate in his dreams.', N'http://3.bp.blogspot.com/-ot2RXWQH0sY/VB-mWKN26CI/AAAAAAAAAOQ/lguF9M-8mYk/s1600/b6ae8b6f387dcfd871dec590fbe4137b.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (37, N'The Da Vinci Code', N'2006 ', 40, 241, 5, N'A murder inside the Louvre and clues in Da Vinci paintings lead to the discovery of a religious mystery protected by a secret society for two thousand years -- which could shake the foundations of Christianity.', N'https://s3.amazonaws.com/static.rogerebert.com/uploads/review/primary_image/reviews/the-da-vinci-code-2006/EB20060518REVIEWS60419009AR.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (38, N'Harry Potter and the Philosopher''s Stone', N'2001 ', 41, 240, 6, N'Rescued from the outrageous neglect of his aunt and uncle, a young boy with a great destiny proves his worth while attending Hogwarts School of Witchcraft and Wizardry.', N'https://parentpreviews.com/images/made/legacy-pics/harry-potter-1-2_960_540_80.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (39, N'The Day After Tomorrow', N'2004 ', 42, 241, 4, N'A climatologist tries to figure out a way to save the world from abrupt global warming. He must get to his young son in New York, which is being taken over by a new ice age.', N'https://cdn.hipwallpaper.com/i/10/11/dzJl9S.jpg', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (40, N'Pirates of the Caribbean: Curse of the Black Pearl', N'2003 ', 22, 241, 3, N'Blacksmith Will Turner teams up with eccentric pirate "Captain" Jack Sparrow to save his love, the governor''s daughter, from Jack''s former pirate allies, who are now undead.', N'https://strikingfilmreviews.files.wordpress.com/2018/12/pirates-of-the-caribbean-1.jpg?w=1200', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (41, N'The Last Samurai', N'2004 ', 43, 241, 6, N'An American military advisor embraces the Samurai culture he was hired to destroy after he is captured in battle.', N'https://benjweinberg.files.wordpress.com/2020/03/1-997.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (42, N'The Perfect Storm', N'2000', 25, 241, 6, N'An unusually intense storm pattern catches some commercial fishermen unaware and puts them in mortal danger.', N'https://occ-0-34-32.1.nflxso.net/dnm/api/v6/0DW6CdE4gYtYx8iy3aj8gs9WtXE/AAAABT6D46sqa5LXyuWxmLSNyNG6FBkTU-3oYKqOtuLlEUZNXf5YzqUfGRLz_wWGyF859NeAjMdGT0SS8BQnDgnOq0iJhaE.jpg', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (43, N'Mission: Impossible III', N'2006', 44, 241, 2, N'Ethan Hunt comes face to face with a dangerous and sadistic arms dealer while trying to keep his identity secret in order to protect his girlfriend.', N'https://thecriticalcritics.com/review/wp-content/images/mission_impossible_3-still_1-1160x580.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (44, N'Mission: Impossible II', N'2000', 45, 241, 2, N'A secret agent is sent to Sydney, to find and destroy a genetically modified disease called "Chimera"', N'https://vodzilla.co/wp-content/uploads/2018/07/mission-impossible-2-700x412.jpg', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (45, N'Windtalkers', N'2002', 45, 241, 11, N'Two U.S. Marines in WWII are assigned to protect Navajo Marines who use their native language as an unbreakable radio cypher.', N'https://cdn.onebauer.media/one/empire-tmdb/films/12100/images/gP9C1wmbF2CV4SZkPbVvfawRuTv.jpg?format=jpg&quality=80&width=850&ratio=16-9&resize=aspectfill', N'1.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (46, N'Star Wars: Episode II - Attack of the Clones', N'2002', 7, 241, 13, N'Anakin Skywalker shares a forbidden romance with Padmé Amidala while his teacher, Obi-Wan Kenobi, makes an investigation of a separatist assassination attempt on Padmé which leads to the discovery of a secret Republican clone army.', N'https://stevealdous.co.uk/wp-content/uploads/2021/02/Attack-of-the-Clones.jpg', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (47, N'Monsters, Inc.', N'2002', 46, 241, 10, N'Monsters generate their city''s power by scaring children, but they are terribly afraid themselves of being contaminated by children, so when one enters Monstropolis, top scarer Sulley find his world disrupted.', N'https://culturedvultures.com/wp-content/uploads/2015/11/3617_monsters_inc.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (48, N'Star Wars: Episode I - The Phantom Menace', N'1999', 7, 241, 13, N'The evil Trade Federation, led by Nute Gunray (Carson) is planning to take over the peaceful world of Naboo.', N'https://image.tmdb.org/t/p/w1280/qDEvctVfAheD7x9Rzz8xcFRAGAU.jpg', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (49, N'Star Wars: Episode III - Revenge of the Sith', N'2005', 7, 241, 13, N'After three years of fighting in the Clone Wars, Anakin Skywalker concludes his journey towards the Dark Side of the Force, putting his friendship with Obi Wan Kenobi and his marriage at risk.', N'https://cdn.wallpapersafari.com/94/40/IfP0vz.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (50, N'The Matrix Revolutions', N'2003', 39, 241, 6, N'The human city of Zion defends itself against the massive invasion of the machines as Neo fights to end the war at another front while also opposing the rogue Agent Smith.', N'https://plosiontube.com/wp-content/uploads/2021/03/The-Matrix-Revolutions-2003.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (51, N'Tomorrow Never Dies', N'1997', 47, 240, 11, N'James Bond heads to stop a media mogul''s plan to induce war between China and the UK in order to obtain exclusive global media coverage.', N'https://theactionelite.com/wp-content/uploads/2018/01/tomorrow-never-dies-poster.jpg', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (52, N'Ocean''s Eleven', N'2002', 48, 241, 6, N'Danny Ocean and his ten accomplices plan to rob three Las Vegas casinos simultaneously.', N'https://m.media-amazon.com/images/I/A1pmq5hwXML._SL1500_.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (53, N'Live Free or Die Hard', N'2007', 49, 241, 4, N'John McClane takes on an Internet-based terrorist organization who is systematically shutting down the United States.', N'https://www.themoviedb.org/t/p/w780/aRqTPOPt8BOHE0ngppM9jnuuaeS.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (54, N'Around the World in 80 Days', N'2004', 50, 241, 3, N'A bet pits a British inventor, a Chinese thief, and a French artist on a worldwide adventure that they can circle the globe in 80 days.', N'https://a.ltrbxd.com/resized/sm/upload/ys/ug/it/63/80%20days-1200-1200-675-675-crop-000000.jpg?k=13dcc4d695', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (55, N'Kingdom of Heaven', N'2005', 51, 241, 4, N'Balian of Ibelin travels to Jerusalem during the crusades of the 12th century, and there he finds himself as the defender of the city and its people.', N'https://i0.wp.com/lavozdelarabe.mx/wp-content/uploads/2019/04/20160816122756.jpeg?resize=800%2C445&ssl=1', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (56, N'Mr. and Mrs. Smith', N'2005', 52, 241, 4, N'A bored married couple is surprised to learn that they are both assassins hired by competing agencies to kill each other.', N'https://d2e111jq13me73.cloudfront.net/sites/default/files/styles/share_link_image_large/public/product-images/csm-movie/3202-orig.jpg?itok=jWp5HpM7', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (57, N'The Aviator', N'2005', 9, 241, 6, N'A biopic depicting the early years of legendary director and aviator Howard Hughes'' career, from the late 1920s to the mid-1940s.', N'https://resources.stuff.co.nz/content/dam/images/4/y/p/p/t/t/image.related.StuffLandscapeThreeByTwo.600x400.4ypptr.png/1606892199036.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (58, N'Ali', N'2002', 34, 241, 5, N'A biography of sports legend, Muhammad Ali, from his early days to his days in the ring', N'http://aeqai.com/main/wp-content/uploads/2016/06/pic-450x344.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (59, N'The Lord of the Rings: Fellowship of the Ring', N'2001', 12, 167, 14, N'In a small village in the Shire a young Hobbit named Frodo has been entrusted with an ancient Ring. Now he must embark on an Epic quest to the Cracks of Doom in order to destroy it.', N'http://gonewiththetwins.com/new/wp-content/uploads/2016/11/lordoftheringsfellowshipofthering.jpg', N'4.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (60, N'I, Robot', N'2004', 53, 241, 4, N'In the year 2035 a techno-phobic cop investigates a crime that may have been perpetrated by a robot, which leads to a larger threat to humanity.', N'https://s3.amazonaws.com/static.rogerebert.com/uploads/review/primary_image/reviews/i-robot-2004/homepage_EB20040716REVIEWS40711001AR.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (61, N'Casino Royale', N'2006', 54, 240, 11, N'In his first mission, James Bond must stop Le Chiffre, a banker to the world''s terrorist organizations, from winning a high-stakes poker tournament at Casino Royale in Montenegro.', N'https://thehoganreviews.files.wordpress.com/2021/09/casino-royale.jpg?w=600', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (62, N'Minority Report', N'2002', 4, 241, 8, N'In the future, criminals are caught before the crimes they commit, but one of the officers in the special unit is accused of one such crime and sets out to prove his innocence.', N'https://lh3.googleusercontent.com/proxy/4_scGCfJcx37Ay0XOtz_2GYHh6CvmP4yiNM6J5XWT6MyUo0rfIcabGO6fEqN4UaYZE1_gQ-SiAag3weTP0T5kbea_8GEU8n0BSO_a1FnKrPgPdrwXMdWVhavvJbH2br872ndsxCY9A', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (63, N'Terminator 2: Judgement Day', N'1991', 15, 241, 15, N'The cyborg who once tried to kill Sarah Connor must now protect her teenager son, John Connor, from an even more powerful and advanced cyborg.', N'https://e.snmc.io/i/1200/s/ca3f5f4f0613afdb532ac668bd9c9541/3357485', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (64, N'Catwoman', N'2004', 55, 241, 6, N'A shy woman, endowed with the speed, reflexes, and senses of a cat, walks a thin line between criminal and hero, even as a detective doggedly pursues her, fascinated by both of her personas.', N'https://c4.wallpaperflare.com/wallpaper/855/805/218/halle-berry-catwoman-4k-wallpaper-thumb.jpg', N'1.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (65, N'Harry Potter and the Chamber of Secrets', N'2002', 41, 240, 6, N'Harry ignores warnings not to return to Hogwarts, only to find the school plagued by a series of mysterious attacks and a strange voice haunting him.', N'https://miro.medium.com/max/1400/0*EhIlNzn62UyINlV5.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (66, N'American Gangster', N'2007', 51, 241, 1, N'In 1970s America, a detective works to bring down the drug empire of Frank Lucas, a heroin kingpin from Manhattan, who is smuggling the drug into the country from the Far East.', N'https://static.metacritic.com/images/products/movies/1/c1d6469aaf7d612b451e9b2cfb6ef100.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (67, N'Blood Diamond', N'2007', 43, 241, 6, N'A fisherman, a smuggler, and a syndicate of businessmen match wits over the possession of a priceless diamond.', N'https://m.media-amazon.com/images/M/MV5BNTAwMDE5MDg4MF5BMl5BanBnXkFtZTcwMzMzMzkyMw@@._V1_.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (68, N'Gladiator', N'2000', 51, 241, 8, N'When a Roman general is betrayed and his family murdered by a corrupt prince, he comes to Rome as a gladiator to seek revenge.', N'https://gonewiththetwins.com/new/wp-content/uploads/2016/11/gladiator.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (69, N'True Lies', N'1994', 15, 241, 4, N'When a secret agent learns of his wife''s extra-marital affair, he pursues her and uses his intelligence resources in a job he kept secret from her.', N'https://www.hollywoodreporter.com/wp-content/uploads/2019/06/true_lies_-_h_-_1994.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (70, N'Gangs of New York', N'2003', 9, 241, 16, N'In 1863, Amsterdam Vallon returns to the Five Points area of New York City seeking revenge against Bill the Butcher, his father''s killer.', N'https://d2e111jq13me73.cloudfront.net/sites/default/files/styles/share_link_image_large/public/screenshots/csm-movie/gangs-of-new-york-screenshot-1.jpeg?itok=RgnFc5PJ', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (71, N'Black Hawk Down', N'2002', 51, 241, 17, N'123 elite U.S. soldiers drop into Somalia to capture two top lieutenants of a renegade warlord and find themselves in a desperate battle with a large force of heavily-armed Somalis.', N'https://m.media-amazon.com/images/M/MV5BNGM1MjU4MTYtODY4OC00NzU0LWI2ZjYtOTBiOWYxZTY2ODg1XkEyXkFqcGdeQXVyNzU1NzE3NTg@._V1_QL75_UX500_CR0,47,500,281_.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (72, N'The Fifth Element', N'1997', 56, 79, 18, N'In the colorful future, a cab driver unwittingly becomes the central figure in the search for a legendary cosmic weapon to keep Evil and Mr Zorg at bay.', N'https://imagesvc.meredithcorp.io/v3/mm/image?q=85&c=sc&poi=face&w=2000&h=1000&url=https%3A%2F%2Fstatic.onecms.io%2Fwp-content%2Fuploads%2Fsites%2F6%2F2017%2F07%2F5thelement_sammelin_flat-watermark-2000.jpg', N'4.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (73, N'The Lord of the Rings: Return of the King', N'2003', 12, 167, 14, N'The former Fellowship of the Ring prepare for the final battle for Middle Earth, while Frodo & Sam approach Mount Doom to destroy the One Ring.', N'https://steamunlocked.pro/wp-content/uploads/2021/01/the-lord-of-the-rings-the-return-of-the-king-free-download.jpg', N'4.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (74, N'The Lord of the Rings: The Two Towers', N'2002', 12, 167, 14, N'Frodo and Sam continue on to Mordor in their mission to destroy the One Ring. Whilst their former companions make new allies and launch an assault on Isengard.', N'https://keithandthemovies.files.wordpress.com/2018/08/twoposter.png', N'4.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (75, N'Rush Hour 3', N'2007', 57, 241, 14, N'After an attempted assassination on Ambassador Han, Lee and Carter head to Paris to protect a French woman with knowledge of the Triads'' secret leaders.', N'https://images.immediate.co.uk/remote/m.media-amazon.com/images/S/pv-target-images/5e9dbd73e25627269933052b0b53beb3e2226d6b880d005dc57318c6d731868c.jpg?quality=90&resize=556,313', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (76, N'Rush Hour 2', N'2001', 57, 241, 14, N'Carter and Lee head to Hong Kong for vacation, but become embroiled in a counterfeit money scam.', N'https://www.themoviedb.org/t/p/w780/zzFTSEAZcLGSbGipQVflSNUqpij.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (77, N'Men in Black', N'1997', 31, 241, 5, N'Two men who keep an eye on aliens in New York City must try to save the world after the aliens threaten to blow it up.', N'https://www.rollingstone.com/wp-content/uploads/2018/06/mib-1b7ebbde-d567-4437-9107-27d273313d5b.jpg?resize=1800,1200&w=1800', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (78, N'The Departed', N'2006', 9, 241, 6, N'Two men from opposite sides of the law are undercover within the Massachusetts State Police and the Irish mafia, but violence and bloodshed boil when discoveries are made, and the moles are dispatched to find out their enemy''s identities.', N'https://cdn.onebauer.media/one/empire-tmdb/films/1422/images/8Od5zV7Q7zNOX0y9tyNgpTmoiGA.jpg?format=jpg&quality=80&width=960&height=540&ratio=16-9&resize=aspectfill', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (79, N'Die Hard: With A Vengeance', N'1995', 58, 241, 4, N'John McClane and a store owner must play a bomber''s deadly game as they race around New York while trying to stop him.', N'https://cdn.onebauer.media/one/empire-tmdb/films/1572/images/aJCEQFFXNcfg5YneJzTG15qzxF7.jpg?format=jpg&quality=80&width=850&ratio=16-9&resize=aspectfill', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (80, N'Cinderella Man', N'2005', 40, 241, 1, N'The story of James Braddock, a supposedly washed up boxer who came back to become a champion and an inspiration in the 1930s.', N'https://images.mubicdn.net/images/film/30999/cache-32975-1445893338/image-w1280.jpg?size=800x', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (81, N'The Bourne Supremacy', N'2004', 37, 241, 1, N'When Jason Bourne is framed for a botched CIA operation he is forced to take up his former life as a trained assassin to survive.', N'https://wallpapers.moviemania.io/desktop/movie/2502/f5adc1/the-bourne-supremacy-desktop-wallpaper.jpg?w=2552&h=1442', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (82, N'Last Action Hero', N'1993', 58, 241, 5, N'A young movie fan gets thrown into the movie world of his favourite action film character.', N'https://i.kinja-img.com/gawker-media/image/upload/c_fill,f_auto,fl_progressive,g_center,h_675,pg_1,q_80,w_1200/a436e957c34c84ed9d85734679744124.jpg', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (83, N'Cast Away', N'2001', 20, 241, 8, N'A FedEx executive must transform himself physically and emotionally to survive a crash landing on a deserted island.', N'https://images.mubicdn.net/images/film/5294/cache-10946-1481130711/image-w1280.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (84, N'Ocean''s Twelve', N'2005', 48, 241, 6, N'Daniel Ocean recruits one more team member so he can pull off three major European heists in this sequel to Ocean''s 11.', N'https://streamondemandathome.com/wp-content/uploads/2020/11/oceans12.jpg', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (85, N'Click', N'2006', 50, 241, 5, N'A workaholic architect finds a universal remote that allows him to fast-forward and rewind to different parts of his life. Complications arise when the remote starts to overrule his choices.', N'https://abstracticality.files.wordpress.com/2014/07/click_-_2006.jpeg?w=654', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (86, N'Bruce Almighty', N'2003', 16, 241, 1, N'A guy who complains about God too often is given almighty powers to teach him how difficult it is to run the world.', N'https://thepressingon.files.wordpress.com/2013/06/freemanbruce30.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (87, N'Mission: Impossible', N'1996', 59, 241, 2, N'An American agent, under false suspicion of disloyalty, must discover and expose the real spy without the help of his organization.', N'https://m.media-amazon.com/images/M/MV5BNGMyNDRiMTctZTg1Ny00Nzk1LWJjYWYtOGNmYzQ0YmE4MzMyXkEyXkFqcGdeQW1pYnJ5YW50._V1_.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (88, N'Deep Impact', N'1998', 60, 241, 2, N'Unless a comet can be destroyed before colliding with Earth, only those allowed into shelters will survive. Which people will survive?', N'http://thecomeback.com/thestudentsection/wp-content/uploads/sites/165/2015/08/deepimpact.jpg', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (89, N'Road to Perdition', N'2002', 61, 241, 8, N'Bonds of loyalty are put to the test when a hitman''s son witnesses what his father does for a living.', N'https://cdn.onebauer.media/one/empire-tmdb/films/4147/images/285qaXgc8vtmxTN77HmPmvpBMDP.jpg?format=jpg&quality=80&width=960&height=540&ratio=16-9&resize=aspectfill', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (90, N'A Beautiful Mind', N'2002', 40, 241, 1, N'After a brilliant but asocial mathematician accepts secret work in cryptography, his life takes a turn to the nightmarish.', N'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/hostedimages/1493411925i/22612910._SX540_.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (91, N'Children of Men', N'2006', 38, 241, 1, N'In 2027, in a chaotic world in which humans can no longer procreate, a former activist agrees to help transport a miraculously pregnant woman to a sanctuary at sea, where her child''s birth may help scientists save the future of humankind.', N'https://m.media-amazon.com/images/M/MV5BMTg4MDEyODA0NF5BMl5BanBnXkFtZTgwMzUxNDE2MzI@._V1_.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (92, N'Munich', N'2006', 4, 241, 8, N'Based on the true story of the Black September aftermath, about the five men chosen to eliminate the ones responsible for that fateful day.', N'https://d2e111jq13me73.cloudfront.net/sites/default/files/styles/review_gallery_carousel_slide_thumbnail/public/screenshots/csm-movie/munich-ss3.jpg?itok=HJlB4Z9l', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (93, N'Independence Day', N'1996', 42, 241, 4, N'The aliens are coming and their goal is to invade and destroy. Fighting superior technology, Man''s best weapon is the will to survive.', N'https://cdn.hobbyconsolas.com/sites/navi.axelspringer.es/public/styles/855/public/media/image/2016/07/independence-day-1996.jpg?itok=I72bRWoz', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (94, N'X-Men', N'2000', 14, 241, 4, N'Two mutants come to a private academy for mutants whose resident superhero team must oppose a powerful mutant terrorist organization.', N'http://3.bp.blogspot.com/-L8EaOlTZ54s/U8PgaKqTSII/AAAAAAAANTo/dGRnY_40GPw/s1600/xmen+actors.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (95, N'X2', N'2003', 14, 241, 4, N'The X-Men band together to find a mutant assassin who has made an attempt on the President''s life, while the Mutant Academy is attacked by military forces.', N'https://i.blogs.es/3f3af3/128/1366_2000.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (96, N'The Rock', N'1996', 18, 241, 17, N'A group of U.S. marines, under command of a renegade general, take over Alcatraz and threat San Francisco Bay with biological weapons. A chemical weapons specialist and the only man to have ever escaped from the Rock are the only ones who can prevent chaos.', N'https://theactionelite.com/wp-content/uploads/2018/01/the-rock-10-1200-1200-675-675-crop-000000-770x433.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (97, N'Constantine', N'2005', 23, 241, 6, N'Based on the DC/Vertigo comic book Hellblazer and written by Kevin Brodbin, Mark Bomback and Frank Capello, Constantine tells the story of irreverent supernatural detective John Constantine (Keanu Reeves), who has literally been to hell and back.', N'https://www.denofgeek.com/wp-content/uploads/2013/03/constantine4.jpg?fit=1280%2C720', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (98, N'Unbreakable', N'2000', 62, 241, 7, N'A suspense thriller with supernatural overtones that revolves around a man who learns something extraordinary about himself after a devastating accident.', N'https://express-images.franklymedia.com/6616/sites/56/2019/01/11011331/Unbreakable-e1547190834627.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (99, N'Talladega Nights: The Ballad of Ricky Bobby', N'2006', 63, 241, 5, N'#1 NASCAR driver Ricky Bobby (Ferrell) stays atop the heap thanks to a pact with his best friend and teammate, Cal Naughton, Jr. (Reilly). But when a French Formula One driver (Cohen), makes his way up the ladder, Ricky Bobby''s talent and devotion are put to the test.', N'https://m.media-amazon.com/images/M/MV5BODk3NTU0NTUwNV5BMl5BanBnXkFtZTcwOTI2NjIzNA@@._V1_.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (100, N'The Simpsons Movie', N'2007', 64, 241, 4, N'After Homer accidentally pollutes the town''s water supply, Springfield is encased in a gigantic dome by the EPA and the Simpsons family are declared fugitives.', N'https://mrmoviefiend.files.wordpress.com/2010/06/the-simpsons-movie-poster-11.jpg', N'3.5')
GO
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (101, N'Braveheart', N'1995', 65, 241, 2, N'William Wallace, a commoner, unites the 13th Century Scots in their battle to overthrow English rule.', N'https://images.mubicdn.net/images/film/3369/cache-90787-1445946503/image-w1280.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (102, N'Jarhead', N'2006', 61, 241, 1, N'Based on former Marine Anthony Swofford''s best-selling 2003 book about his pre-Desert Storm experiences in Saudi Arabia and about his experiences fighting in Kuwait.', N'https://m.media-amazon.com/images/M/MV5BMTUwNDgxOTUyMF5BMl5BanBnXkFtZTYwNjg3NzQ3._V1_.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (103, N'The Village', N'2004', 62, 241, 7, N'The population of a small, isolated countryside village believe that their alliance with the mythical creatures that inhabit the forest around them is coming to an end.', N'https://cdn.hobbyconsolas.com/sites/navi.axelspringer.es/public/styles/hc_1440x810/public/media/image/2017/01/bosque_6.jpg?itok=b4vl2q-Z', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (104, N'Shrek the Third', N'2007', 66, 241, 8, N'When his new father-in-law, King Harold falls ill, Shrek is looked at as the heir to the land of Far, Far Away. Not one to give up his beloved swamp, Shrek recruits his friends Donkey and Puss in Boots to install the rebellious Artie as the new king. Princess Fiona, however, rallies a band of royal girlfriends to fend off a coup d''etat by the jilted Prince Charming.', N'https://100filmsinayear.files.wordpress.com/2018/05/shrek-the-third.jpg?w=560', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (105, N'Shrek 2', N'2004', 67, 241, 8, N'Princess Fiona''s parents invite her and Shrek to dinner to celebrate her marriage. If only they knew the newlyweds were both ogres.', N'https://m.media-amazon.com/images/M/MV5BZGRhNGQwNjUtYmFlMS00ODdiLWI3YTUtNjViOWYzZmU2YzhjXkEyXkFqcGdeQXVyNzU1NzE3NTg@._V1_QL75_UX500_CR0,47,500,281_.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (106, N'The Abyss', N'1989', 15, 241, 4, N'A civilian diving team are enlisted to search for a lost nuclear submarine and face danger while encountering an alien aquatic species.', N'https://www.hollywoodreporter.com/wp-content/uploads/2014/11/the_abyss_1989_still.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (107, N'Star Trek: Insurrection', N'1999', 68, 241, 2, N'When the crew of the Enterprise learn of a Federation plot against the inhabitants of a unique planet, Capt. Picard begins an open rebellion.', N'http://basementrejects.com/wp-content/uploads/2013/06/star-trek-insurrection-jean-luc-picard-troi-data-crusher-worf-michael-dorn-patrick-stewart-brent-spiner-marina-sirtis-gates-mcfadden.jpg', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (108, N'Who Framed Roger Rabbit?', N'1988', 20, 241, 7, N'A toon hating detective is a cartoon rabbit''s only hope to prove his innocence when he is accused of murder.', N'https://i.guim.co.uk/img/media/8c362550e6b6bb209c4fe04e2ade96c4a63eb836/0_50_2304_1382/master/2304.jpg?width=1200&quality=85&auto=format&fit=max&s=f86cdf0446f12ad4aa54b97b7e2fdcd6', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (109, N'Sleepy Hollow', N'2000', 28, 241, 2, N'Ichabod Crane is sent to Sleepy Hollow to investigate the decapitations of 3 people with the culprit being the legendary apparition, the Headless Horseman.', N'https://m.media-amazon.com/images/M/MV5BMTkwNzE2MTQyMF5BMl5BanBnXkFtZTgwMTQ2MTc5MzI@._V1_.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (110, N'xXx', N'2002', 32, 241, 19, N'Xander Cage is an extreme sports athelete recruited by the government on a special mission.', N'https://images-na.ssl-images-amazon.com/images/S/pv-target-images/5025f17e9bd212035b9766065baf1bbef0abe7270e90c2ff594ccc5ad5d07472._RI_.jpg', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (111, N'Die Hard 2', N'1990', 69, 241, 4, N'John McClane is forced to battle mercenaries who seize control of an airport''s communications and threaten to cause plane crashes if their demands are not met.', N'https://2.bp.blogspot.com/-eP4DmEy0tQ8/WE8t170v4uI/AAAAAAAAbTY/gnyZDjqCicEu3eIE4yBEqdyLiwN9NqJuQCLcB/s640/die%2Bhard%2B2%2B1.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (112, N'The Long Kiss Goodnight', N'1996', 69, 241, 14, N'A women suffering from amnesia begins to recover her memories after trouble from her past finds her again.', N'https://www.denofgeek.com/wp-content/uploads/2013/01/lkg_lead.jpg?resize=677%2C432', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (113, N'Apollo 13', N'1995', 40, 241, 1, N'True story of the moon-bound mission that developed severe trouble and the men that rescued it with skill and dedication.', N'https://d2e111jq13me73.cloudfront.net/sites/default/files/styles/share_link_image_large/public/screenshots/csm-movie/apollo-1.jpg?itok=hneaEW6E', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (114, N'Saving Private Ryan', N'1998', 4, 241, 8, N'Based on a World War II drama. US soldiers try to save their comrade, paratrooper Private Ryan, who''s stationed behind enemy lines.', N'https://m.media-amazon.com/images/M/MV5BMTMxNDQzNTIxN15BMl5BanBnXkFtZTcwNTI2NzgwMw@@._V1_.jpg', N'4.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (115, N'Fight Club', N'1999', 70, 241, 4, N'An office employee and a soap salesman build a global organization to help vent male aggression.', N'https://images.mubicdn.net/images/film/918/cache-47457-1614343063/image-w1280.jpg?size=800x', N'4.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (116, N'The Matrix', N'1999', 39, 241, 6, N'A computer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against the controllers of it.', N'https://i.guim.co.uk/img/media/5e0f098d236a9ac8174c47f0f798c85f9b5686fb/0_0_2496_1497/master/2496.jpg?width=465&quality=45&auto=format&fit=max&dpr=2&s=9713d2b19a67f987e4e7b8aeab9617f5', N'4.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (117, N'Total Recall', N'1990', 72, 241, 15, N'When a man goes for virtual vacation memories of the planet Mars, an unexpected and harrowing series of events forces him to go to the planet for real, or does he?', N'https://i.guim.co.uk/img/media/da90218f6b1b91d94f384ef8b6598a978fd346d7/0_3_2735_1641/master/2735.jpg?width=465&quality=45&auto=format&fit=max&dpr=2&s=9ecb1d05c56b385ff3703b168eec62a1', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (118, N'Cliffhanger', N'1993', 69, 241, 15, N'A botched mid-air heist results in suitcases full of cash being searched for by various groups throughout the Rocky Mountains.', N'https://static.slobodnadalmacija.hr/Archive/Images/2019/06/14/Cliffhanger6.jpg', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (119, N'Clear and Present Danger', N'1994', 73, 241, 2, N'CIA Analyst Jack Ryan is drawn into an illegal war fought by the US government against a Colombian drug cartel.', N'https://cdn.onebauer.media/one/empire-tmdb/films/9331/images/hM4SlL49CPvltPkVVulyXHlfFjO.jpg?format=jpg&quality=80&width=960&height=540&ratio=16-9&resize=aspectfill', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (120, N'GoldenEye', N'1995', 54, 240, 11, N'James Bond teams up with the lone survivor of a destroyed Russian research center to stop the hijacking of a nuclear space weapon by a fellow agent believed to be dead.', N'https://assets.mi6-hq.com/images/features/goldeneye4.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (121, N'The Black Dahlia', N'2006', 59, 241, 1, N'Two policemen see their personal and professional lives fall apart in the wake of the "Black Dahlia" murder investigation.', N'https://a.ltrbxd.com/resized/sm/upload/c4/sp/xg/x7/black-dahlia-90-1200-1200-675-675-crop-000000.jpg?k=865c3fb0fe', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (122, N'The Truman Show', N'1998', 36, 241, 2, N'An insurance salesman/adjuster discovers his entire life is actually a TV show.', N'https://images.hive.blog/0x0/https://files.peakd.com/file/peakd-hive/fixie/23xp6G2AWsazeNrNg1TaTR7A92RuiKznjJkTPtxGmN7RYsUBB1dzXGfNP8RoDQWXNwHq6.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (123, N'Event Horizon', N'1997', 74, 241, 2, N'A rescue crew investigates a spaceship that disappeared into a black hole and has now returned...with someone or something new on-board.', N'https://miro.medium.com/max/1400/0*iCShnhzzx9NW1tbP', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (124, N'The Bourne Identity', N'2002', 52, 241, 1, N'A man is picked up by a fishing boat, bullet-riddled and without memory, then races to elude assassins and recover from amnesia.', N'https://strikingfilmreviews.files.wordpress.com/2016/08/bourne-identity.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (125, N'Hellboy', N'2004', 71, 241, 19, N'A demon, raised from infancy after being conjured by and rescued from the Nazis, grows up to become a defender against the forces of darkness.', N'https://m.media-amazon.com/images/M/MV5BNTkxNzkzMDY0OF5BMl5BanBnXkFtZTgwOTc4ODUyMDI@._V1_.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (126, N'Starsky & Hutch', N'2004', 75, 241, 6, N'Two streetwise cops (Stiller and Wilson) bust criminals in their red-and-white Ford Torino with the help of police snitch called Huggy Bear (Snoop Dogg).', N'https://www.justwatch.com/images/backdrop/177731144/s640/starsky-y-hutch', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (127, N'Intolerable Cruelty', N'2003', 5, 241, 20, N'A revenge-seeking gold digger marries a womanizing Beverly Hills lawyer with the intention of making a killing in the divorce.', N'https://m.media-amazon.com/images/M/MV5BMTkwNjQ3ODI5N15BMl5BanBnXkFtZTcwMzQ2NjgyMw@@._V1_.jpg', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (128, N'300', N'2007', 76, 241, 6, N'King Leonidas and a force of 300 men fight the Persians at Thermopylae in 480 B.C.', N'https://thecriticalcritics.com/review/wp-content/images/300-still_1-1160x580.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (129, N'Star Trek: Nemesis', N'2003', 77, 241, 2, N'After the Enterprise is diverted to the Romulan planet of Romulus, supposedly because they want to negotiate a truce, the Federation soon find out the Romulans are planning an attack on Earth.', N'https://3.bp.blogspot.com/-wS5osuW3iUc/V5upkYMImfI/AAAAAAAAOEU/MmNpPRxd9MMU_Nyfh9GKImBqHaxVDov5QCLcB/s1600/star%2Btrek%2Bnemesis.jpg', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (130, N'Superman', N'1978', 30, 241, 6, N'An alien orphan is sent from his dying planet to Earth, where he grows up to become his adoptive home''s first and greatest super-hero.', N'https://galacticwatercooler.com/wp-content/uploads/2013/02/GWC-Podcast-360.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (131, N'Crimson Tide', N'1995', 78, 241, 17, N'On a US nuclear missile sub, a young first officer stages a mutiny to prevent his trigger happy captain from launching his missiles before confirming his orders to do so.', N'https://m.media-amazon.com/images/M/MV5BMjQ1NjYwMzMtZGQ3NC00OWIyLWFjNjMtZTU1YWEzODg5ZTRiXkEyXkFqcGdeQXVyNzU1NzE3NTg@._V1_QL75_UX500_CR0,47,500,281_.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (132, N'Deja Vu', N'2006', 78, 241, 7, N'An ATF agent travels back in time to save a woman from being murdered, falling in love with her during the process.', N'https://assets.mubicdn.net/images/film/31248/image-w1280.jpg?1445946987', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (133, N'Man On Fire', N'2004', 78, 241, 4, N'In Mexico City, a former assassin swears vengeance on those who committed an unspeakable act against the family he was hired to protect.', N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUMXFZJ3h8UYqh5Knp4cx_JCIp7Sow7hE2k9COc3rYu5QfkzL2muBMebOIIfRZywcGvXw&usqp=CAU', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (134, N'Enemy of the State', N'1998', 78, 241, 7, N'A lawyer becomes a target by a corrupt politician and his NSA goons when he accidentally receives key evidence to a serious politically motivated crime.', N'https://hansolofilmblog.files.wordpress.com/2019/10/img_9036.jpg?w=640', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (135, N'Kill Bill: Vol. 1', N'2003', 79, 241, 16, N'The Bride wakes up after a long coma. The baby that she carried before entering the coma is gone. The only thing on her mind is to have revenge on the assassination team that betrayed her - a team she was once part of.', N'https://cbs6albany.com/resources/media2/16x9/full/1015/center/80/dadeddfd-64b5-4d71-9325-f6d95c1c8fa4-large16x9_killbillvol1miramax.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (136, N'Alien 3', N'1992', 70, 241, 4, N'Ripley continues to be stalked by a savage alien, after her escape pod crashes on a prison planet.', N'https://gravereviews.com/wp-content/uploads/2020/03/alien-3.jpg', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (137, N'Shanghai Noon', N'2000', 80, 241, 7, N'Jackie Chan plays a Chinese man who travels to the Wild West to rescue a kidnapped princess. After teaming up with a train robber, the unlikely duo takes on a Chinese traitor and his corrupt boss.', N'https://image.tmdb.org/t/p/w1280/oYSjIbCRfm7W1c5RJ3O63R0HqsN.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (138, N'Kill Bill: Vol. 2', N'2004', 79, 241, 16, N'The murderous Bride continues her vengeance quest against her ex-boss, Bill, and his two remaining associates; his younger brother Budd, and Bill''s latest flame Elle.', N'https://ichef.bbci.co.uk/images/ic/640x360/p01h43kv.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (139, N'Blade II', N'2002', 71, 241, 14, N'Blade forms an uneasy alliance with the vampire council in order to combat the Reaper vampires who feed on vampires.', N'https://m.media-amazon.com/images/M/MV5BNDIyNDMxNDQzMF5BMl5BanBnXkFtZTcwMTQxNzI0NA@@._V1_.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (140, N'Flags of our Fathers', N'2006', 10, 241, 8, N'The life stories of the six men who raised the flag at The Battle of Iwo Jima, a turning point in WWII.', N'https://m.media-amazon.com/images/M/MV5BNzUxMjQ5NjQwNF5BMl5BanBnXkFtZTcwMzIxMzgxNA@@._V1_.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (141, N'Casino', N'1996', 9, 241, 1, N'Greed, deception, money, power, and murder occur between two mobster best friends and a trophy wife over a gambling empire.', N'https://images-na.ssl-images-amazon.com/images/S/pv-target-images/f4fa0358262974313c60979d0fcba9492d59b9bca2666e7f7212fa48cbe9df5f._UY500_UX667_RI_V_TTW_.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (142, N'Robin Hood: Prince of Thieves', N'1991', 17, 241, 6, N'When Robin and his Moorish companion come to England and the tyranny of the Sheriff of Nottingham, he decides to fight back as an outlaw.', N'http://1.bp.blogspot.com/_qeg1OcClj7U/S-fN7qKxHQI/AAAAAAAADaA/cdOYIiBz-MM/s1600/rhpot1.JPG', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (143, N'Shrek', N'2001', 67, 241, 8, N'An ogre, in order to regain his swamp, travels along with an annoying donkey in order to bring a princess to a scheming lord, wishing himself King.', N'https://c.flikshost.com/60020686/backdrops/large/wBG4kHfhwm3bLwKUFNRByXXv4r2.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (144, N'Shanghai Knights', N'2003', 81, 241, 7, N'When a Chinese rebel murders Chon''s estranged father and escapes to England, Chon and Roy make their way to London with revenge on their minds.', N'https://m.media-amazon.com/images/M/MV5BMjExMzkwMDgwOV5BMl5BanBnXkFtZTYwNzE2NDQ3._V1_.jpg', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (145, N'Indiana Jones and the Last Crusade', N'1989', 4, 241, 13, N'When Dr. Henry Jones Sr. suddenly goes missing while pursuing the Holy Grail, eminent archaeologist Indiana Jones must follow in his father''s footsteps and stop the Nazis.', N'https://as01.epimg.net/meristation/imagenes/2021/01/15/reportajes/1610700389_980489_1610701907_noticia_normal.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (146, N'Star Trek: First Contact', N'1996', 68, 241, 2, N'Capt. Picard and his crew pursue the Borg back in time to stop them from preventing Earth from initiating first contact with alien life.', N'https://www.hollywoodreporter.com/wp-content/uploads/2016/11/star_trek-_first_contact_still_0.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (147, N'Blade', N'1998', 82, 241, 14, N'A half-vampire, half-mortal man becomes a protector of the mortal race, while slaying evil vampires.', N'https://bamsmackpow.com/files/2019/08/blade_hero_image.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (148, N'Patriot Games', N'1992', 73, 241, 2, N'When CIA Analyst Jack Ryan interferes with an IRA assassination, a renegade faction targets him and his family for revenge.', N'https://www.avforums.com/styles/avf/editorial/block//4ae8bd15b76dc893548f48ce146cc566_3x3.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (149, N'The Fugitive', N'1993', 83, 241, 6, N'Dr. Richard Kimble, unjustly accused of killing his wife, must find the real one-armed killer while avoiding Marshal Sam Gerard.', N'https://www.hollywoodreporter.com/wp-content/uploads/2019/03/the_fugitive_-_h_-_1993.jpg?w=681&h=383&crop=1', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (150, N'The Prestige', N'2006', 27, 241, 7, N'Robert and Alfred are rival magicians. When Alfred performs the ultimate magic trick, Robert tries desperately to find out the secret to the trick.', N'https://randomcrit.com/wp-content/uploads/2017/08/The-Prestige-backdrop-1200x800.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (151, N'The Last of the Mohicans', N'1992', 34, 241, 21, N'Three trappers protect a British Colonel''s daughters in the midst of the French and Indian War.', N'https://www.intofilm.org/intofilm-production/scaledcropped/1096x548https%3A/s3-eu-west-1.amazonaws.com/images.cdn.filmclub.org/film__3907-the-last-of-the-mohicans--hi_res-13d423d2.jpg/film__3907-the-last-of-the-mohicans--hi_res-13d423d2.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (153, N'Wedding Crashers', N'2005', 81, 241, 14, N'John Beckwith and Jeremy Grey, a pair of committed womanizers who sneak into weddings to take advantage of the romantic tinge in the air, find themselves at odds with one another when John meets and falls for Claire Cleary.', N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT-IKAK5yJQQN7OssVQrtzQxWFLIlfNn6DfFF0I6nXNykLiwFvv4H2WknIpdWgbFG__NHE&usqp=CAU', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (154, N'Back to the Future Part III', N'1990', 20, 241, 1, N'Doctor Emmet Brown was living in peace in 1885 until he was killed by Buford "Mad Dog" Tannen. Marty McFly travels back in time to save his friend.', N'https://a.ltrbxd.com/resized/sm/upload/86/ao/b6/db/bttf3-1200-1200-675-675-crop-000000.jpg?k=26ef1f7063', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (155, N'Back to the Future Part II', N'1989', 20, 241, 1, N'After visiting 2015, Marty must repeat his visit to 1955 to prevent disastrous changes to 1985... without interfering with his first trip.', N'https://i.pinimg.com/originals/b2/b8/65/b2b865130c8ed14b6b2290386ddd16fb.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (156, N'Licence to Kill', N'1989', 84, 240, 22, N'James Bond leaves Her Majesty''s Secret Service to stop an evil drug lord and avenge his best friend, Felix Leiter.', N'https://multitudeofmovies.files.wordpress.com/2015/12/featured4.jpg?w=560', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (157, N'The Living Daylights', N'1987', 84, 240, 22, N'James Bond is living on the edge to stop an evil arms dealer from starting another world war. Bond crosses all seven continents in order to stop the evil Whitaker and General Koskov.', N'https://mutantreviewers.files.wordpress.com/2014/01/the-living-daylights.jpg?w=723&h=469', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (158, N'Sin City', N'2005', 85, 241, 23, N'A film that explores the dark and miserable town Basin City and tells the story of three different people, all caught up in the violent corruption of the city.', N'https://cdn.onebauer.media/one/empire-tmdb/films/187/images/my81Hjt7NpZhaMX9bHi4wVhFy0v.jpg?format=jpg&quality=80&width=960&height=540&ratio=16-9&resize=aspectfill', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (159, N'Serenity', N'2005', 86, 241, 1, N'In the future, when a passenger with a deadly secret. Six rebels on the run. An assassin in pursuit.', N'https://m.media-amazon.com/images/M/MV5BMTc4OTI5MTA4M15BMl5BanBnXkFtZTgwOTgzMDYyODE@._V1_.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (160, N'Star Trek: Generations', N'1994', 87, 241, 2, N'Capt. Picard, with the help of supposedly dead Capt. Kirk, must stop a madman willing to murder on a planetary scale in order to enter a space matrix.', N'https://so-s.nflximg.net/soa5/284/1669283284.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (161, N'Never Say Never Again', N'1983', 88, 241, 6, N'A SPECTRE agent has stolen two American nuclear warheads, and James Bond must find their targets before they are detonated.', N'https://a.ltrbxd.com/resized/sm/upload/we/36/4k/79/never-say-never-again-1200-1200-675-675-crop-000000.jpg?k=3411aa5448', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (162, N'Star Trek: The Motion Picture', N'1979', 89, 241, 2, N'When a destructive space entity is spotted approaching Earth, Admiral Kirk resumes command of the Starship Enterprise in order to intercept, examine, and hopefully stop it.', N'https://miro.medium.com/max/1200/1*LNVESMY7BGtJqEtz3Mxi-w.jpeg', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (163, N'Rush Hour', N'1998', 57, 241, 14, N'Two cops team up to get back a kidnapped daughter.', N'https://prd-rteditorial.s3.us-west-2.amazonaws.com/wp-content/uploads/2018/09/18132548/Rush-Hour-Retrospective-Rep.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (164, N'Lethal Weapon 3', N'1992', 30, 241, 6, N'Martin Riggs finally meets his match in the form of Lorna Cole, a beautiful but tough policewoman.', N'https://www4.pictures.zimbio.com/mp/Yq3zOHrha-dl.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (165, N'Star Wars: Episode IV - Return of the Jedi', N'1983', 90, 241, 13, N'After rescuing Han Solo from the palace of Jabba the Hutt, the Rebels attempt to destroy the Second Death Star, while Luke Skywalker tries to bring his father back to the Light Side of the Force.', N'https://cbs6albany.com/resources/media/2b280bf0-adb7-47e9-9013-7b41ed768bb3-large16x9_starwars.jpg?1576630475229', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (166, N'A History of Violence', N'2005', 91, 241, 14, N'A mild-mannered man becomes a local hero through an act of violence, which sets off repercussions that will shake his family to its very core.', N'https://s3.amazonaws.com/static.rogerebert.com/uploads/review/primary_image/reviews/a-history-of-violence-2005/EB20050922REVIEWS50919002AR.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (167, N'Moonraker', N'1979', 92, 240, 22, N'James Bond investigates the mid-air theft of a space shuttle and discovers a plot to commit global genocide.', N'https://m.media-amazon.com/images/M/MV5BNzk2NDYzNjE3Ml5BMl5BanBnXkFtZTgwNjgxMzMyMzI@._V1_.jpg', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (168, N'Get Shorty', N'1996', 31, 241, 11, N'A mobster travels to Hollywood to collect a debt and discovers that the movie business is much the same as his current job.', N'https://m.media-amazon.com/images/M/MV5BY2Q0ZTA5Y2UtMjUxYi00OTc3LThmNmItZGE4NDk0M2U4YzM5XkEyXkFqcGdeQTNwaW5nZXN0._V1_.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (170, N'Million Dollar Baby', N'2005', 10, 241, 6, N'A hardened trainer/manager works with a determined woman in her attempt to establish herself as a boxer.', N'https://parentpreviews.com/images/made/legacy-pics/million-dollar-baby-2_960_457_80.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (171, N'Se7en', N'1996', 70, 241, 14, N'Police drama about two cops, one new and one about to retire, after a serial killer using the seven deadly sins as his MO.', N'https://asset.kompas.com/crops/-zAZzvZ3A8-EEilsTW3S7d1Ifsk=/0x0:1471x981/750x500/data/photo/2020/08/27/5f46f7952d20c.jpg', N'4.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (172, N'The Hunt For Red October', N'1990', 58, 241, 2, N'In 1984, the USSR''s best submarine captain in their newest sub violates orders and heads for the USA. Is he trying to defect, or to start a war?', N'https://m.media-amazon.com/images/M/MV5BMjAxOTUyMjI5OV5BMl5BanBnXkFtZTgwOTAwOTIwMjE@._V1_.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (173, N'GhostBusters', N'1984', 94, 241, 5, N'Three unemployed parapsychology professors set up shop as a unique ghost removal service.', N'https://townsquare.media/site/442/files/2018/11/ghostbusters-1.jpg?w=980&q=75', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (174, N'Star Trek V: The Final Frontier', N'1989', 95, 241, 2, N'Capt. Kirk and his crew must deal with Mr. Spock''s half brother who hijacks the Enterprise for an obsessive search for God.', N'https://miro.medium.com/max/2400/1*9n7gq0zQY5HRsxY0ZhAlig.jpeg', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (175, N'Indiana Jones and the Temple of Doom', N'1984', 4, 241, 13, N'After arriving in India, Indiana Jones is asked by a desperate village to find a mystical stone. He agrees, and stumbles upon a secret cult plotting a terrible plan in the catacombs of an ancient palace.', N'https://s.yimg.com/ny/api/res/1.2/lec44I13Bg1PrnItQwdTxA--/YXBwaWQ9aGlnaGxhbmRlcjt3PTY0MDtoPTQyMg--/https://s.yimg.com/os/creatr-uploaded-images/2021-10/acf12320-31c7-11ec-97f3-a49f62336032', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (176, N'Blade Runner', N'1982', 51, 241, 6, N'Deckard, a blade runner, has to track down and terminate 4 replicants who hijacked a ship in space and have returned to earth seeking their maker.', N'https://m.media-amazon.com/images/M/MV5BMTUzNTU3Nzc3NF5BMl5BanBnXkFtZTgwNjQ3OTI1NTM@._V1_.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (177, N'Die Hard', N'1989', 58, 241, 4, N'New York cop John McClane gives terrorists a dose of their own medicine as they hold hostages in an LA office building.', N'https://static2.srcdn.com/wordpress/wp-content/uploads/2019/11/4-john-mcclane-die-hard.jpg?q=50&fit=crop&w=960&h=500&dpr=1.5', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (178, N'For Your Eyes Only', N'1981', 84, 240, 22, N'Agent 007 is assigned to hunt for a lost British encryption device and prevent it from falling into enemy hands.', N'https://a.ltrbxd.com/resized/sm/upload/x8/ea/0r/uo/for-your-eyes-only-1200-1200-675-675-crop-000000.jpg?k=2f431dfc3d', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (179, N'Octopussy', N'1983', 84, 241, 11, N'A fake Fabergé egg and a fellow agent''s death leads James Bond to uncovering an international jewel smuggling operation, headed by the mysterious Octopussy, being used to disguise a nuclear attack on NATO forces.', N'https://i.ytimg.com/vi/SLXfVAQ7K4E/maxresdefault.jpg', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (180, N'Star Trek VI: The Undiscovered Country', N'1992', 96, 241, 2, N'The crews of the Enterprise and the Excelsior must stop a plot to prevent a peace treaty between the Klingon Empire and the Federation.', N'https://e.snmc.io/i/600/s/49c428bbe0147dd7b92bc8ab98b6c791/5742225/cliff-eidelman-star-trek-vi-the-undiscovered-country-Cover-Art.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (181, N'The Running Man', N'1988', 97, 241, 24, N'A wrongly-convicted man must try to survive a public execution gauntlet staged as a TV game show.', N'https://static.metacritic.com/images/products/movies/2/489eafeb384f84458bb344a38bf917d5.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (182, N'Open Range', N'2004', 98, 241, 7, N'A former gunslinger is forced to take up arms again when he and his cattle crew are threatened by a corrupt lawman.', N'https://3.bp.blogspot.com/-l6j_wK0u9WI/U141xD8mB4I/AAAAAAAA2zI/TWtVusE31YU/s1600/Open+range+cinemelodic.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (183, N'Kindergarten Cop', N'1991', 94, 241, 1, N'A tough cop is given his most difficult assignment: masquerade as a a kindergarten teacher in order to find a drug dealer.', N'https://images2.minutemediacdn.com/image/upload/c_fill,g_auto,h_1248,w_2220/f_auto,q_auto,w_1100/v1555355950/shape/mentalfloss/kindergarten_primary.jpg', N'2.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (184, N'O Brother, Where Art Thou?', N'2000', 5, 241, 7, N'Homer''s epic poem "The Odyssey", set in the deep south during the 1930''s. In it, three escaped convicts search for hidden treasure while a relentless lawman pursues them.', N'https://media.pitchfork.com/photos/5f973e571cc2de8c7d61a997/2:1/w_1000/o%20brother%20where%20art%20thou%20ost.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (185, N'Goodfellas', N'1990', 9, 241, 6, N'Henry Hill and his friends work their way up through the mob hierarchy.', N'https://m.media-amazon.com/images/M/MV5BYjllYzEzZDUtMmUxMi00MjEwLWFiYTQtNTg5OWY1MTlhYjI0XkEyXkFqcGdeQW1pYnJ5YW50._V1_.jpg', N'4.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (187, N'The Untouchables', N'1987', 59, 241, 2, N'Federal Agent Elliot Ness sets out to take out Al Capone; because of rampant corruption, he assembles a small, hand-picked team.', N'https://2.bp.blogspot.com/-o7TLiza13hk/W6tcBOI5-6I/AAAAAAAAFsU/HwZzM7vMBUUg9o7YABstARe3zohTysPIgCEwYBhgL/s1600/The%2BUntouchables%2Bheader.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (188, N'Schindler''s List', N'1994', 4, 241, 1, N'Oskar Schindler uses Jews to start a factory in Poland during the war. He witnesses the horrors endured by the Jews, and starts to save them.', N'https://m.media-amazon.com/images/M/MV5BMTc4NTA1OTE4Nl5BMl5BanBnXkFtZTcwODA2MDAxMw@@._V1_.jpg', N'4.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (189, N'Anchorman: The Legend of Ron Burgundy', N'2004', 63, 241, 8, N'Ron Burgundy is San Diego''s top rated newsman in the male dominated broadcasting of the 1970''s, but that''s all about to change when a new female employee with ambition to burn arrives in his office.', N'https://images.mubicdn.net/images/film/3360/cache-90772-1445946489/image-w1280.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (190, N'Scarface', N'1983', 59, 241, 1, N'In 1980 Miami, a determined Cuban immigrant takes over a drug empire while succumbing to greed.', N'https://m.media-amazon.com/images/M/MV5BZjE1ZmMzOTMtZjNkYy00MDE4LTk1MmItYjVkODAxY2M2ZDc3XkEyXkFqcGdeQXVyNzU1NzE3NTg@._V1_QL75_UX500_CR0,47,500,281_.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (191, N'Star Trek IV: The Voyage Home', N'1987', 99, 241, 2, N'To save Earth from an alien probe, Kirk and his crew go back in time to retrieve the only beings who can communicate with it, humpback whales.', N'https://m.media-amazon.com/images/M/MV5BNzA4MzU3OGUtZDE5ZC00YzZhLTllMzctZjUyOTg5NDExODA0XkEyXkFqcGdeQWFsZWxvZw@@._V1_.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (192, N'King Kong', N'1976', 100, 241, 2, N'A petroleum exploration expedition comes to an isolated island and encounters a colossal giant gorilla.', N'https://image.tmdb.org/t/p/original/ikPeXD1KqGgBn06ckqxdrjOikUU.jpg', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (193, N'Star Wars: Episode V - The Empire Strikes Back', N'1980', 88, 241, 13, N'While Luke takes advanced Jedi training from Yoda, his friends are relentlessly pursued by Darth Vader as part of his plan to capture Luke.', N'https://www.denverpost.com/wp-content/uploads/2016/04/20151215__empire-strikes-backp1.jpg?w=654', N'4.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (194, N'Gandhi', N'1982', 101, 240, 26, N'Biography of Mahatma Gandhi, the lawyer who became the famed leader of the Indian revolts against the British through his philosophy of non-violent protest.', N'https://1.bp.blogspot.com/-0kKF9j2daxA/X0x2IyIpgHI/AAAAAAAAK3c/sxbozbZBkrkueJA4LZ40Aw2_w_OtcLy2wCLcBGAsYHQ/w1200-h630-p-k-no-nu/Gandhi%2B47.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (195, N'Equilibrium', N'2003', 102, 241, 23, N'In a Fascist future where all forms of feeling are illegal, a man in charge of enforcing the law rises to overthrow the system.', N'https://image.tmdb.org/t/p/w1280/h5KoG0JAK43cg4jucwfJiEw9e5W.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (196, N'From Dusk Till Dawn', N'1996', 103, 241, 23, N'Two criminals and their hostages unknowingly seek temporary refuge in an establishment populated by vampires, with chaotic results.', N'https://www.framerated.co.uk/frwpcontent/uploads/2021/01/fromduskdawn01.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (197, N'Raiders of the Lost Ark', N'1981', 4, 241, 13, N'Archeologist and adventurer Indiana Jones is hired by the US government to find the Ark of the Covenant, before the Nazis.', N'https://www.hollywoodreporter.com/wp-content/uploads/2017/06/raiders_of_the_lost_ark_-_h_-_1981.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (199, N'Back to the Future', N'1985', 20, 241, 1, N'In 1985, Doc Brown invented time travel, in 1955, Marty McFly accidentally prevented his parents from meeting, putting his own existence at stake.', N'https://cdn.newsday.com/polopoly_fs/1.46080273.1603302504!/httpImage/image.jpg_gen/derivatives/landscape_640/image.jpg', N'5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (200, N'Dances With Wolves', N'1991', 98, 241, 27, N'Lt. John Dunbar, exiled to a remote western Civil War outpost, befriends wolves and Indians, making him an intolerable aberration in the military.', N'https://militarygogglebox.files.wordpress.com/2020/06/dances-with-wolves-adventurem-drama-western-us-army-4.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (201, N'Star Trek III: The Search For Spock', N'1984', 99, 241, 2, N'Admiral Kirk and his bridge crew risk their careers stealing the decommissioned Enterprise to return to the restricted Genesis planet to recover Spock''s body.', N'https://m.media-amazon.com/images/M/MV5BODkwNDMyMDc0Ml5BMl5BanBnXkFtZTgwOTA4NDExMjI@._V1_.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (203, N'Raging Bull', N'1981', 9, 241, 22, N'An emotionally self-destructive boxer''s journey through life, as the violence and temper that leads him to the top in the ring, destroys his life outside it.', N'https://m.media-amazon.com/images/M/MV5BMDY4ODAyNjgtMWY1OC00NzgwLWJjYmItYmY4NzVkYzE0MDA0XkEyXkFqcGdeQXVyNzU1NzE3NTg@._V1_QL75_UX500_CR0,47,500,281_.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (204, N'Aliens', N'1986', 15, 241, 4, N'The planet from Alien (1979) has been colonized, but contact is lost. This time, the rescue team has impressive firepower, enough?', N'https://upl.roob.la/2012/05/Aliens-1986.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (205, N'Hero', N'2004', 105, 48, 29, N'A series of Rashomon-like flashback accounts shape the story of how one man defeated three assassins who sought to murder the most powerful warlord in pre-unified China.', N'https://media.timeout.com/images/27785/630/472/image.jpg', N'4')
GO
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (206, N'Hot Fuzz', N'2007', 106, 240, 30, N'Jealous colleagues conspire to get a top London cop transferred to a small town and paired with a witless new partner. On the beat, the pair stumble upon a series of suspicious accidents and events.', N'https://www.thefilmagazine.com/wp-content/uploads/2020/05/Hot-Fuzz-Review-Banner.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (207, N'Leon', N'1995', 56, 79, 18, N'Professional assassin Leon reluctantly takes care of 12-year-old Mathilda, a neighbor whose parents are killed, and teaches her his trade.', N'https://images.immediate.co.uk/remote/m.media-amazon.com/images/S/pv-target-images/cafbb546613d47516fc79f63d904a685b94e6e8a2a2031134966ecc123129564.jpg?quality=90&resize=556,313', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (208, N'High Plains Drifter', N'1973', 10, 241, 31, N'A gunfighting stranger comes to the small settlement of Lago and is hired to bring the townsfolk together in an attempt to hold off three outlaws who are on their way.', N'https://supermarcey.files.wordpress.com/2015/08/high-plains-drifter-2.jpg?w=1200', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (209, N'Collateral', N'2004', 34, 241, 2, N'A cab driver finds himself the hostage of an engaging contract killer as he makes his rounds from hit to hit during one night in LA. He must find a way to save both himself and one last victim.', N'https://filasiete.com/wp-content/uploads/2004/10/collateral3.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (210, N'American Beauty', N'2000', 61, 241, 8, N'Lester Burnham, a depressed suburban father in a mid-life crisis, decides to turn his hectic life around after developing an infatuation for his daughter''s attractive friend.', N'http://emanuellevy.com/wp-content/uploads/2013/11/american_beauty_6.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (211, N'Lethal Weapon', N'1987', 30, 241, 6, N'A veteran cop, Murtough, is partnered with a young homicidal cop, Riggs. Both having one thing in common, hating working in pairs. Now they must learn to work with one and other to stop a gang of drug smugglers.', N'https://cdn.onebauer.media/one/empire-tmdb/films/941/images/wi2stpCDJam3dBYdsRTnKmBysXF.jpg?format=jpg&quality=80&width=850&ratio=16-9&resize=aspectfill', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (212, N'Lethal Weapon 2', N'1989', 30, 241, 6, N'Riggs and Murtaugh are on the trail of South African diplomats who are using their immunity to engage in criminal activities.', N'https://m1.paperblog.com/i/418/4184413/movie-review-arma-letal-2-L-u3JHS8.jpeg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (213, N'Crouching Tiger, Hidden Dragon', N'2001', 8, 48, 5, N'Two warriors in pursuit of a stolen sword and a notorious fugitive are led to an impetuous, physically-skilled, teenage nobleman''s daughter, who is at a crossroads in her life.', N'https://geekculture.co/wp-content/uploads/2016/03/crouching-tiger-hidden-dragon-sword-of-destiny.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (214, N'Brokeback Mountain', N'2006', 8, 241, 2, N'Based on the ''E. Annie Proulx'' story about a forbidden and secretive relationship between two cowboys and their lives over the years.', N'https://www.slantmagazine.com/wp-content/uploads/2018/09/brokebackmountain.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (215, N'Hulk', N'2003', 8, 241, 1, N'A geneticist''s experimental accident curses him with the tendency to become a powerful giant green brute under emotional stress.', N'https://m.media-amazon.com/images/M/MV5BMTY3NjE0ODcxMl5BMl5BanBnXkFtZTcwMTg0MTIyMw@@._V1_.jpg', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (216, N'Sense and Sensibility', N'1996', 8, 240, 5, N'Rich Mr. Dashwood dies, leaving his second wife and her daughters poor by the rules of inheritance. Two daughters are the titular opposites.', N'https://a.ltrbxd.com/resized/sm/upload/7u/vd/40/n9/sense-and-sensibility-1995-1200-1200-675-675-crop-000000.jpg?k=f8a8d58192', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (218, N'Twins', N'1989', 94, 241, 1, N'A physically perfect, but innocent, man goes in search of his twin brother, who is a short small-time crook.', N'https://hansolofilmblog.files.wordpress.com/2020/07/mv5bnjflndy5ymytmje4ms00nmm1ltgymtutmji5mzhmy2nmnjrlxkeyxkfqcgdeqxvymjuyndk2odc40._v1_.jpg?w=800', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (219, N'28 Days Later…', N'2002', 108, 240, 32, N'Four weeks after a mysterious, incurable virus spreads throughout the UK, a handful of survivors try to find sanctuary.', N'http://basementrejects.com/wp-content/uploads/2012/04/28-days-later-2002-jim-cillian-murphy-london-parliament-review.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (220, N'The Beach', N'2000', 108, 240, 4, N'Twenty-something Richard travels to Thailand and finds himself in possession of a strange map. Rumours state that it leads to a solitary beach paradise, a tropical bliss - excited and intrigued, he sets out to find it.', N'https://www.sbs.com.au/movies/sites/sbs.com.au.film/files/beach-backdrop.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (221, N'Trainspotting', N'1996', 108, 240, 33, N'Renton, deeply immersed in the Edinburgh drug scene, tries to clean up and get out, despite the allure of the drugs and influence of friends.', N'https://m.media-amazon.com/images/M/MV5BNTI4NTMzYjctZDE0Ni00NTcwLWE5NzQtMjgxZDZkNTQ4YWE4XkEyXkFqcGdeQW1pYnJ5YW50._V1_.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (222, N'The Spy Who Loved Me', N'1977', 92, 240, 22, N'James Bond investigates the hijacking of British and Russian submarines carrying nuclear warheads with the help of a KGB agent whose lover he killed.', N'https://d2j1wkp1bavyfs.cloudfront.net/wp-content/legacy/posts/f097d346-3c7e-4d5d-a744-b7fe1b8d9918.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (223, N'Downfall', N'2005', 109, 257, 34, N'Traudl Junge (Lara), the final secretary for Adolf Hitler (Ganz), tells of the Nazi dictator''s final days in his Berlin bunker at the end of WWII.', N'https://m.media-amazon.com/images/M/MV5BMTgwMTU2ODgzOV5BMl5BanBnXkFtZTcwMDAwMzc4NA@@._V1_.jpg', N'4.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (225, N'Star Trek II: The Wrath of Khan', N'1982', 96, 241, 2, N'Admiral Kirk''s midlife crisis is interrupted by the return of an old enemy looking for revenge and a potentially destructive device.', N'https://m.media-amazon.com/images/M/MV5BMTU5MTY1ODcyMF5BMl5BanBnXkFtZTgwOTI5NDExMjI@._V1_.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (226, N'House of Flying Daggers', N'2005', 105, 48, 29, N'A romantic warrior breaks a beautiful member of a rebel army out of prison to help her rejoin her fellows, but things are not what they seem.', N'https://m.media-amazon.com/images/M/MV5BNjY4NjU0Mzc0M15BMl5BanBnXkFtZTYwODI5NDc2._V1_.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (227, N'Das Boot', N'1982', 25, 257, NULL, N'The claustrophobic world of a WWII German U-boat; boredom, filth, and sheer terror.', N'https://m.media-amazon.com/images/M/MV5BYzBiOWYyYmItNGYzNC00MDljLWExZDYtZDAzM2U3YTZmZDE2XkEyXkFqcGdeQXVyNzU1NzE3NTg@._V1_QL75_UX500_CR0,47,500,281_.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (228, N'Casino Royale', N'1967', 110, 240, 5, N'In an early spy spoof, aging Sir James Bond (David Niven) comes out of retirement to take on SMERSH.', N'https://m.media-amazon.com/images/M/MV5BMTMzNDk0NjE4OV5BMl5BanBnXkFtZTcwNzU2NjAzNA@@._V1_.jpg', N'2.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (229, N'Star Wars: Episode IV - A New Hope', N'1977', 7, 241, 13, N'Luke Skywalker leaves his home planet, teams up with other rebels, and tries to save Princess Leia from the evil clutches of Darth Vader.', N'https://m.media-amazon.com/images/M/MV5BMTUzNDY0NjY4Nl5BMl5BanBnXkFtZTgwNjY4MTQ0NzE@._V1_.jpg', N'4.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (230, N'E.T.: The Extra-Terrestrial', N'1982', 4, 241, 1, N'A group of Earth children help a stranded alien botanist return home.', N'https://media.timeout.com/images/101619421/image.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (231, N'Amelie', N'2001', 111, 79, 16, N'Amelie, an innocent and naive girl in Paris, with her own sense of justice, decides to help those around her and along the way, discovers love.', N'https://m.media-amazon.com/images/M/MV5BMjI5MDc5NTU4OF5BMl5BanBnXkFtZTcwOTU0MzU5Ng@@._V1_.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (232, N'You Only Live Twice', N'1967', 92, 241, 22, N'Agent 007 and the Japanese secret service ninja force must find and stop the true culprit of a series of spacejackings before nuclear war is provoked.', N'https://static.metacritic.com/images/products/movies/3/6153e2334f779922be153a5d3c0a05da.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (233, N'Thunderball', N'1965', 112, 240, 22, N'James Bond heads to The Bahamas to recover two nuclear warheads stolen by SPECTRE agent Emilio Largo in an international extortion scheme.', N'https://www.bandassonoras.co/wp-content/uploads/2017/10/thunderball-1200-1200-675-675-crop-000000.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (234, N'Alien', N'1979', 51, 241, 4, N'A mining ship, investigating a suspected SOS, lands on a distant planet. The crew discovers some strange creatures and investigates.', N'https://m.media-amazon.com/images/M/MV5BZTc2NWU1NDMtNmVlYS00MTUyLTlkYjctZDcxNTgwMjRiYTNjXkEyXkFqcGdeQXVyMDc2NTEzMw@@._V1_.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (236, N'On Her Majesty''s Secret Service', N'1969', 113, 240, 22, N'James Bond woos a mob boss''s daughter and goes undercover to uncover the true reason for Blofeld''s allergy research in the Swiss Alps that involves beautiful women from around the world.', N'https://cinefilesreviews.files.wordpress.com/2015/10/on-her-majestys-secret-service-james-bond-george-lazenby-spy-thriller-1969-movie-review.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (237, N'Pulp Fiction', N'1994', 79, 241, 16, N'The lives of two mob hit men, a boxer, a gangster''s wife, and a pair of diner bandits intertwine in four tales of violence and redemption.', N'https://m.media-amazon.com/images/M/MV5BMTc5Njg5Njg2MV5BMl5BanBnXkFtZTgwMjAwMzg5MTE@._V1_.jpg', N'4.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (238, N'Rumble in the Bronx', N'1997', 114, 48, 14, N'A young man visiting and helping his uncle in New York City finds himself forced to fight a street gang and the mob with his martial art skills.', N'https://kungfukingdom.com/wp-content/uploads/2014/12/Rumble-in-the-Bronx.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (239, N'Diamonds are Forever', N'1971', 115, 240, 22, N'A diamond smuggling investigation leads James Bond to Las Vegas, where he uncovers an extortion plot headed by his nemesis, Ernst Stavro Blofeld.', N'https://i.ytimg.com/vi/LIfPFxZnFoQ/maxresdefault.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (240, N'Fargo', N'1996', 5, 241, 4, N'Jerry Lundegaard''s inept crime falls apart due to his and his henchmen''s bungling and the persistent police work of pregnant Marge Gunderson.', N'https://a.ltrbxd.com/resized/sm/upload/ww/kz/nd/19/fargo-1200-1200-675-675-crop-000000.jpg?k=e352ce3ba4', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (241, N'Live and Let Die', N'1973', 115, 240, 22, N'007 is sent to stop a diabolically brilliant heroin magnate armed with a complex organization and a reliable psychic tarot card reader.', N'https://a.ltrbxd.com/resized/sm/upload/z7/5n/o5/4c/live-let-die-1200-1200-675-675-crop-000000.jpg?k=aa658d5072', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (243, N'Good Night, and Good Luck', N'2006', 116, 241, 6, N'Broadcast journalist Edward R. Murrow looks to bring down Senator Joseph McCarthy.', N'https://m.media-amazon.com/images/M/MV5BMTczMzM5MTg0NV5BMl5BanBnXkFtZTYwMDEwOTY2._V1_.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (244, N'Pale Rider', N'1985', 10, 241, 31, N'A mysterious preacher protects a humble prospector village from a greedy mining company trying to encroach on their land.', N'https://www.moviehousememories.com/wp-content/uploads/2019/03/Pale-Rider-1985-featured-2.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (245, N'The Terminator', N'1984', 15, 241, 11, N'A human-looking, apparently unstoppable cyborg is sent from the future to kill Sarah Connor; Kyle Reese is sent to stop it.', N'https://pm1.narvii.com/6771/8999c015896e3e7ba8ab2cc978c5385600a52a15v2_hq.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (246, N'Around the World in 80 Days', N'1956', 117, 241, 22, N'Adaptation of Jules Verne''s novel about a Victorian Englishman who bets that with the new steamships and railways he can do what the title says.', N'https://www.movies4kids.co.uk/wp-content/uploads/2011/01/80main.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (249, N'The Usual Suspects', N'1995', 14, 241, 11, N'A boat has been destroyed, criminals are dead, and the key to this mystery lies with the only survivor and his twisted, convoluted story beginning with five career crooks in a seemingly random police lineup.', N'https://m.media-amazon.com/images/M/MV5BYmI2NTk3ODQtYWFiNC00NDgxLTkxY2UtYTNhNTI3YTNkNzdmXkEyXkFqcGdeQXVyNzU1NzE3NTg@._V1_QL75_UX500_CR0,47,500,281_.jpg', N'4.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (250, N'Memento', N'2000', 27, 241, 5, N'A man, suffering from short-term memory loss, uses notes and tattoos to hunt for the man he thinks killed his wife.', N'https://m.media-amazon.com/images/M/MV5BODEwZTBhMzUtMjYxNS00MTg1LTk5MWUtMDk3MGE1NmMwOTY4XkEyXkFqcGdeQWFybm8@._V1_.jpg', N'4.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (251, N'Shaun of the Dead', N'2004', 106, 240, 33, N'A man decides to turn his moribund life around by winning back his ex-girlfriend, reconciling his relationship with his mother, and dealing with an entire community that has returned from the dead to eat the living.', N'https://themarckoguy.files.wordpress.com/2014/04/shaun-of-the-dead-29041-1366x768.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (252, N'Four Weddings and a Funeral', N'1994', 26, 240, 33, N'Comedy-drama about a group of British friends... the title says the rest.', N'https://m.media-amazon.com/images/M/MV5BNzQwNTg3MzkxMl5BMl5BanBnXkFtZTcwNjcxNzczNA@@._V1_.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (253, N'Night Watch', N'2005', 119, 258, 4, N'A fantasy-thriller set in present-day Moscow where the respective forces that control daytime and nighttime do battle.', N'https://content.internetvideoarchive.com/content/hdphotos/777/000777/000777_684x385_771206_035.jpg', N'3')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (254, N'Goldfinger', N'1965', 115, 241, 22, N'Investigating a gold magnate''s gold smuggling, James Bond uncovers a plot to contaminate the Fort Knox gold reserve.', N'https://rantingravingandmovies.files.wordpress.com/2016/06/1964_goldfinger.jpeg?w=705&h=435&crop=1', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (255, N'The Lives of Others', N'2007', 120, 257, 36, N'In 1984 East Berlin, an agent of the secret police, conducting surveillance on a writer and his lover, finds himself becoming increasingly absorbed by their lives.', N'https://m.media-amazon.com/images/M/MV5BMTM4OTY1MzQwNV5BMl5BanBnXkFtZTYwNzkxMTg2._V1_.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (256, N'From Russia with Love', N'1964', 112, 240, 22, N'James Bond willingly falls into an assassination ploy involving a naive Russian beauty in order to retrieve a Soviet encryption device that was stolen by SPECTRE.', N'https://static.metacritic.com/images/products/movies/0/32a946a8fdc8e867b0f70372f36043e6.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (257, N'Reservoir Dogs', N'1993', 79, 241, 16, N'After a simple jewelery heist goes terribly wrong, the surviving criminals begin to suspect that one of them is a police informant.', N'https://darkroom.bbfc.co.uk/550/13c19bab545b8ee4aa93fa47797f66e5:1fe2f2a0d7468c92ef5e5dfb36ff16ac/reservoir-dogs-1992.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (258, N'Dr. No', N'1963', 112, 240, 22, N'James Bond''s investigation of a missing colleague in Jamaica leads him to the island of the mysterious Dr. No and a scheme to end the US space program.', N'https://m.media-amazon.com/images/M/MV5BMjIxZGZkMTItMjBiMS00NTQzLTk3YjUtZGU1MzNlNzcyMGRkXkEyXkFqcGdeQXVyNzU1NzE3NTg@._V1_.jpg', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (259, N'King Kong', N'1933', 121, 241, 37, N'A film crew goes to a tropical island for an exotic location shoot and discovers a colossal giant gorilla who takes a shine to their female blonde star.', N'https://m.media-amazon.com/images/M/MV5BMjI2MTI3NTU3OF5BMl5BanBnXkFtZTgwMzY0MzM1MjI@._V1_.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (261, N'Super Size Me', N'2004', 123, 241, 39, N'An irreverent look at obesity in America and one of its sources - fast food corporations.', N'https://cdn.onebauer.media/one/empire-tmdb/films/9372/images/6arEx60KIFN2v8NZTpIBfpX7oEN.jpg?format=jpg&quality=80&width=850&ratio=16-9&resize=aspectfill', N'3.5')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (262, N'Kagemusha', N'1980', 122, 118, 38, N'When a powerful warlord in medieval Japan dies, a poor thief recruited to impersonate him finds difficulty', N'https://www.framerated.co.uk/frwpcontent/uploads/2021/02/kagemusha01.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (263, N'Ran', N'1985', 122, 118, 38, N'An elderly lord abdicates to his three sons, and the two corrupt ones turn against him.', N'https://m.media-amazon.com/images/M/MV5BMmVjY2Q5YjctYzg4NS00N2JhLTk2ZmItZWQwZDhjODViNWU3XkEyXkFqcGdeQXVyNzU1NzE3NTg@._V1_QL75_UX500_CR0,47,500,281_.jpg', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (264, N'Sunshine', N'2007', 108, 240, 4, N'A team of astronauts are sent to re-ignite the dying sun 50 years into the future.', N'https://techcrunch.com/wp-content/uploads/2017/09/sunshine.jpg?w=1000', N'4')
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmImage], [FilmRating]) VALUES (265, N'Once Were Warriors', N'1995', 29, 167, 40, N'A family descended from Maori warriors is bedeviled by a violent father and the societal problems of being treated as outcasts.', N'https://m.media-amazon.com/images/M/MV5BMDJhZjY0ZTAtYmMzNi00ZDZjLWI5MWQtMDMwZDVjZTRkMzQ2XkEyXkFqcGdeQXVyMjUyNDk2ODc@._V1_.jpg', N'4')
SET IDENTITY_INSERT [dbo].[tblFilm] OFF
GO
INSERT [dbo].[tblGenre] ([GenreId], [GenreName]) VALUES (1, N'Action')
INSERT [dbo].[tblGenre] ([GenreId], [GenreName]) VALUES (2, N'Drama')
INSERT [dbo].[tblGenre] ([GenreId], [GenreName]) VALUES (3, N'Romantic')
INSERT [dbo].[tblGenre] ([GenreId], [GenreName]) VALUES (4, N'Comedy')
INSERT [dbo].[tblGenre] ([GenreId], [GenreName]) VALUES (5, N'Muscial')
INSERT [dbo].[tblGenre] ([GenreId], [GenreName]) VALUES (6, N'Other')
GO
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (1, N'Universal Pictures')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (2, N'Paramount Pictures')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (3, N'Walt Disney Pictures')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (4, N'20th Century Fox')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (5, N'Columbia Pictures')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (6, N'Warner Bros. Pictures')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (7, N'Touchstone Pictures')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (8, N'Dreamworks')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (9, N'ImageMovers')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (10, N'Disney Pixar')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (11, N'MGM')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (12, N'Chris Lee Productions')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (13, N'Lucasfilm')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (14, N'New Line Cinema')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (15, N'Carolco Pictures')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (16, N'Miramax Films')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (17, N'Jerry Bruckheimer Films')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (18, N'Gaumont')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (19, N'Revolution Studios')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (20, N'Imagine Entertainment')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (21, N'Morgan Creek Productions')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (22, N'United Artists')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (23, N'Dimension Films')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (24, N'Braveworld Productions')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (25, N'Icon Productions')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (26, N'Carolina Bank')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (27, N'Tig Productions')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (28, N'Dune Entertainment')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (29, N'Beijing New Picture Film Co.')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (30, N'Big Talk Productions')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (31, N'Malpaso Company')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (32, N'British Film Council')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (33, N'Channel Four Films')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (34, N'Constantin Film')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (35, N'Bavaria Film')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (36, N'Bayerischer Rundfunk')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (37, N'RKO Radio Pictures')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (38, N'Toho Company')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (39, N'Kathbur Pictures')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (40, N'Avalon Studios')
GO
ALTER TABLE [dbo].[tblFilm]  WITH CHECK ADD  CONSTRAINT [FK_tblFilm_tblCountry] FOREIGN KEY([FilmCountryID])
REFERENCES [dbo].[tblCountry] ([CountryID])
GO
ALTER TABLE [dbo].[tblFilm] CHECK CONSTRAINT [FK_tblFilm_tblCountry]
GO
ALTER TABLE [dbo].[tblFilm]  WITH CHECK ADD  CONSTRAINT [FK_tblFilm_tblDirector] FOREIGN KEY([FilmDirectorID])
REFERENCES [dbo].[tblDirector] ([DirectorID])
GO
ALTER TABLE [dbo].[tblFilm] CHECK CONSTRAINT [FK_tblFilm_tblDirector]
GO
ALTER TABLE [dbo].[tblFilm]  WITH CHECK ADD  CONSTRAINT [FK_tblFilm_tblStudio1] FOREIGN KEY([FilmStudioID])
REFERENCES [dbo].[tblStudio] ([StudioID])
GO
ALTER TABLE [dbo].[tblFilm] CHECK CONSTRAINT [FK_tblFilm_tblStudio1]
GO
/****** Object:  StoredProcedure [dbo].[spExample]    Script Date: 12/21/2021 12:12:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spExample]

AS
BEGIN
	select * from tblFilm
END
GO
/****** Object:  StoredProcedure [dbo].[spFilms]    Script Date: 12/21/2021 12:12:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[spFilms] (

	@CertName varchar(2),	-- certificate looking for
	@MinOscars int=0		-- films with this many Oscars

) AS
SELECT 
	f.FilmName,
	c.certificate,
	f.FilmOscarWins
FROM
	tblFilm AS f
	INNER JOIN tblCertificate as c ON 
		f.FilmCertificateId=c.CertificateId
WHERE
	c.certificate=@CertName AND
	FilmOscarWins>=@MinOscars
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tblCertificate"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 84
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwFilmDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwFilmDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[9] 2[14] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[37] 4[17] 3) )"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4[30] 2[40] 3) )"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1[56] 3) )"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 1
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tblCertificate"
            Begin Extent = 
               Top = 131
               Left = 212
               Bottom = 209
               Right = 363
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblFilm"
            Begin Extent = 
               Top = 84
               Left = 442
               Bottom = 192
               Right = 626
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "tblCountry"
            Begin Extent = 
               Top = 6
               Left = 631
               Bottom = 84
               Right = 782
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblDirector"
            Begin Extent = 
               Top = 6
               Left = 820
               Bottom = 114
               Right = 973
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblLanguage"
            Begin Extent = 
               Top = 84
               Left = 664
               Bottom = 162
               Right = 815
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblStudio"
            Begin Extent = 
               Top = 27
               Left = 168
               Bottom = 105
               Right = 319
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
      PaneHidden = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width =' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwFilms'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' 1500
         Width = 1500
         Width = 1500
         Width = 1065
         Width = 1035
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwFilms'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwFilms'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tblFilm"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 222
            End
            DisplayFlags = 280
            TopColumn = 10
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwFilmSimple'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwFilmSimple'
GO
USE [master]
GO
ALTER DATABASE [Movies] SET  READ_WRITE 
GO
