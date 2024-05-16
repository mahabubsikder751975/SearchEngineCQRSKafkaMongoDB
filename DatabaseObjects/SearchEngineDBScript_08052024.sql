/*Section

--DDL

*/

ALTER TABLE [dbo].[tbl_UserSearchHistory] ALTER COLUMN [Type] VARCHAR(10)
alter table dbo.tbl_UserSearchHistory add [IsDeleted] bit
alter table dbo.tbl_UserSearchHistory add [TrackType] varchar(10)

alter table dbo.tbl_Video_Batch alter column [id] bigint
alter table dbo.tbl_ReleaseVideo alter column [releaseId] bigint

CREATE NONCLUSTERED INDEX IX_Artist_Name  ON [dbo].[tbl_Artist](name)  -- Create a nonclustered hash index on the 'Name' column
CREATE NONCLUSTERED INDEX IX_UNIVERSAL ON [dbo].[tbl_Artist](id,[name],follower) INCLUDE (IMAGE)


CREATE NONCLUSTERED INDEX IX_Release_Batch_title  ON [dbo].[tbl_Release_Batch](title)  -- Create a nonclustered hash index on the 'Name' column
CREATE NONCLUSTERED INDEX IX_UNIVERSAL  ON [dbo].[tbl_Release_Batch](id,title,artistAppearsAs,artistId,releaseDate)
INCLUDE (image)


CREATE NONCLUSTERED INDEX IX_ReleaseVideo_title  ON [dbo].[tbl_ReleaseVideo](title)  -- Create a nonclustered hash index on the 'Name' column


--CREATE NONCLUSTERED INDEX IX_Track_Batch_title  ON [dbo].[tbl_Track_Batch](title)  -- Create a nonclustered hash index on the 'Name' column
GO
--CREATE NONCLUSTERED INDEX IX_Video_Batch_title  ON [dbo].[tbl_Video_Batch](title)  -- Create a nonclustered hash index on the 'Name' column
CREATE NONCLUSTERED INDEX [IX_Video_Batch_title] ON [dbo].[tbl_Video_Batch]
(
	releaseId,[title] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
--CREATE NONCLUSTERED INDEX IX_PodcastEpisode_Name  ON [dbo].[temp_tbl_PodcastEpisode](name,SearchName)  -- Create a nonclustered hash index on the 'Name' column
CREATE NONCLUSTERED INDEX [IX_PodcastEpisode_Name] ON [dbo].[temp_tbl_PodcastEpisode]
(
	[Name] ASC,
	[SearchName] ASC,
	ContentType
) INCLUDE(ImageUrl) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]


--CREATE NONCLUSTERED INDEX IX_PodcastShow_Name  ON [dbo].[temp_tbl_PodcastShow](name)  -- Create a nonclustered hash index on the 'Name' column
CREATE NONCLUSTERED INDEX [IX_PodcastShow_Name] ON [dbo].[temp_tbl_PodcastShow]
(
	[Name] ASC,
	[SearchName] ASC,
	ContentType
) INCLUDE (ImageUrl,Presenter,Duration) WITH  (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]



GO
--CREATE NONCLUSTERED INDEX IX_PodcastTrack_Name  ON [dbo].[temp_tbl_PodcastTrack](Name,SearchName)  -- Create a nonclustered hash index on the 'Name' column
CREATE NONCLUSTERED INDEX [IX_PodcastTrack_Name] ON [dbo].[temp_tbl_PodcastTrack]
(
	[Name] ASC,
	[SearchName] ASC,
	ContentType,
	Starring,
	[ShowId] ASC,
	[EpisodeId] ASC,
	Duration,
	IsPaid,
	IsTakeUp,
	TrackType
) INCLUDE([ImageUrl],[PlayUrl]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

GO
ALTER TABLE [dbo].[tbl_UserPlay_History] ADD  CONSTRAINT [PK_tbl_UserPlay_History] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

CREATE  NONCLUSTERED  INDEX  [IX_UserPlay_History_Name] ON [dbo].[tbl_UserPlay_History]
(
	 Id,UserCode,ContentId,Type,UserPlayListId
)  WITH  (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_Release_Batch_Name] ON [dbo].[tbl_Release_Batch]
(
	Id,labelName,artistId,artistAppearsAs
)  WITH  (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]


CREATE NONCLUSTERED INDEX [IX_Track_Batch_title] ON [dbo].[tbl_Track_Batch]
(
	id,releaseId,[title] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

GO

DROP TABLE TBL_PODCASTSHOW_GENRE
GO
CREATE TABLE TBL_PODCASTSHOW_GENRE
(ID INT, 
GENRENAME VARCHAR(255)
)

INSERT INTO TBL_PODCASTSHOW_GENRE
VALUES(1,'HORROR'),(2,'ROMANTIC'),(3,'CRIME FICTION'),(4,'RELIGIOUS')
,(5,'LIFE STYLE'),(6,'CHILD STORY'),(7,'BIOGRAPHY'),(8,'HEALTH CARE')
,(9,'COMEDY'),(10,'MUSICAL'),(11,'DRAMA'),(12,'INTERVIEW'),(13,'HISTORY')
GO

ALTER TABLE [dbo].[temp_tbl_PodcastShow] ADD  Genre INT
ALTER TABLE  [dbo].[temp_tbl_PodcastVideoShow] ADD  Genre INT
GO

/*Section

--Views

*/

USE [Music_Streaming]
GO
--DROP  VIEW_PODCAST
CREATE VIEW View_PodcastVideoTrackStreaming
WITH SCHEMABINDING
AS
/*
SELECT * FROM [Music_Streaming]..View_PodcastVideoTrackStreaming
*/
SELECT PodcastTracktId ContentId
	,ContentType TYPE
	,Count_Big(*) TotalStreamingCount
FROM [dbo].[temp_tbl_UserPodcastVideoPlayHistory]
GROUP BY PodcastTracktId
	,ContentType

GO

CREATE UNIQUE CLUSTERED  INDEX PodcastStreaming_UNIQUE_ID ON View_PodcastVideoTrackStreaming(ContentId,Type)

CREATE NONCLUSTERED INDEX IX_PodcastStreaming_UNIVERSAL 
ON View_PodcastVideoTrackStreaming(ContentId,Type,TotalStreamingCount)

GO
USE [Music_Streaming]
GO
--DROP  VIEW_PODCAST
CREATE VIEW View_PodcastTrackStreaming
WITH SCHEMABINDING
AS
/*
SELECT * FROM [Music_Streaming]..View_PodcastTrackStreaming
*/
SELECT PodcastTracktId ContentId
	,ContentType TYPE
	,Count_Big(*) TotalStreamingCount
FROM [dbo].[temp_tbl_UserPodcastPlayHistory]
GROUP BY PodcastTracktId
	,ContentType

GO

CREATE UNIQUE CLUSTERED  INDEX PodcastStreaming_UNIQUE_ID ON View_PodcastTrackStreaming(ContentId,Type)

CREATE NONCLUSTERED INDEX IX_PodcastStreaming_UNIVERSAL 
ON View_PodcastTrackStreaming(ContentId,Type,TotalStreamingCount)

GO
USE [Music_Streaming]
GO
--DROP  VIEW_PODCAST
ALTER VIEW View_PodcastsTrack
WITH SCHEMABINDING
AS
/*
SELECT * FROM [Music_Streaming]..View_PodcastsTrack
*/
SELECT PS.CeateDate	PodcastShowCreateDate
,PS.id PodcastShowId
			,PS.ImageUrl PodcastShowImageUrl
			,PS.[Name] AS PodcastShowName
			,PS.SearchName +' ' + PS.Presenter AS PodcastShowSearchName
			,'Show' AS PodcastShowType
			,'PD' + PS.ContentType AS PodcastShowContentType
			,PS.Presenter AS PodcastShowPresenter
			,PS.Duration AS PodcastShowDuration
			,PS.Genre
			,PS.ProductBy
			,PE.CeateDate PodcastEpisodeCreateDate
			,PE.id PodcastEpisodeId
			,PE.ImageUrl PodcastEpisodeImageUrl
			,PE.[Name] AS PodcastEpisodeName
			,PE.SearchName AS PodcastEpisodeSearchName
			,'Episode' AS PodcastEpisodeType
			,'PD' + PE.ContentType AS PodcastEpisodeContentType
			,PT.CeateDate PodcastTrackIdCreateDate
			,PT.id PodcastTrackId
			,PT.ImageUrl PodcastTrackImageUrl
			,PT.[Name] AS PodcastTrackName
			,PT.SearchName AS PodcastTrackSearchName
			,'Track' AS PodcastTrackType
			,'PD' + PT.ContentType AS PodcastTrackContentType
			,PT.PlayUrl PodcastTrack
			,PT.Starring AS PodcastTrackStarring
			,PT.Duration AS PodcastTrackDuration
			,PT.IsPaid
			,PT.Seekable
			,PT.TrackType
			
FROM [dbo].[temp_tbl_PodcastShow] PS
INNER JOIN [dbo].[temp_tbl_PodcastEpisode] PE ON PE.ShowId=PS.Id
INNER JOIN [dbo].[temp_tbl_PodcastTrack] PT ON PT.EpisodeId=PE.Id
WHERE PT.IsTakeUp = 1 AND PS.ProductBy!= 'Banglalink'
			AND PT.TrackType NOT IN (
				'T'
				,'L'
				)
GO

CREATE UNIQUE CLUSTERED  INDEX Podcast_UNIQUE_ID ON View_PodcastsTrack(PodcastTrackId)

CREATE NONCLUSTERED INDEX IX_UNIVERSAL 
ON View_PodcastsTrack(PodcastShowId,PodcastShowName,PodcastShowSearchName
,PodcastEpisodeId,PodcastEpisodeName,PodcastEpisodeSearchName
,PodcastTrackId,PodcastTrackName,PodcastTrackSearchName) INCLUDE
(PodcastShowImageUrl,PodcastShowType,PodcastShowContentType
,PodcastEpisodeImageUrl,PodcastEpisodeType,PodcastEpisodeContentType
,PodcastTrackImageUrl,PodcastTrackType,PodcastTrackContentType,TrackType)

GO
USE [Music_Streaming]
GO
--DROP  View_PodcastsVideoTrack
ALTER VIEW View_PodcastsVideoTrack
WITH SCHEMABINDING
AS
/*
SELECT * FROM [Music_Streaming]..View_PodcastsVideoTrack
*/
SELECT PS.CeateDate	PodcastShowCreateDate
			,PS.id PodcastShowId
			,PS.ImageUrl PodcastShowImageUrl
			,PS.[Name]+' '+ PS.Presenter AS PodcastShowName
			,PS.SearchName AS PodcastShowSearchName
			,'Show' AS PodcastShowType
			,'VD' + PS.ContentType AS PodcastShowContentType
			,PS.Presenter AS PodcastShowPresenter
			,PS.Duration AS PodcastShowDuration
			,PS.Genre
			,PS.ProductBy
			,PE.CeateDate PodcastEpisodeCeateDate
			,PE.id PodcastEpisodeId
			,PE.ImageUrl PodcastEpisodeImageUrl
			,PE.[Name] AS PodcastEpisodeName
			,PE.SearchName AS PodcastEpisodeSearchName
			,'Episode' AS PodcastEpisodeType
			,'VD' + PE.ContentType AS PodcastEpisodeContentType
			,PT.CeateDate PodcastTrackIdCeateDate
			,PT.id PodcastTrackId
			,PT.ImageUrl PodcastTrackImageUrl
			,PT.[Name] AS PodcastTrackName
			,PT.SearchName AS PodcastTrackSearchName
			,'Track' AS PodcastTrackType
			,'VD' + PT.ContentType AS PodcastTrackContentType
			,PT.PlayUrl PodcastTrack
			,PT.Starring AS PodcastTrackStarring
			,PT.Duration AS PodcastTrackDuration
			,PT.IsPaid
			,PT.Seekable
			,PT.TrackType			
			FROM [dbo].[temp_tbl_PodcastVideoShow] PS
INNER JOIN [dbo].[temp_tbl_PodcastVideoEpisode] PE ON PE.ShowId=PS.Id
INNER JOIN [dbo].[temp_tbl_PodcastVideoTrack] PT ON PT.EpisodeId=PE.Id
WHERE PT.IsTakeUp = 1
			AND PT.TrackType NOT IN (
				'T'
				,'L'
				)
GO

CREATE UNIQUE CLUSTERED  INDEX Podcast_UNIQUE_ID ON View_PodcastsVideoTrack(PodcastTrackId)

CREATE NONCLUSTERED INDEX IX_UNIVERSAL 
ON View_PodcastsVideoTrack(PodcastShowId,PodcastShowName,PodcastShowSearchName
,PodcastEpisodeId,PodcastEpisodeName,PodcastEpisodeSearchName
,PodcastTrackId,PodcastTrackName,PodcastTrackSearchName) INCLUDE
(PodcastShowImageUrl,PodcastShowType,PodcastShowContentType
,PodcastEpisodeImageUrl,PodcastEpisodeType,PodcastEpisodeContentType
,PodcastTrackImageUrl,PodcastTrackType,PodcastTrackContentType,TrackType)

GO

USE [Music_Streaming]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[View_ASongs]
WITH SCHEMABINDING 
AS
/*
SELECT * FROM View_ASongs
*/
			
	SELECT T.id
		,R.IMAGE AS ImageUrl
		,T.title
		,'S' AS [Type]
		,'S' AS ContentType
		,T.streamUrl_mp3 AS PlayUrl
		,R.artistAppearsAs AS artist
		,R.artistId
		,T.duration AS duration
		,T.TotalPlayCount
		,0 AS IsPaid
		,0 AS Seekable
		,0 AS IsPaid1
		,0 AS Seekable1
		,NULL AS TrackType
		,1 AS RN
		,R.id releaseId
		,releaseDate
		,r.id AlbumId
		,r.title AlbumTitle
		--,CASE WHEN LEN(unique_strings.value)=1 THEN dbo.CalculateLevenshteinDistance(@searchText, T.title) ELSE 0 END  Distance
	FROM dbo.tbl_Track_Batch AS T --WITH (NOLOCK)
	INNER JOIN dbo.tbl_Release_Batch AS R   ON R.id = T.releaseId
	
	--Cannot create index on view 'Music_Streaming.dbo.View_ASongs' because the view contains a table hint
GO

CREATE UNIQUE CLUSTERED  INDEX UNIQUE_ID ON View_ASongs(id)
CREATE NONCLUSTERED INDEX IX_UNIVERSAL ON View_ASongs(id,title,Type,ContentType,artistId) INCLUDE
(ImageUrl,PlayUrl,artist,duration,IsPaid,Seekable,IsPaid1,Seekable1,TrackType,RN,releaseId,releaseDate)

GO
USE [Music_Streaming]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[View_VSongs]
WITH SCHEMABINDING 
AS
/*
SELECT * FROM [dbo].[View_VSongs]
*/
SELECT  
vt.id
	,vt.VideoPreview AS ImageUrl
	,vt.title AS title
	,'V' AS [Type]
	,'V' AS ContentType
	,streamUrl_mp4 AS PlayUrl
	,vr.artistAppearsAs AS artist
	,vr.artistId
	,duration AS duration
	,0 AS IsPaid
	,0 AS Seekable
	,NULL AS TrackType	
	,vr.id AlbumId
	,vr.title AlbumTitle
	,vt.releaseId
	,vr.releaseDate
	,g.Id GenreId
	,g.GenreName
FROM dbo.tbl_Video_Batch AS vt WITH (NOLOCK)		
INNER JOIN dbo.tbl_ReleaseVideo AS vr WITH (NOLOCK) ON vr.id = vt.releaseId
LEFT JOIN dbo.Genre g ON vt.GenreId= g.Id

GO

USE [Music_Streaming]
GO

/****** Object:  View [dbo].[View_Albums]    Script Date: 3/11/2024 2:52:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[View_Albums]
WITH SCHEMABINDING 
AS
/*
SELECT * FROM [View_Albums]
select * from [dbo].[tbl_Video_Batch]
select * from dbo.tbl_Release_Batch
select * FROM dbo.tbl_Track_Batch
*/
	SELECT  
	R.id
	,R.image AS ImageUrl
	,R.title AS title
	,'R' AS [Type]
	,'R' AS ContentType
	,StreamUrl_mp4 AS PlayUrl
	,R.artistAppearsAs AS artist
	,R.artistId
	,0 AS duration
	,0 AS IsPaid
	,0 AS Seekable
	,NULL AS TrackType	
	,R.releaseDate
	,R.id AlbumId
	,R.title AlbumTitle	
	FROM dbo.tbl_Release_Batch AS R WITH (NOLOCK)		
	INNER JOIN [dbo].[tbl_Video_Batch] V WITH (NOLOCK)	ON R.id = V.releaseId

GO
USE [Music_Streaming]
GO

/****** Object:  View [dbo].[View_Albums]    Script Date: 3/11/2024 2:52:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[View_Albums_Track]
WITH SCHEMABINDING 
AS
/*
SELECT * FROM [View_Albums_Track]
select * from [dbo].[tbl_Video_Batch]
select * from dbo.tbl_Release_Batch
select * FROM dbo.tbl_Track_Batch
*/
	SELECT  
	R.id
	,R.image AS ImageUrl
	,R.title AS title
	,'R' AS [Type]
	,'R' AS ContentType
	,streamUrl_mp3 AS PlayUrl
	,R.artistAppearsAs AS artist
	,R.artistId
	,0 AS duration
	,0 AS IsPaid
	,0 AS Seekable
	,NULL AS TrackType	
	,R.releaseDate
	,R.id AlbumId
	,R.title AlbumTitle	
	FROM dbo.tbl_Release_Batch AS R WITH (NOLOCK)		
	INNER JOIN [dbo].[tbl_track_Batch] V WITH (NOLOCK)	ON R.id = V.releaseId

GO
USE [Music_Streaming]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[View_PlayList]
WITH SCHEMABINDING 
AS
/*
SELECT * FROM [View_PlayList]
SELECT *
from [dbo].[tbl_Playlist] pl
INNER JOIN [dbo].[tbl_Publish_Content] plc ON pl.Code=plc.PlaylistId
INNER JOIN [dbo].[tbl_Track_Batch] as T  ON T.id=plc.ContentId
INNER JOIN [dbo].[tbl_Release_Batch] AS R ON R.id=T.releaseId

*/
select plc.Id PublishId,pl.ProcessTime, pl.Code PlayListId,pl.Name PlayListName,R.releaseDate,
T.[id] TrackId
      ,T.[releaseId]
      ,T.[artistId]
      ,T.[title]
      ,T.[artistAppearsAs]
      ,T.[version]
      ,T.[isrc]
      ,T.[trackNumber]
      ,T.[discNumber]
      ,T.[duration]
      ,pl.[Image] 
	  ,T.streamUrl_mp3 [streamUrl]
      ,T.[banlalin_rbt]
      ,T.[airtel_rbt]
      ,T.[teletalk_rbt]
      ,T.[gp_rbt]
      ,T.[citycell_rbt]
      ,T.[robi_rbt]
      ,T.[expired]
      ,T.[ulopad_Date]
      ,T.[GenreId]
      ,T.[ContentLanguageId]
      ,T.[TotalPlayCount]
from [dbo].[tbl_Playlist] pl
INNER JOIN [dbo].[tbl_Publish_Content] plc ON pl.Code=plc.PlaylistId
INNER JOIN [dbo].[tbl_Track_Batch] as T  ON T.id=plc.ContentId
INNER JOIN [dbo].[tbl_Release_Batch] AS R ON R.id=T.releaseId

GO

CREATE UNIQUE CLUSTERED  INDEX UNIQUE_ID ON View_PlayList(PublishId)
CREATE NONCLUSTERED INDEX IX_UNIVERSAL ON View_PlayList(PublishId,ProcessTime,PlayListId,TrackId,artistId) INCLUDE
(PlayListName,title,streamUrl,releaseDate,GenreId,TotalPlayCount)

GO

--DROP VIEW View_UserPlay_Album_History_Indexed
GO
CREATE VIEW View_UserPlay_Album_History_Indexed
WITH SCHEMABINDING
AS
select uph.id, uph.UserCode,uph.ContentId,uph.Type
,R.id AlbumId,R.labelName AlbumName, '' SearchName,uph.Time,uph.TimeCountSecond,uph.PlayCount
from [dbo].[tbl_UserPlay_History]  uph 
INNER JOIN dbo.tbl_Release_Batch AS R   ON R.id = uph.UserPlayListId AND 'R'=uph.Type
WHERE ISNULL(UserCode,'') != '' 
GO
--DROP VIEW View_UserPlay_Artist_History_Indexed
GO
CREATE VIEW View_UserPlay_Artist_History_Indexed
WITH SCHEMABINDING
AS
select  uph.id,uph.UserCode,uph.ContentId,'A' Type,uph.Time,uph.TimeCountSecond,uph.PlayCount
,A.id ArtistId,A.name ArtistName, '' SearchName
from [dbo].[tbl_UserPlay_History]  uph  
INNER JOIN dbo.tbl_Track_Batch AS S   ON S.id = uph.ContentId AND 'S'=uph.Type
INNER JOIN dbo.tbl_Artist AS A  ON A.id = S.artistId
WHERE ISNULL(UserCode,'') != '' 
GO
--DROP VIEW View_UserPlay_Video_History_Indexed
GO
CREATE VIEW View_UserPlay_Video_History_Indexed
WITH SCHEMABINDING
AS
select  uph.id,uph.UserCode,uph.ContentId,uph.Type,uph.Time,uph.TimeCountSecond,uph.PlayCount
,vt.id VideoId, vt.title VideoName, '' SearchName
from [dbo].[tbl_UserPlay_History]  uph  
INNER JOIN dbo.tbl_Video_Batch AS vt    ON vt.id = uph.ContentId AND 'V'=uph.Type
WHERE ISNULL(UserCode,'') != '' 
GO
--DROP VIEW View_UserPlay_Song_History_Indexed
GO
CREATE VIEW View_UserPlay_Song_History_Indexed
WITH SCHEMABINDING
AS
select  uph.id,uph.UserCode,uph.ContentId,uph.Type,uph.Time,uph.TimeCountSecond,uph.PlayCount
,S.id SongId,S.title SongName, '' SearchName
from [dbo].[tbl_UserPlay_History]  uph  
INNER JOIN dbo.tbl_Track_Batch AS S   ON S.id = uph.ContentId AND 'S'=uph.Type
WHERE ISNULL(UserCode,'') != '' 
GO
--Podcast
--DROP VIEW View_UserPlay_PodcastTrack_History_Indexed
GO
CREATE VIEW View_UserPlay_PodcastTrack_History_Indexed
WITH SCHEMABINDING
AS
/*
select * from [dbo].[View_UserPlay_PodcastTrack_History_Indexed]
*/
select  uph.id,uph.UserCode,uph.PodcastTracktId ContentId,'PD'+ContentType Type,uph.PlayTime Time
,uph.TimeCountSecond,uph.PlayCount
,PT.PodcastTrackId,PT.PodcastTrackName, PT.PodcastTrackSearchName 
from [dbo].[temp_tbl_UserPodcastPlayHistory]  uph
INNER JOIN [dbo].[View_PodcastsTrack] AS PT 
ON PT.PodcastTrackId=uph.PodcastTracktId 
AND PT.PodcastTrackContentType='PD'+uph.ContentType
WHERE ISNULL(UserCode,'') != '' 
UNION ALL
select  uph.id,uph.UserCode,uph.PodcastTracktId ContentId,'PD'+ContentType Type,uph.PlayTime Time
,uph.TimeCountSecond,uph.PlayCount
,PT.PodcastTrackId,PT.PodcastTrackName, PT.PodcastTrackSearchName 
from [dbo].[temp_tbl_UserPodcastVideoPlayHistory]  uph
INNER JOIN [dbo].[View_PodcastsVideoTrack] AS PT 
ON PT.PodcastTrackId=uph.PodcastTracktId 
AND PT.PodcastTrackContentType='PD'+uph.ContentType
WHERE ISNULL(UserCode,'') != '' 
GO
--DROP VIEW View_UserPlay_PodcastEpisode_History_Indexed
GO
CREATE VIEW View_UserPlay_PodcastEpisode_History_Indexed
WITH SCHEMABINDING
AS
/*
select * from [dbo].[View_UserPlay_PodcastEpisode_History_Indexed]
*/
select  uph.id,uph.UserCode,uph.PodcastTracktId ContentId,'PD'+ContentType Type,uph.PlayTime Time
,uph.TimeCountSecond,uph.PlayCount
,PE.PodcastEpisodeId,PE.PodcastEpisodeName, PE.PodcastEpisodeSearchName 
from [dbo].[temp_tbl_UserPodcastPlayHistory]  uph
INNER JOIN [dbo].[View_PodcastsTrack] AS PE  
ON PE.PodcastEpisodeId=uph.PodcastTracktId 
AND PE.PodcastEpisodeContentType='PD'+uph.ContentType
WHERE ISNULL(UserCode,'') != '' 
UNION ALL
select  uph.id,uph.UserCode,uph.PodcastTracktId ContentId,'PD'+ContentType Type,uph.PlayTime Time
,uph.TimeCountSecond,uph.PlayCount
,PE.PodcastEpisodeId,PE.PodcastEpisodeName, PE.PodcastEpisodeSearchName 
from [dbo].[temp_tbl_UserPodcastVideoPlayHistory]  uph
INNER JOIN [dbo].[View_PodcastsVideoTrack] AS PE  
ON PE.PodcastEpisodeId=uph.PodcastTracktId 
AND PE.PodcastEpisodeContentType='PD'+uph.ContentType
WHERE ISNULL(UserCode,'') != '' 

GO
--DROP VIEW View_UserPlay_PodcastShow_History_Indexed
GO
CREATE VIEW View_UserPlay_PodcastShow_History_Indexed
WITH SCHEMABINDING
AS
/*
select * from [dbo].[View_UserPlay_PodcastShow_History_Indexed]
*/
select DISTINCT uph.id,uph.UserCode,uph.PodcastTracktId ContentId,PS.PodcastShowContentType Type,uph.PlayTime Time
,uph.TimeCountSecond,uph.PlayCount
,PS.PodcastShowId,PS.PodcastShowName, PS.PodcastShowSearchName 
from [dbo].[temp_tbl_UserPodcastPlayHistory]  uph
INNER JOIN [dbo].[View_PodcastsTrack] AS PS  
ON PS.PodcastShowId=uph.PodcastTracktId 
--AND PS.PodcastShowContentType='PD'+uph.ContentType
WHERE ISNULL(UserCode,'') != '' 
UNION ALL
SELECT  uph.id,uph.UserCode,uph.PodcastTracktId ContentId,PS.PodcastShowContentType Type,uph.PlayTime Time
,uph.TimeCountSecond,uph.PlayCount
,PS.PodcastShowId,PS.PodcastShowName, PS.PodcastShowSearchName 
FROM [dbo].[temp_tbl_UserPodcastVideoPlayHistory]  uph
INNER JOIN [dbo].[View_PodcastsVideoTrack] AS PS  
ON PS.PodcastShowId=uph.PodcastTracktId 
--AND PS.PodcastShowContentType='PD'+uph.ContentType
WHERE ISNULL(UserCode,'') != ''



GO

CREATE UNIQUE CLUSTERED  INDEX UserPlay_Album_History_UNIQUE_ID ON View_UserPlay_Album_History_Indexed(Id)
CREATE NONCLUSTERED INDEX IX_UserPlay_Album_History_UNIVERSAL ON View_UserPlay_Album_History_Indexed(id,UserCode,ContentId,AlbumId) INCLUDE(Type,AlbumName,SearchName,Time,TimeCountSecond,PlayCount)

CREATE UNIQUE CLUSTERED  INDEX UserPlay_Artist_History_UNIQUE_ID ON View_UserPlay_Artist_History_Indexed(Id)
CREATE NONCLUSTERED INDEX IX_UserPlay_Artist_History_UNIVERSAL ON View_UserPlay_Artist_History_Indexed(id,UserCode,ContentId,ArtistId) INCLUDE(Type,ArtistName,SearchName,Time,TimeCountSecond,PlayCount)

CREATE UNIQUE CLUSTERED  INDEX UserPlay_Video_History_UNIQUE_ID ON View_UserPlay_Video_History_Indexed(Id)
CREATE NONCLUSTERED INDEX IX_UserPlay_Video_History_UNIVERSAL ON View_UserPlay_Video_History_Indexed(id,UserCode,ContentId,VideoId) INCLUDE (Type,VideoName,SearchName,Time,TimeCountSecond,PlayCount)

CREATE UNIQUE CLUSTERED  INDEX UserPlay_Song_History_UNIQUE_ID ON View_UserPlay_Song_History_Indexed(Id)
CREATE NONCLUSTERED INDEX IX_UserPlay_Song_History_UNIVERSAL ON View_UserPlay_Song_History_Indexed(id,UserCode,ContentId,SongId) INCLUDE (Type,SongName,SearchName,Time,TimeCountSecond,PlayCount)

--select sysdatetime()
--CREATE UNIQUE CLUSTERED  INDEX UserPlay_PodcastTrack_History_UNIQUE_ID ON View_UserPlay_PodcastTrack_History_Indexed(Id,UserCode,ContentId,Type)
--CREATE NONCLUSTERED INDEX IX_UserPlay_PodcastTrack_History_UNIVERSAL ON View_UserPlay_PodcastTrack_History_Indexed(id,PodcastTrackId,PodcastTrackName,PodcastTrackSearchName)

--CREATE UNIQUE CLUSTERED  INDEX UserPlay_PodcastEpisode_History_UNIQUE_ID ON View_UserPlay_PodcastEpisode_History_Indexed(Id,UserCode,ContentId,Type)
--CREATE NONCLUSTERED INDEX IX_UserPlay_PodcastEpisode_History_UNIVERSAL ON View_UserPlay_PodcastEpisode_History_Indexed(id,PodcastEpisodeId,PodcastEpisodeName,PodcastEpisodeSearchName)

--CREATE UNIQUE CLUSTERED  INDEX UserPlay_PodcastShow_History_UNIQUE_ID ON View_UserPlay_PodcastShow_History_Indexed(Id,UserCode,ContentId,Type)
--CREATE NONCLUSTERED INDEX IX_UserPlay_PodcastShow_History_UNIVERSAL ON View_UserPlay_PodcastShow_History_Indexed(id,PodcastShowId,PodcastShowName,PodcastShowSearchName)



--ON View_UserPlay_Album_History_Indexed(id,AlbumName,SongName,PodcastTrackName,PodcastTrackSearchName,PodcastEpisodeName
--,PodcastEpisodeSearchName,PodcastShowName,PodcastShowSearchName)
--SET STATISTICS TIME ON



GO

--SELECT top 10 * FROM  [dbo].[tbl_UserSearchHistory] WHERE type='P'
DROP VIEW View_Search_Album_History_Indexed
GO
CREATE VIEW View_Search_Album_History_Indexed
WITH SCHEMABINDING
AS
/*
SELeCT top 10 * FROM View_Search_Album_History_Indexed
select * from [dbo].[tbl_UserSearchHistory]
*/
SELECT H.id
			, R.[image]
			, R.title
			, H.[Type]
			, '' AS PlayUrl
			, R.artistAppearsAs AS artist
			, '' AS duration
			, H.ContentId 
			, H.[UserCode]
			, H.[CreateDate]
			, H.TrackType
	FROM [dbo].[tbl_Release_Batch] AS R 
	INNER JOIN [dbo].[tbl_UserSearchHistory] AS H  ON R.id=H.ContentId
	WHERE H.[Type]='R'
GO
CREATE UNIQUE CLUSTERED  INDEX UserPlay_Album_History_UNIQUE_ID ON View_Search_Album_History_Indexed(Id)
CREATE NONCLUSTERED INDEX IX_UserPlay_Album_History_UNIVERSAL ON View_Search_Album_History_Indexed(id,UserCode,ContentId) INCLUDE(Type,PlayUrl,title,createdate,artist,[image],duration)

GO

DROP VIEW View_Search_Song_History_Indexed
GO
CREATE VIEW View_Search_Song_History_Indexed
WITH SCHEMABINDING
AS
/*
SELeCT top 10 * FROM View_Search_Song_History_Indexed
*/
SELECT H.id
			, R.[image]
			, T.title
			, 'S' AS [Type]
			, T.streamUrl_mp3 as PlayUrl
			, R.artistAppearsAs as artist
			, T.duration as duration
			, H.ContentId
			,H.[UserCode]
			, H.[CreateDate]
			, H.TrackType
	FROM [dbo].[tbl_Track_Batch] as T 
	INNER JOIN [dbo].[tbl_Release_Batch] AS R  ON R.id=T.releaseId
	INNER JOIN [dbo].[tbl_UserSearchHistory] AS H  ON T.id=H.ContentId
	WHERE H.[Type]='S'
GO
CREATE UNIQUE CLUSTERED  INDEX UserPlay_Album_History_UNIQUE_ID ON View_Search_Song_History_Indexed(Id)
CREATE NONCLUSTERED INDEX IX_UserPlay_Album_History_UNIVERSAL ON View_Search_Song_History_Indexed(id,UserCode,ContentId) INCLUDE(Type,PlayUrl,title,createdate,artist,[image],duration)

GO

DROP VIEW View_Search_Artist_History_Indexed
GO
CREATE VIEW View_Search_Artist_History_Indexed
WITH SCHEMABINDING
AS
/*
SELeCT top 10 * FROM View_Search_Artist_History_Indexed
*/
SELECT H.id 
			, A.[image]
			, A.[name] AS title
			, 'A' AS [Type]
			, '' AS PlayUrl
			, A.[name] AS artist
			, '' AS duration
			,H.ContentId
			,H.[UserCode]
			, H.[CreateDate]
			, H.TrackType
	FROM  [dbo].[tbl_Artist] as A
	INNER JOIN [dbo].[tbl_UserSearchHistory] AS H  ON A.id=H.ContentId
	WHERE H.[Type]='A'
GO
CREATE UNIQUE CLUSTERED  INDEX UserPlay_Album_History_UNIQUE_ID ON View_Search_Artist_History_Indexed(Id)
CREATE NONCLUSTERED INDEX IX_UserPlay_Album_History_UNIVERSAL ON View_Search_Artist_History_Indexed(id,UserCode,ContentId) INCLUDE(Type,PlayUrl,title,createdate,artist,[image],duration)

GO
DROP VIEW View_Search_Video_History_Indexed
GO
CREATE VIEW View_Search_Video_History_Indexed
WITH SCHEMABINDING
AS
/*
SELeCT top 10 * FROM View_Search_Video_History_Indexed
*/
SELECT H.id
			, vt.VideoPreview [image]
			, vt.title as title
			, 'V' AS [Type]
			, streamUrl_mp4 as PlayUrl
			, vr.artistAppearsAs as artist
			, duration as duration
			,H.ContentId
			,H.[UserCode]
			, H.[CreateDate]
			, H.TrackType
	FROM [dbo].[tbl_Video_Batch] as vt 
	INNER JOIN dbo.tbl_ReleaseVideo as vr on vr.id=vt.releaseId
	INNER JOIN [dbo].[tbl_UserSearchHistory] AS H  ON vt.id=H.ContentId
	WHERE H.[Type]='V'
GO
CREATE UNIQUE CLUSTERED  INDEX UserPlay_Album_History_UNIQUE_ID ON View_Search_Video_History_Indexed(Id)
CREATE NONCLUSTERED INDEX IX_UserPlay_Album_History_UNIVERSAL ON View_Search_Video_History_Indexed(id,UserCode,ContentId) INCLUDE(Type,PlayUrl,title,createdate,artist,[image],duration)

GO

USE [Music_Streaming]
GO
--DROP VIEW View_Search
--GO
CREATE VIEW View_Search
WITH SCHEMABINDING
AS 

/*

select * FROM dbo.tbl_Track_Batch where title like 'tati%'

select * from View_Search where ContentSearchName like '%bhoot%' --2336
select * from [dbo].[View_ASongs] where title like 'janena%'
select [dbo].[CalculateLevenshteinDistance]( 'voot','Bhoot')
select * from View_Search where contenttype='PD'
select * FROM [dbo].[temp_tbl_PodcastVideoTrack] where clientName like '%Shadhin%'
select *  FROM [dbo].[temp_tbl_PodcastTrack] ps left outer  join [dbo].[View_PodcastTrackStreaming] strm
ON ps.id = strm.contentid

select * from [dbo].[View_PodcastTrackStreaming]
*/
WITH CTE_ALBUMS AS   
  (SELECT --TOP(10)   
	R.id
	,R.title     
	,'R'  AS ContentType
	,ROW_NUMBER() OVER (PARTITION BY 'R' ORDER BY releaseDate DESC) AS rn
  FROM dbo.tbl_Release_Batch AS R WITH (NOLOCK) 
    
),
CTE_SONGS AS   
  (    
  SELECT --TOP(10)
	T.id
    ,T.title    
	,'S' AS ContentType
    ,ROW_NUMBER() OVER (PARTITION BY 'S' ORDER BY TotalPlayCount DESC) AS rn
  FROM dbo.tbl_Track_Batch AS T WITH (NOLOCK)    
  INNER JOIN dbo.tbl_Release_Batch AS R ON R.id=T.releaseId 

  ),
CTE_ARTISTS AS   
  ( 
  SELECT
	A.id
    ,A.name AS title    
	,'A' AS ContentType 
	,ROW_NUMBER() OVER (PARTITION BY 'A' ORDER BY follower DESC) AS rn
  FROM  dbo.tbl_Artist AS A WITH (NOLOCK)   
 )
,
CTE_VIDEOS AS   
  ( 
  SELECT --TOP(10)
	vt.id  
	,vt.title AS title    
	,'V' AS ContentType 
	,ROW_NUMBER() OVER (PARTITION BY 'V' ORDER BY releaseDate DESC) AS rn
  FROM dbo.tbl_Video_Batch AS vt WITH (NOLOCK)    
  INNER JOIN dbo.tbl_ReleaseVideo AS vr  on vr.id=vt.releaseId   
 )
,
CTE_PLAYLIST AS   
  ( 
  SELECT --TOP(10)
	vt.PlayListId
	,vt.PlayListName AS title    
	,'P' AS ContentType 
	,ROW_NUMBER() OVER (PARTITION BY 'P' ORDER BY releaseDate DESC) AS rn
  FROM dbo.View_PlayList AS vt WITH (NOLOCK)    
 
 ),
CTE_PODCAST_SHOWS AS   
  (     
   SELECT DISTINCT PE.ShowId FROM [dbo].[temp_tbl_PodcastEpisode] AS PE WITH (NOLOCK)    where clientName like '%Shadhin%' 
   UNION    
   SELECT DISTINCT PT.ShowId FROM [dbo].[temp_tbl_PodcastTrack] AS PT WITH (NOLOCK)    where clientName like '%Shadhin%' 
  ), 
 CTE_PODCAST_SHOWS_FINAL AS   
  ( 
	SELECT  --TOP(10)
	PS.Id,
    PS.[Name] AS title,
	PS.SearchName,
	PS.Presenter,
    'PD' + PS.ContentType AS ContentType
    ,ROW_NUMBER() OVER (PARTITION BY PS.ContentType ORDER BY isnull(strm.TotalStreamingCount,0) DESC) AS rn 
  FROM [dbo].[temp_tbl_PodcastShow] AS PS WITH (NOLOCK) 
  INNER JOIN [dbo].[temp_tbl_PodcastEpisode] AS PE WITH (NOLOCK) ON PS.Id = PE.ShowId
  INNER JOIN [dbo].[temp_tbl_PodcastTrack] AS PT WITH (NOLOCK) ON  PE.Id = PT.EpisodeId
  LEFT OUTER JOIN [dbo].[View_PodcastTrackStreaming] strm ON PT.id = strm.contentid   
  WHERE 
  (PS.Id IN(SELECT DISTINCT [ShowId] FROM CTE_PODCAST_SHOWS))     
  AND PS.Expire='N'  AND PS.clientName like '%Shadhin%'
  )

, 
 CTE_PODCAST_EPISODES AS   
  (          
   SELECT DISTINCT PS.Id AS ShowId, NULL AS EpisodeId FROM [dbo].[temp_tbl_PodcastShow] AS PS WITH (NOLOCK)  where clientName like '%Shadhin%'
   UNION    
   SELECT DISTINCT ShowId AS ShowId, PT.EpisodeId FROM [dbo].[temp_tbl_PodcastTrack] AS PT WITH (NOLOCK)  where clientName like '%Shadhin%'
  ) ,
 CTE_PODCAST_EPISODES_FINAL AS   
  (  
SELECT --TOP(10)
	PE.Id,
	PE.[Name] AS title ,
	PE.SearchName
    , 'PD' + PE.ContentType AS ContentType
	,ROW_NUMBER() OVER (PARTITION BY PE.ContentType ORDER BY  isnull(strm.TotalStreamingCount,0) DESC) AS rn
   FROM [dbo].[temp_tbl_PodcastEpisode] AS PE WITH (NOLOCK)       
  INNER JOIN [dbo].[temp_tbl_PodcastTrack] AS PT WITH (NOLOCK) ON  PE.Id = PT.EpisodeId
  LEFT OUTER JOIN [dbo].[View_PodcastTrackStreaming] strm ON PT.id = strm.contentid 
   WHERE 
    (PE.ShowId IN(SELECT [ShowId] FROM CTE_PODCAST_EPISODES WHERE [ShowId] IS NOT NULL)    
     OR PE.Id IN(SELECT EpisodeId FROM CTE_PODCAST_EPISODES WHERE EpisodeId IS NOT NULL))    
     AND PE.Expire='N'   AND PE.clientName like '%Shadhin%'      
  )
,
CTE_PODCAST_TRACKS AS   
  (     
   SELECT DISTINCT PS.Id AS ShowId, NULL AS EpisodeId FROM [dbo].[temp_tbl_PodcastShow] AS PS WITH (NOLOCK)  where clientName like '%Shadhin%'
   UNION    
   SELECT DISTINCT ShowId AS ShowId, PE.Id AS EpisodeId FROM [dbo].[temp_tbl_PodcastEpisode] AS PE WITH (NOLOCK)  where clientName like '%Shadhin%'
  ) ,

  CTE_PODCAST_TRACKS_FINAL AS   
  ( 
  SELECT --TOP(10) 
	PT.Id,
	PT.[Name] AS title,
	PT.SearchName
    , 'PD' + PT.ContentType AS ContentType
   ,ROW_NUMBER() OVER (PARTITION BY ContentType ORDER BY isnull(strm.TotalStreamingCount,0) DESC) AS rn
	FROM [dbo].[temp_tbl_PodcastTrack] AS PT WITH (NOLOCK)  
	LEFT OUTER JOIN [dbo].[View_PodcastTrackStreaming] strm WITH (NOLOCK) 
	ON PT.id = strm.contentid    
   WHERE PT.IsTakeUp=1 AND PT.TrackType NOT IN('T', 'L')  
    OR (PT.ShowId IN(SELECT [ShowId] FROM CTE_PODCAST_TRACKS WHERE [ShowId] IS NOT NULL)    
    OR PT.EpisodeId IN(SELECT [EpisodeId] FROM CTE_PODCAST_TRACKS WHERE [EpisodeId] IS NOT NULL))   AND clientName like '%Shadhin%'
 ),
 CTE_PODCAST_VIDEO_SHOWS AS   
  (     
   SELECT DISTINCT PE.ShowId FROM [dbo].[temp_tbl_PodcastVideoEpisode] AS PE WITH (NOLOCK) where clientName like '%Shadhin%'
   UNION    
   SELECT DISTINCT PT.ShowId FROM [dbo].[temp_tbl_PodcastVideoTrack] AS PT WITH (NOLOCK) where clientName like '%Shadhin%'    
  ), 
 CTE_PODCAST_VIDEO_SHOWS_FINAL AS   
  ( 
	SELECT  --TOP(10)
	PS.Id,
    PS.[Name] AS title,
	PS.SearchName ,
	PS.Presenter,
    'PD' + PS.ContentType AS ContentType
   ,ROW_NUMBER() OVER (PARTITION BY PS.ContentType ORDER BY  isnull(strm.TotalStreamingCount,0) DESC) AS rn 
  FROM [dbo].[temp_tbl_PodcastVideoShow] AS PS WITH (NOLOCK)   
  INNER JOIN [dbo].[temp_tbl_PodcastVideoEpisode] AS PE WITH (NOLOCK) ON PS.Id = PE.ShowId
  INNER JOIN [dbo].[temp_tbl_PodcastVideoTrack] AS PT WITH (NOLOCK) ON  PE.Id = PT.EpisodeId
  LEFT OUTER JOIN [dbo].[View_PodcastVideoTrackStreaming] strm ON PT.id = strm.contentid   

  WHERE 
  (PS.Id IN(SELECT DISTINCT [ShowId] FROM CTE_PODCAST_VIDEO_SHOWS))     
  AND PS.Expire='N'  AND PS.clientName like '%Shadhin%'
  )
, 
 CTE_PODCAST_VIDEO_EPISODES AS   
  (          
   SELECT DISTINCT PS.Id AS ShowId, NULL AS EpisodeId FROM [dbo].[temp_tbl_PodcastVideoShow] AS PS WITH (NOLOCK)  where clientName like '%Shadhin%'
   UNION    
   SELECT DISTINCT NULL AS ShowId, PT.EpisodeId FROM [dbo].[temp_tbl_PodcastVideoTrack] AS PT WITH (NOLOCK)  where clientName like '%Shadhin%'
  ) ,
 CTE_PODCAST_VIDEO_EPISODES_FINAL AS   
  (  
SELECT --TOP(10) 
	PE.Id,
	PE.[Name] AS title ,
	PE.SearchName
    , 'PD' + PE.ContentType AS ContentType
	,ROW_NUMBER() OVER (PARTITION BY PE.ContentType ORDER BY isnull(strm.TotalStreamingCount,0) DESC) AS rn
   FROM [dbo].[temp_tbl_PodcastVideoEpisode] AS PE WITH (NOLOCK)	
	INNER JOIN [dbo].[temp_tbl_PodcastVideoTrack] AS PT WITH (NOLOCK) ON  PE.Id = PT.EpisodeId
	LEFT OUTER JOIN [dbo].[View_PodcastVideoTrackStreaming] strm ON PT.id = strm.contentid   
   WHERE 
    (PE.ShowId IN(SELECT [ShowId] FROM CTE_PODCAST_VIDEO_EPISODES WHERE [ShowId] IS NOT NULL)    
     OR PE.Id IN(SELECT EpisodeId FROM CTE_PODCAST_VIDEO_EPISODES WHERE EpisodeId IS NOT NULL))    
     AND PE.Expire='N'  AND PE.clientName like '%Shadhin%'        
  )
,
CTE_PODCAST_VIDEO_TRACKS AS   
  (     
   SELECT DISTINCT PS.Id AS ShowId, NULL AS EpisodeId FROM [dbo].[temp_tbl_PodcastVideoShow] AS PS WITH (NOLOCK)  where clientName like '%Shadhin%'
   UNION    
   SELECT DISTINCT NULL AS ShowId, PE.Id AS EpisodeId FROM [dbo].[temp_tbl_PodcastVideoEpisode] AS PE WITH (NOLOCK)  where clientName like '%Shadhin%'
  ) ,

  CTE_PODCAST_VIDEO_TRACKS_FINAL AS   
  ( 
  SELECT --TOP(10)
	PT.id,
	PT.[Name] AS title,
	PT.SearchName
    , 'PD' + PT.ContentType AS ContentType
   ,ROW_NUMBER() OVER (PARTITION BY ContentType ORDER BY isnull(strm.TotalStreamingCount,0) DESC) AS rn
	FROM [dbo].[temp_tbl_PodcastVideoTrack] AS PT WITH (NOLOCK)   LEFT OUTER JOIN [dbo].[View_PodcastTrackStreaming] strm WITH (NOLOCK) 
	ON PT.id = strm.contentid        
   WHERE PT.IsTakeUp=1 AND PT.TrackType NOT IN('T', 'L')  
    OR (PT.ShowId IN(SELECT [ShowId] FROM CTE_PODCAST_VIDEO_TRACKS WHERE [ShowId] IS NOT NULL)    
    OR PT.EpisodeId IN(SELECT [EpisodeId] FROM CTE_PODCAST_VIDEO_TRACKS WHERE [EpisodeId] IS NOT NULL))  AND clientName like '%Shadhin%'
 )



SELECT ContentId,ContentName,ContentSearchName,ContentType,MIN(rn) group_rn
FROM (
    SELECT DISTINCT ContentId,ContentName,SearchName ContentSearchName,ContentType,rn
	--, ROW_NUMBER() OVER (PARTITION BY ContentType ORDER BY rn ASC) AS group_rn
    FROM (
		SELECT id ContentId, title ContentName ,title SearchName    
		, ContentType,rn  FROM CTE_ARTISTS
		UNION
		SELECT id,title    ,title SearchName  
		   , ContentType,rn  FROM CTE_VIDEOS
		UNION
		SELECT id,title    ,title SearchName  
		   , ContentType,rn  FROM CTE_SONGS
		UNION
		SELECT id,title    ,title SearchName  
		   , ContentType,rn  FROM CTE_ALBUMS
		UNION
		SELECT PlayListId,title    ,title SearchName  
		   , ContentType,rn  FROM CTE_PLAYLIST   
		UNION
		SELECT id,title,SearchName    
		   , ContentType,rn  FROM CTE_PODCAST_TRACKS_FINAL
		UNION
		SELECT id,title ,SearchName   
		   , ContentType,rn  FROM CTE_PODCAST_EPISODES_FINAL
		UNION
		SELECT id,title    ,ISNULL(SearchName,'')+' '+ISNULL(Presenter,'')
		   , ContentType,rn  FROM CTE_PODCAST_SHOWS_FINAL
		UNION
		SELECT id,title,SearchName    
		   , ContentType,rn  FROM CTE_PODCAST_VIDEO_TRACKS_FINAL
		UNION
		SELECT id,title ,SearchName   
		   , ContentType,rn  FROM CTE_PODCAST_VIDEO_EPISODES_FINAL
		UNION
		SELECT id,title    ,ISNULL(SearchName,'') +' '+ISNULL(Presenter,'')
		   , ContentType,rn  FROM CTE_PODCAST_VIDEO_SHOWS_FINAL
    ) AS CombinedCTEs
) AS GroupedCTEs
WHERE rn <= 5000
GROUP BY  ContentId,ContentName,ContentSearchName,ContentType

--ORDER BY ContentType
;
GO

--CREATE UNIQUE CLUSTERED  INDEX View_Search_UNIQUE_ID ON View_Search(rn)
--CREATE NONCLUSTERED INDEX IX_UNIVERSAL ON View_Search(rn,ContentName,SearchName ContentSearchName,ContentType)

/*Section

--Procedures

*/

GO

USE [Music_Streaming]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetUserSearchHistory]    Script Date: 4/4/2024 11:09:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_GetUserSearchHistory]
		@userCode VARCHAR(100)
AS
/*
EXEC [dbo].[usp_GetUserSearchHistory] '8801711090920'
select top 10 * FROM View_Search_Song_History_Indexed 
select top 10 * FROM  View_Search_Artist_History_Indexed
select top 10 * FROM View_Search_Video_History_Indexed
select top 10 * FROM View_Search_Album_History_Indexed
select * FROM [Music_Streaming].[dbo].[tbl_UserSearchHistory]
where usercode like '%8801711090920%'
order by createdate desc --564455
--order by createdate desc
WHERE UserCode like '%01983844224%'
WHERE cast(CreateDate as date)=cast(getdate() as date)

*/
BEGIN
-- SELECT distinct type FROM [dbo].[tbl_UserSearchHistory]
-- '90637', '90638', '90086', '16173', '15668', '15654'
-- DECLARE @userCode VARCHAR(100)='+8801819509506'

SELECT TOP(10) id,ContentId, [image], title, [Type], PlayUrl, artist, duration, CreateDate,TrackType FROM (
	SELECT id,ContentId
			, [image]
			, title
			, [Type]
			, PlayUrl
			, artist
			, duration
			, [CreateDate]
			,TrackType
	FROM View_Search_Album_History_Indexed
	WHERE [UserCode]=@userCode
	UNION
	SELECT id,ContentId
			, [image]
			, title
			, 'S' AS [Type]
			, PlayUrl
			, artist
			, duration
			, [CreateDate]
			,TrackType
	FROM View_Search_Song_History_Indexed 
	WHERE [UserCode]=@userCode AND [Type]='S'
	UNION
	SELECT id ,ContentId
			, [image]
			, title
			, [Type]
			, PlayUrl
			, artist
			, duration
			, [CreateDate]
			,TrackType
	FROM  View_Search_Artist_History_Indexed
	WHERE [UserCode]=@userCode AND [Type]='A'
	UNION
	SELECT id,ContentId
			, [image]
			, title
			, [Type]
			, PlayUrl
			, artist
			, duration
			, [CreateDate]
			,TrackType
	FROM View_Search_Video_History_Indexed
	WHERE [UserCode]=@userCode AND [Type]='V'
) AS tbl
ORDER BY [CreateDate] DESC
END


GO
USE [Music_Streaming]
GO
ALTER PROCEDURE dbo.usp_GetTopPlayList
@PageSize INT = 10
AS
/*
select * from dbo.View_Playlist
EXEC [Music_Streaming].dbo.usp_GetTopPlayList 20
*/
BEGIN

SELECT DISTINCT TOP (@PageSize)  
--[PublishId]
      [PlayListId] id
	  ,'P' ContentType
	  ,0 artistId
	  ,artistAppearsAs artist
--	  ,[releaseId]
 --     ,[releaseDate]
--      ,[TrackId]      
--      ,[artistId]
      --,[title]
--      ,[artistAppearsAs]     
      ,[Image] ImageUrl
	   ,[PlayListName] title
	  ,'' PlayUrl
		,[PlayListId] AlbumId 
		,title AlbumTitle
		,'Top PlayList' ResultType
      ,[expired]      
      ,[GenreId]      
      ,[TotalPlayCount]
  FROM [dbo].[View_PlayList]
  ORDER BY [TotalPlayCount] DESC
END
GO

USE [Music_Streaming]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[usp_getSearchCloseMatchHistory] @p_userCode VARCHAR(255)
	,@p_searchText NVARCHAR(1000)
AS
/*20240305 Created By Mahabubur Rahaman
Change History
Date		Purpose
--------------------

SET STATISTICS TIME ON;
Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchHistory] '8801711090920','S'
Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchDB] 'fix'

Exec [dbo].[spCategoryContentSearchV6.1] 'Talash','S',1, 1
Exec [dbo].[spCategoryContentSearchV6] 'Pirit Koira Kandi Ami','S',1, 1

select dbo.JaccardSimilarity('Voot','28mm')
*/
BEGIN
	DECLARE @searchText NVARCHAR(100) = @p_searchText
	DECLARE @userCode NVARCHAR(100) = @p_userCode

	SET NOCOUNT ON;

	IF object_id('tempdb..#Temp_SearchText') is not null 
	DROP TABLE #Temp_SearchText
		;WITH SplitCTE AS (
		SELECT 
			1 AS StartIndex,
			[value] OriginalText,
			CAST(SUBSTRING(value, 1, 1) AS NVARCHAR(100)) AS ProgressiveText,
			LEN(value) AS Length FROM string_split(@searchText,' ') 

		UNION ALL

		SELECT 
			StartIndex + 1,
			OriginalText,
			CAST(SUBSTRING(OriginalText, 1, StartIndex + 1) AS NVARCHAR(100)) AS ProgressiveText,
			Length 
		FROM 
			SplitCTE
		WHERE 
			StartIndex < Length
		)

	SELECT *
		,COUNT(*) OVER () Cnt
	INTO #Temp_SearchText
	FROM (
		SELECT @searchText value
		
		UNION
		
		--SELECT *
		--FROM STRING_SPLIT(@searchText, ' ')
		--WHERE [value] <> ''
		
		--UNION
		
		SELECT REPLACE(@searchText, ' ', '')

		--UNION 
		--SELECT ProgressiveText FROM SplitCTE -- WHERE LEN(ProgressiveText)>2

		) X;



	;WITH CTE_RecentSearchMatched
	AS (
		SELECT *
			,ROW_NUMBER() OVER (
				PARTITION BY NULL ORDER BY Similarity DESC
				) AS rn
		FROM (
			SELECT DISTINCT 'Hist' Source
				,[VideoId] ContentId
			
				,VideoName ContentName
				,SearchName ContentSearchName
				,Type
				,TIME
				--,dbo.JaccardSimilarity(unique_strings.value, VideoName) Similarity
				,M.Similarity
			FROM dbo.View_UserPlay_Video_History_Indexed his
			CROSS APPLY (
				SELECT *
				FROM #Temp_SearchText
				) AS unique_strings
			CROSS APPLY(
			SELECT CASE 
				WHEN LEN(unique_strings.value) <= 1
					THEN 0
				ELSE dbo.JaccardSimilarity(unique_strings.value, VideoName)
				END as Similarity					
			) AS M
			WHERE UserCode = @userCode
				AND (
					(his.VideoName LIKE '' + unique_strings.value + '%')
					OR (his.SearchName LIKE '' + unique_strings.value + '%')
					)
				AND TIME >= dateadd(dd, - 90, getdate())
			
			UNION ALL
			
			SELECT DISTINCT 'Hist' Source
				,[SongId]
				,SongName
				,SearchName
				,Type
				,TIME
				--,dbo.JaccardSimilarity(unique_strings.value, SongName) Similarity
				,M.Similarity
			FROM dbo.View_UserPlay_Song_History_Indexed his
			CROSS APPLY (
				SELECT *
				FROM #Temp_SearchText
				) AS unique_strings
			CROSS APPLY(
				SELECT CASE 
				WHEN LEN(unique_strings.value) <= 1
					THEN 0
				ELSE dbo.JaccardSimilarity(unique_strings.value, SongName)
				END as Similarity					
			) AS M

			WHERE UserCode = @userCode
				AND (
					(his.SongName LIKE '' + unique_strings.value + '%')
					OR (his.SearchName LIKE  '' + unique_strings.value + '%')
					)
				AND TIME >= dateadd(dd, - 90, getdate())
			
			UNION ALL
			
			SELECT DISTINCT 'Hist' Source
				,[AlbumId]
				,AlbumName
				,SearchName
				,Type
				,TIME
				--,dbo.JaccardSimilarity(unique_strings.value, AlbumName) Similarity
				,M.Similarity
			FROM dbo.View_UserPlay_Album_History_Indexed his
			CROSS APPLY (
				SELECT *
				FROM #Temp_SearchText
				) AS unique_strings
			CROSS APPLY(
				SELECT CASE 
				WHEN LEN(unique_strings.value) <= 1
					THEN 0
				ELSE dbo.JaccardSimilarity(unique_strings.value, AlbumName)
				END as Similarity					
			) AS M
			WHERE UserCode = @userCode
				AND (
					(his.AlbumName LIKE  '' + unique_strings.value + '%')
					OR (his.SearchName LIKE '' + unique_strings.value + '%')
					)
				AND TIME >= dateadd(dd, - 90, getdate())
			
			UNION ALL
			
			SELECT DISTINCT 'Hist' Source
				,[ArtistId]
				,ArtistName
				,SearchName
				,Type
				,TIME
				--,dbo.JaccardSimilarity(unique_strings.value, ArtistName) Similarity
				,M.Similarity
			FROM dbo.View_UserPlay_Artist_History_Indexed his
			CROSS APPLY (
				SELECT *
				FROM #Temp_SearchText
				) AS unique_strings
			CROSS APPLY(
				SELECT CASE 
				WHEN LEN(unique_strings.value) <= 1
					THEN 0
				ELSE dbo.JaccardSimilarity(unique_strings.value, ArtistName)
				END as Similarity					
			) AS M

			WHERE UserCode = @userCode
				AND (
					(his.ArtistName LIKE  '' + unique_strings.value + '%')
					OR (his.SearchName LIKE  '' + unique_strings.value + '%')
					)
				AND TIME >= dateadd(dd, - 90, getdate())
			
			UNION ALL
			
			SELECT DISTINCT 'Hist' Source
				,[PodcastTrackId]
				,PodcastTrackName
				,PodcastTrackSearchName
				,Type
				,TIME
				--,dbo.JaccardSimilarity(unique_strings.value, PodcastTrackSearchName) Similarity
				,M.Similarity
			FROM dbo.View_UserPlay_PodcastTrack_History_Indexed his
			CROSS APPLY (
				SELECT *
				FROM #Temp_SearchText
				) AS unique_strings
			CROSS APPLY(
				SELECT CASE 
				WHEN LEN(unique_strings.value) <= 1
					THEN 0
				ELSE dbo.JaccardSimilarity(unique_strings.value, PodcastTrackSearchName)
				END as Similarity					
			) AS M

			WHERE UserCode = @userCode
				AND (
					(his.PodcastTrackName LIKE '' + unique_strings.value + '%')
					OR (his.PodcastTrackSearchName LIKE ''+ unique_strings.value + '%')
					)
				AND TIME >= dateadd(dd, - 90, getdate())
			
			UNION ALL
			
			SELECT DISTINCT 'Hist' Source
				,[PodcastEpisodeId]
				,PodcastEpisodeName
				,PodcastEpisodeSearchName
				,Type
				,TIME
				--,dbo.JaccardSimilarity(unique_strings.value, PodcastEpisodeSearchName) Similarity
				,M.Similarity
			FROM dbo.View_UserPlay_PodcastEpisode_History_Indexed his
			CROSS APPLY (
				SELECT *
				FROM #Temp_SearchText
				) AS unique_strings
			CROSS APPLY(
				SELECT CASE 
				WHEN LEN(unique_strings.value) <= 1
					THEN 0
				ELSE dbo.JaccardSimilarity(unique_strings.value, PodcastEpisodeSearchName)
				END as Similarity
				) AS M
			WHERE UserCode = @userCode
				AND (
					(his.PodcastEpisodeName LIKE '' + unique_strings.value + '%')
					OR (his.PodcastEpisodeSearchName LIKE '' + unique_strings.value + '%')
					)
				AND TIME >= dateadd(dd, - 90, getdate())
			
			UNION ALL
			
			SELECT DISTINCT 'Hist' Source
				,[PodcastShowId]
				,PodcastShowName
				,PodcastShowSearchName
				,Type
				,TIME
				--,dbo.JaccardSimilarity(unique_strings.value, PodcastShowSearchName) Similarity
				,M.Similarity
			FROM dbo.View_UserPlay_PodcastShow_History_Indexed his
			CROSS APPLY (
				SELECT *
				FROM #Temp_SearchText
				) AS unique_strings
			CROSS APPLY(
				SELECT CASE 
				WHEN LEN(unique_strings.value) <= 1
					THEN 0
				ELSE dbo.JaccardSimilarity(unique_strings.value, PodcastShowSearchName)
				END as Similarity		
				) AS M
			WHERE UserCode = @userCode
				AND (
					(his.PodcastShowName LIKE  '' + unique_strings.value + '%')
					OR (his.PodcastShowSearchName LIKE '' + unique_strings.value + '%')
					)
				AND TIME >= dateadd(dd, - 90, getdate())
			) AS y
		) --select * from CTE_RecentSearchMatch;
	SELECT *
	INTO #GroupedCTEs
	FROM (
		SELECT DISTINCT Source
			,ContentId
			,ContentName
			,type
			,Similarity
			,TIME
			,ROW_NUMBER() OVER (
				PARTITION BY Type ORDER BY Similarity DESC
				) AS group_rn
		FROM (
			SELECT Source
				,ContentId
				,ContentName
				,Type
				,MAX(TIME) TIME
				,MAX(Similarity) Similarity
			FROM CTE_RecentSearchMatched
			GROUP BY Source
				,ContentId
				,ContentName
				,Type
			) AS CombinedCTEs
		) AS GroupedCTEs
	WHERE group_rn <= 5
	ORDER BY group_rn ASC
		,TIME DESC;

	SELECT DISTINCT Source
		,ContentId
		,ContentName
		,type
		,Similarity
		,group_rn
	FROM #GroupedCTEs;
END
GO
USE [Music_Streaming]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[usp_getSearchCloseMatchDB]  	
	@p_searchText NVARCHAR(1000)     
AS    
/*20240307 Created By Mahabubur Rahaman
Change History
Date		Purpose
--------------------

select * from  View_Search where contenttype='A'
SET STATISTICS TIME ON;

Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchDB] 'ta' 
Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchDB] 'pret ' 
Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchDB] 'bhoot.com' 

Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchDB] 'tumi jaio na'
Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchDB] 'tumi robe nirobe'
Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchDB] 'beat the heat'
Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchDB] 'Ekhoni Nambe Brishti'
Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchDB] 'tomar hridoyer kotha'

Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchDB] 'balam'
Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchDB] 'habib'
Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchDB] 'pritom'
Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchDB] 'Cryptic'
Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchDB] 'Tanjib'
Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchDB] 'Mahtim'

Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchDB] 'Artcell'
Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchDB] 'Art cell'
Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchDB] 'cell Art'
Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchDB] 'Warfaze'
Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchDB] 'Feedback'
Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchDB] 'LRB'

Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchDB] 'Jibon Dhara'
Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchDB] 'Ekhoni Nambe Brishti'
Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchDB] 'Rong'
Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchDB] 'Odhora' 
Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchDB] 'Ure Ure' 

Exec [dbo].[spCategoryContentSearchV6.1] 'Pret Chokro','PS',1, 1

Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchHistory] '8801711090920','balam'
Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchDB] 'beat the heat'
Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchDB] 'Tumi Jaio Na'
Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchDB] 'Pirit Koira Kandi Ami'

select * from View_Search where contentSearchName like '%Tumi Jaio Na%'
Exec [dbo].[spCategoryContentSearchV6.1] 'প্রেত চক্র','PS',1, 1
Exec [dbo].[spCategoryContentSearchV6.1] 'Pirit Koira Kandi Ami','S',1, 1
Exec [dbo].[spCategoryContentSearchV6] 'Pirit Koira Kandi Ami','S',1, 1

select dbo.JaccardSimilarity('Voot','28mm')

select * from View_Search where contentsearchname like '%t%'
*/
BEGIN
	DECLARE @searchText NVARCHAR(100) = @p_searchText

	SET NOCOUNT ON

	IF object_id('tempdb..#Temp_SearchText') IS NOT NULL
		DROP TABLE #Temp_SearchText

		;WITH SplitCTE AS (
		SELECT 
			1 AS StartIndex,
			[value] OriginalText,
			CAST(SUBSTRING(value, 1, 1) AS NVARCHAR(100)) AS ProgressiveText,
			LEN(value) AS Length FROM (select * from string_split(@searchText,' ') union select @searchText ) as a

		UNION ALL

		SELECT 
			StartIndex + 1,
			OriginalText,
			CAST(SUBSTRING(OriginalText, 1, StartIndex + 1) AS NVARCHAR(100)) AS ProgressiveText,
			Length 
		FROM 
			SplitCTE
		WHERE 
			StartIndex < Length
		)

	SELECT *
		,COUNT(*) OVER () Cnt
	INTO #Temp_SearchText
	FROM (
		SELECT @searchText value
		
		UNION
		
		--SELECT *
		--FROM STRING_SPLIT(@searchText, ' ')
		--WHERE [value] <> ''
		
		--UNION
		
		SELECT REPLACE(@searchText, ' ', '')

		UNION 
		SELECT ProgressiveText FROM SplitCTE  Where LEN(ProgressiveText)>2

		) X;
	
--select * from #Temp_SearchText

	;WITH CTE_DBMatched
	AS (
		SELECT *			
		FROM (
			SELECT 'DB' Source
				,ContentId
				,ContentName
				,ContentSearchName
				,unique_strings.value SearchKey
				,ContentType Type
				,Getdate() TIME
				--,dbo.JaccardSimilarity(unique_strings.value, ContentSearchName) Similarity
				,M.Similarity
				,group_rn [Rank]
			FROM View_Search
			CROSS APPLY (
				SELECT *
				FROM #Temp_SearchText
				) AS unique_strings
			CROSS APPLY(
					SELECT CASE 
						WHEN LEN(unique_strings.value) <= 1
							THEN 0
						ELSE dbo.JaccardSimilarity(unique_strings.value, ContentSearchName)
						END as Similarity					
				) AS M
			WHERE ([ContentSearchName] LIKE '' + unique_strings.value + '%') --AND Similarity>0
			) AS x
		) --select * from CTE_DBMatched;


	SELECT *
	INTO #GroupedCTEs
	FROM (
		SELECT DISTINCT Source
			,ContentId
			,ContentName
			,type
			,ContentSearchName
			,SearchKey
			,Similarity
			,[Rank]
		FROM (
			SELECT Source
				,ContentId
				,ContentName
				,Type
				,ContentSearchName
				,SearchKey
				,MAX(TIME) TIME
				,MAX(Similarity) Similarity
				,[Rank]
			FROM CTE_DBMatched
			GROUP BY Source
				,ContentId
				,ContentName
				,Type
				,ContentSearchName
				,SearchKey
				,[Rank]
				-- Add other CTEs as needed
			) AS CombinedCTEs
		) AS GroupedCTEs	
	ORDER BY Source DESC
		,Similarity DESC;

	;WITH cte_top_rank as (
	SELECT DISTINCT TOP 5 Source
		,ContentId
		,ContentSearchName ContentName
		,type
		,Max(Similarity) Similarity
		,[Rank] group_rn
	FROM #GroupedCTEs cte	
	GROUP BY Source,ContentId
		,ContentSearchName
		,type 
		,[Rank]
	ORDER BY group_rn ASC)
	,
	cte_top_similarity as (
	SELECT DISTINCT TOP 5 Source
		,ContentId
		,ContentSearchName ContentName
		,type
		,Max(Similarity) Similarity
		,[Rank] group_rn
	FROM #GroupedCTEs cte		
	WHERE ContentSearchName like ''+ @searchText+'%'		
	GROUP BY Source,ContentId
		,ContentSearchName
		,type 
		,[Rank]
	ORDER BY Similarity DESC)

	SELECT top 1 * FROM cte_top_rank where type='A' 
	UNION
	SELECT top 1 * FROM cte_top_similarity 
	WHERE NOT EXISTS(select top 1 * from cte_top_rank where type='A')
	UNION
	SELECT top 1 Source
		,ContentId
		,ContentSearchName ContentName
		,type
		,Max(Similarity) Similarity
		,[Rank] group_rn FROM #GroupedCTEs cte
	WHERE NOT EXISTS(
		SELECT top 1 * FROM cte_top_similarity 
	WHERE NOT EXISTS(select * from cte_top_rank where type='A'))
	GROUP BY Source,ContentId
		,ContentSearchName
		,type 
		,[Rank]
	ORDER BY Similarity DESC

END
GO

USE [Music_Streaming]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*20240319 Created By Mahabubur Rahaman
Change History
Date		Purpose
--------------------

SET STATISTICS TIME ON
Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchHistory] '8801717230976','Tumi Jaio Na'
Exec [Music_Streaming].[dbo].[spCategoryContentSearchV6.1] 'Gobhire Nami','V',1, 1

Exec [Music_Streaming].[dbo].[usp_getSearchCloseMatchDB] 'Tumi Jaio Na'
Exec [dbo].[spCategoryContentSearchV6.1] 'Tumi Jaio Na','S',1, 1
Exec [dbo].[spCategoryContentSearchV6.1] 'pret','PS',1, 1
Exec [dbo].[spCategoryContentSearchV6] 'Pirit Koira Kandi Ami','S',1, 1
Exec [dbo].[spCategoryContentSearchV6.1] 'Habib ''','A',1, 1

Exec [Music_Streaming].[dbo].[spCategoryContentSearchV6.1] 'Beat the Heat','P',1, 1

select *  FROM View_ASongs where title like '%Tumi Jaio Na%'
*/
ALTER PROCEDURE [dbo].[spCategoryContentSearchV6.1] @p_searchText NVARCHAR(1000)
	,@p_contentType VARCHAR(50)
	,@client INT = 1
	,@countryValue INT =1
AS

--R: Album
--S : Audio Song(Track)
--A: Artist
--V: Video
--PS: PodcastShow
--PE: PodcastEpisode
--PT: PodcastTrack

BEGIN
	DECLARE @searchText NVARCHAR(1000) = @p_searchText
		,@contentType VARCHAR(50) = @p_contentType
		
		--ToDo : 
		--Remove special characters from the search text
		--Breakdown search text into possible words if it is specified without spaces

	SET NOCOUNT ON
	
	IF object_id('tempdb..#Temp_SearchText') is not null 
	DROP TABLE #Temp_SearchText
	
	;WITH SplitCTE AS (
		SELECT 
			1 AS StartIndex,
			[value] OriginalText,
			CAST(SUBSTRING(value, 1, 1) AS NVARCHAR(100)) AS ProgressiveText,
			LEN(value) AS Length FROM (select * from string_split(@searchText,' ') union select @searchText ) as a

		UNION ALL

		SELECT 
			StartIndex + 1,
			OriginalText,
			CAST(SUBSTRING(OriginalText, 1, StartIndex + 1) AS NVARCHAR(100)) AS ProgressiveText,
			Length 
		FROM 
			SplitCTE
		WHERE 
			StartIndex < Length
		)

	SELECT *
		,COUNT(*) OVER () Cnt
	INTO #Temp_SearchText
	FROM (
		SELECT @searchText value
		
		UNION
		
		SELECT *
		FROM STRING_SPLIT(@searchText, ' ')
		WHERE [value] <> ''
		
		UNION
		
		SELECT REPLACE(@searchText, ' ', '')

		UNION 
		SELECT ProgressiveText FROM SplitCTE Where LEN(ProgressiveText)>2

		) X;

	--SELECT *
	--,COUNT(*) OVER () Cnt
	--INTO #Temp_SearchText
	--FROM (
	--	SELECT @searchText value		
	--	UNION		
	--	SELECT *
	--	FROM STRING_SPLIT(@searchText, ' ')
	--	WHERE [value] <> ''		
	--	UNION		
	--	SELECT REPLACE(@searchText, ' ', '')
	--) X

	IF @contentType = 'R'
	BEGIN

		If object_id('tempdb..#Temp_TopAlbums') is not null 
		Drop table #Temp_TopAlbums
		
		SELECT DISTINCT --TOP (100) 
					id
					,ImageUrl
					,title
					,[Type]
					,ContentType
					,PlayUrl
					,artist
					,artistId
					,duration
					,IsPaid
					,Seekable
					,TrackType
					,releaseDate
					,AlbumId
					,AlbumTitle
					,unique_strings.value				
					,M.Similarity
		INTO #Temp_TopAlbums
		FROM View_Albums
		CROSS APPLY (
			SELECT *
			FROM #Temp_SearchText
			) AS unique_strings
		CROSS APPLY(
			SELECT CASE 
				WHEN LEN(unique_strings.value) = 1
					THEN 0
				ELSE dbo.JaccardSimilarity(unique_strings.value, title)
				END as Similarity					
		) AS M
		WHERE (
				title LIKE  '' + unique_strings.value + '%'
				) AND Similarity>0
		ORDER BY Similarity DESC
		--) 
		--select * from #Temp_TopAlbums

		;WITH CTE_TopResult
	AS (
		SELECT TOP 1 * FROM (
		SELECT DISTINCT TOP 1 0 SL, *
		FROM #Temp_TopAlbums
		WHERE title=@searchText
		UNION ALL
		SELECT DISTINCT TOP 1 1 SL, *
		FROM #Temp_TopAlbums
		WHERE title!=@searchText
		ORDER BY Similarity DESC) X
		ORDER BY SL ASC
		) --select * from CTE_TopResult;

		,CTE_TopResultGenre 
	AS (		
			SELECT
				g.Id,g.GenreName
			FROM
				dbo.tbl_Artist A
			CROSS APPLY
				OPENJSON(A.GenreIds) AS s
			JOIN
				Genre g ON g.id = s.value
			where A.id=(SELECT artistId FROM CTE_TopResult )
		) --select * from CTE_TopResultGenre;

		,CTE_MostPopularInAlbum
	AS (
		SELECT DISTINCT TOP 10 id
			,'R' ContentType
			,artistId
			,artist
			,ImageUrl
			,title
			,PlayUrl
			,releaseId AlbumId
			,'' AlbumTitle
			,'Most Popular' ResultType
		FROM dbo.View_ASongs
		WHERE releaseId = (
				SELECT AlbumId
				FROM CTE_TopResult
				)
		) --select * from CTE_MostPopularInAlbum

		,CTE_MostPopularRelevant
	AS (
		SELECT DISTINCT TOP 10 *
		FROM #Temp_TopAlbums
		ORDER BY Similarity DESC
		) --select * from CTE_MostPopularRelevant;

		,CTE_Albums
	AS (
		SELECT DISTINCT TOP 10 R.*
			,unique_strings.value SearchKey
			,M.Similarity
		FROM dbo.View_Albums AS R WITH (NOLOCK)
		CROSS APPLY (
			SELECT *
			FROM #Temp_SearchText
			) AS unique_strings
		CROSS APPLY(
			SELECT CASE 
				WHEN LEN(unique_strings.value) = 1
					THEN 0
				ELSE dbo.JaccardSimilarity(unique_strings.value, title)
				END as Similarity					
		) AS M
		WHERE (
				R.title LIKE CASE 
					WHEN LEN(unique_strings.value) = 1
						THEN ''
					ELSE ''
					END + unique_strings.value + '%'
				) AND Similarity>0
		ORDER BY M.Similarity DESC
		) --select * from CTE_Albums;

		,CTE_PlayList
	AS (
		SELECT DISTINCT TOP 10 P.*,'P' ContentType
			,unique_strings.value SearchKey
			,M.Similarity
		FROM dbo.View_Playlist AS P WITH (NOLOCK)
		CROSS APPLY (
			SELECT *
			FROM #Temp_SearchText
			) AS unique_strings
		CROSS APPLY(
			SELECT CASE 
				WHEN LEN(unique_strings.value) = 1
					THEN 0
				ELSE dbo.JaccardSimilarity(unique_strings.value, title)
				END as Similarity					
		) AS M
		WHERE (
				P.title LIKE CASE 
					WHEN LEN(unique_strings.value) = 1
						THEN ''
					ELSE ''
					END + unique_strings.value + '%'
				) AND Similarity>0
		ORDER BY M.Similarity DESC
		) --select * from CTE_PlayList;

	,CTE_TopArtist
	AS (
		SELECT DISTINCT TOP 20
		id
		,'A' Type
		,id artistId
		,name artist
		,image ImageUrl
		,name title
		,'' PlayUrl
		,follower as AlbumId
		,'' AlbumName
		, ROW_NUMBER() OVER(ORDER BY follower DESC) as SL
		,'A' ContentType
		,follower
		FROM dbo.tbl_Artist AS A WITH (NOLOCK)
		CROSS APPLY
				(SELECT top 1 * from OPENJSON(A.GenreIds)) AS s
		WHERE s.value IN (SELECT TOP 1 Id FROM CTE_TopResultGenre)
		AND A.id != (SELECT top 1 artistId FROM CTE_TopResult )
		UNION
		SELECT DISTINCT TOP 20
		id
		,'A' Type
		,id artistId
		,name artist
		,image ImageUrl
		,name title
		,'' PlayUrl
		,follower as AlbumId
		,'' AlbumName
		, ROW_NUMBER() OVER(ORDER BY follower DESC) as SL
		,'A' ContentType
		,follower
		FROM dbo.tbl_Artist AS A WITH (NOLOCK)
		CROSS APPLY
				(select A.GenreIds g) AS s
		WHERE ISNULL(A.GenreIds,'') != ''
		AND NOT EXISTS(SELECT TOP 1 Id FROM CTE_TopResultGenre)
		AND A.id != (SELECT top 1 artistId FROM CTE_TopResult )
		UNION
		SELECT DISTINCT TOP 20 
		id
		,'A' Type
		,id artistId
		,name artist
		,image ImageUrl
		,name title
		,'' PlayUrl
		,follower as AlbumId
		,'' AlbumName
		, ROW_NUMBER() OVER(ORDER BY follower DESC) as SL
		,'A' ContentType
		,follower
		FROM dbo.tbl_Artist AS A WITH (NOLOCK)
		CROSS APPLY (
			SELECT *
			FROM #Temp_SearchText
			) AS unique_strings
		WHERE (
				A.name LIKE '' + unique_strings.value + '%'
				)
		AND A.id != (SELECT top 1 artistId FROM CTE_TopResult )
		ORDER BY SL ASC
		) --select *from CTE_TopArtist;

	SELECT DISTINCT TOP 10 id
		,ContentType
		,artistId
		,artist
		,ImageUrl
		,title
		,PlayUrl
		,AlbumId
		,AlbumTitle
		,'Top Result' ResultType
	FROM CTE_TopResult

	UNION ALL

	SELECT TOP 10 * FROM (
		SELECT DISTINCT TOP 10 id
			,ContentType
			,artistId
			,artist
			,ImageUrl
			,title
			,PlayUrl
			,AlbumId 
			,AlbumTitle
			,'Most Popular' ResultType
		FROM CTE_MostPopularInAlbum
		WHERE id NOT IN (
				SELECT ID
				FROM CTE_TopResult
				)
	
		UNION ALL

		SELECT DISTINCT TOP 10 id
			,ContentType
			,artistId
			,artist
			,ImageUrl
			,title
			,PlayUrl
			,AlbumId
			,AlbumTitle
			,'Most Popular' ResultType
		FROM CTE_MostPopularRelevant
		WHERE id != (SELECT TOP 1 ID FROM CTE_TopResult)
		
		) AS MP

	UNION ALL

	SELECT DISTINCT TOP 10 id
		,ContentType
		,artistId
		,artist
		,ImageUrl
		,title
		,PlayUrl
		,id
		,title
		,'Albums' ResultType
	FROM CTE_Albums

	UNION ALL

	SELECT DISTINCT TOP 10 PlayListId
		,ContentType
		,artistId
		,artistAppearsAs artist
		,Image ImageUrl
		,title
		,StreamUrl PlayUrl
		,ReleaseId 
		,PlaylistName  ReleaseTitle
		,'Playlists' ResultType
	FROM CTE_PlayList

	UNION ALL

	SELECT * FROM (SELECT DISTINCT TOP 200  id
		,ContentType
		,id artistId
		, artist
		, ImageUrl
		,title
		,'' PlayUrl
		,follower as AlbumId
		, AlbumName
		,'Artists To Follow' ResultType
	FROM CTE_TopArtist ORDER BY follower DESC) AS art;

	END
	ELSE IF @contentType = 'S'
	BEGIN

	If object_id('tempdb..#Temp_AudioSongs') is not null 
	Drop table #Temp_AudioSongs
	
	SELECT DISTINCT --TOP (30) 
					id
					,ImageUrl
					,title
					,[Type]
					,ContentType
					,PlayUrl
					,artist
					,artistId
					,duration
					,IsPaid
					,Seekable
					,IsPaid1
					,Seekable1
					,TrackType
					,RN
					,releaseDate
					,AlbumId
					,AlbumTitle
					,unique_strings.value
					,M.Similarity 	
					,TotalPlayCount
		INTO #Temp_AudioSongs
		FROM View_ASongs
		CROSS APPLY (
			SELECT *
			FROM #Temp_SearchText
			) AS unique_strings
		CROSS APPLY(
			SELECT CASE 
				WHEN LEN(unique_strings.value) = 1
					THEN 0
				ELSE dbo.JaccardSimilarity(unique_strings.value, title)
				END as Similarity					
		) AS M
		WHERE (
				title LIKE  '' + unique_strings.value + '%'
				) AND Similarity>0
		ORDER BY M.Similarity,TotalPlayCount DESC		
	
	--select * from #Temp_AudioSongs

	;WITH CTE_TopResult
	AS (
		SELECT TOP 1 * FROM (
		SELECT DISTINCT TOP 1 0 SL, *
		FROM #Temp_AudioSongs
		WHERE title=@searchText
		ORDER BY TotalPlayCount DESC
		UNION ALL
		SELECT DISTINCT TOP 1 1 SL, *
		FROM #Temp_AudioSongs
		WHERE title!=@searchText
		ORDER BY TotalPlayCount DESC) X
		ORDER BY SL ASC
		) --select * from CTE_TopResult;

		,CTE_TopResultGenre 
	AS (		
			SELECT
				g.Id,g.GenreName
			FROM
				dbo.tbl_Artist A
			CROSS APPLY
				OPENJSON(A.GenreIds) AS s
			JOIN
				Genre g ON g.id = s.value
			where A.id=(SELECT artistId FROM CTE_TopResult )
		) --select * from CTE_TopResultGenre;

		,CTE_MostPopularInAlbum
	AS (
		SELECT DISTINCT TOP 10 id
			,'S' ContentType
			,artistId
			,artist
			,ImageUrl
			,title
			,PlayUrl 
			,AlbumId
			,AlbumTitle
			,'Most Popular' ResultType
		FROM dbo.View_ASongs
		WHERE releaseId = (
				SELECT AlbumId
				FROM CTE_TopResult
				)
		) --select * from CTE_MostPopularInAlbum

		,CTE_MostPopularRelevant
	AS (
		SELECT DISTINCT TOP 10 *
		FROM #Temp_AudioSongs
		ORDER BY TotalPlayCount,Similarity DESC
		) --select * from CTE_MostPopularRelevant;

		,CTE_Albums
	AS (
		SELECT DISTINCT TOP 10 R.*
			--,'R' ContentType
			,unique_strings.value SearchKey
			,M.Similarity
		FROM dbo.View_Albums AS R WITH (NOLOCK)
		CROSS APPLY (
			SELECT *
			FROM #Temp_SearchText
			) AS unique_strings
		CROSS APPLY(
			SELECT CASE 
				WHEN LEN(unique_strings.value) = 1
					THEN 0
				ELSE dbo.JaccardSimilarity(unique_strings.value, title)
				END as Similarity					
		) AS M
		WHERE (
				R.title LIKE CASE 
					WHEN LEN(unique_strings.value) = 1
						THEN ''
					ELSE ''
					END + unique_strings.value + '%'
				) AND Similarity>0
		ORDER BY M.Similarity DESC
		) --select * from CTE_Albums;

		,CTE_PlayList
	AS (
		SELECT DISTINCT TOP 10 P.*
			,'P' ContentType
			,unique_strings.value SearchKey
			,M.Similarity
		FROM dbo.View_Playlist AS P WITH (NOLOCK)
		CROSS APPLY (
			SELECT *
			FROM #Temp_SearchText
			) AS unique_strings
		CROSS APPLY(
			SELECT CASE 
				WHEN LEN(unique_strings.value) = 1
					THEN 0
				ELSE dbo.JaccardSimilarity(unique_strings.value, title)
				END as Similarity					
		) AS M
		WHERE (
				P.title LIKE CASE 
					WHEN LEN(unique_strings.value) = 1
						THEN ''
					ELSE ''
					END + unique_strings.value + '%'
				) AND Similarity>0
		ORDER BY M.Similarity DESC
		) --select * from CTE_PlayList;

		,CTE_TopArtist
	AS (
		SELECT DISTINCT TOP 20
		id
		,'A' Type
		,id artistId
		,name artist
		,image ImageUrl
		,name title
		,'' PlayUrl
		,follower as AlbumId
		,'' AlbumName
		, ROW_NUMBER() OVER(ORDER BY follower DESC) as SL
		,'A' ContentType
		,follower
		FROM dbo.tbl_Artist AS A WITH (NOLOCK)
		CROSS APPLY
				(SELECT top 1 * from OPENJSON(A.GenreIds)) AS s
		WHERE s.value IN (SELECT TOP 1 Id FROM CTE_TopResultGenre)
		AND A.id != (SELECT top 1 artistId FROM CTE_TopResult )
		UNION
		SELECT DISTINCT TOP 20
		id
		,'A' Type
		,id artistId
		,name artist
		,image ImageUrl
		,name title
		,'' PlayUrl
		,follower as AlbumId
		,'' AlbumName
		, ROW_NUMBER() OVER(ORDER BY follower DESC) as SL
		,'A' ContentType
		,follower
		FROM dbo.tbl_Artist AS A WITH (NOLOCK)
		CROSS APPLY
				(select A.GenreIds g) AS s
		WHERE ISNULL(A.GenreIds,'') != ''
		AND NOT EXISTS(SELECT TOP 1 Id FROM CTE_TopResultGenre)
		AND A.id != (SELECT top 1 artistId FROM CTE_TopResult )
		UNION
		SELECT DISTINCT TOP 20 
		id
		,'A' Type
		,id artistId
		,name artist
		,image ImageUrl
		,name title
		,'' PlayUrl
		,follower as AlbumId
		,'' AlbumName
		, ROW_NUMBER() OVER(ORDER BY follower DESC) as SL
		,'A' ContentType
		,follower
		FROM dbo.tbl_Artist AS A WITH (NOLOCK)
		CROSS APPLY (
			SELECT *
			FROM #Temp_SearchText
			) AS unique_strings
		WHERE (
				A.name LIKE '' + unique_strings.value + '%'
				)
		AND A.id != (SELECT top 1 artistId FROM CTE_TopResult )
		ORDER BY SL ASC
		)  -- select *from CTE_TopArtist;

	SELECT DISTINCT TOP 10 id
		,ContentType
		,artistId
		,artist
		,ImageUrl
		,title
		,PlayUrl
		,AlbumId
		,AlbumTitle
		,'Top Result' ResultType
	FROM CTE_TopResult

	UNION ALL

	SELECT TOP 10 * FROM (
		SELECT DISTINCT TOP 10 id
			,ContentType
			,artistId
			,artist
			,ImageUrl
			,title
			,PlayUrl
			,AlbumId 
			,AlbumTitle
			,'Most Popular' ResultType
		FROM CTE_MostPopularInAlbum
		WHERE id != (SELECT TOP 1 ID FROM CTE_TopResult)
		--WHERE id NOT IN (
		--		SELECT ID
		--		FROM CTE_TopResult
		--		)
	
		UNION ALL

		SELECT DISTINCT TOP 10 id
			,ContentType
			,artistId
			,artist
			,ImageUrl
			,title
			,PlayUrl
			,AlbumId
			,AlbumTitle
			,'Most Popular' ResultType
		FROM CTE_MostPopularRelevant
		WHERE id != (SELECT TOP 1 ID FROM CTE_TopResult)
		
		) AS MP

	UNION ALL

	SELECT DISTINCT TOP 10 id
		,ContentType
		,artistId
		,artist
		,ImageUrl
		,title
		,PlayUrl
		,id
		,title
		,'Albums' ResultType
	FROM CTE_Albums

	UNION ALL

	SELECT DISTINCT TOP 10 PlayListId
		,ContentType
		,artistId
		,artistAppearsAs
		,Image ImageUrl
		,title
		,streamUrl PlayUrl
		,PublishId
		,PlayListName
		,'Playlists' ResultType
	FROM CTE_PlayList

	UNION ALL

	SELECT * FROM (SELECT DISTINCT TOP 200  id
		,ContentType
		,id artistId
		, artist
		, ImageUrl
		, title
		,'' PlayUrl
		,follower as AlbumId
		,'' AlbumName
		,'Artists To Follow' ResultType
	FROM CTE_TopArtist ORDER BY follower DESC) AS art;

	END
	ELSE IF @contentType = 'A'
	BEGIN

		If object_id('tempdb..#Temp_Artist') is not null 
		Drop table #Temp_Artist

		SELECT DISTINCT --TOP (30) 
				id
				,A.IMAGE AS ImageUrl
				,A.name AS title
				,'A' AS [Type]
				,'A' AS ContentType
				,'' AS PlayUrl
				,A.name AS artist
				,A.id AS artistId
				,'' AS duration
				,0 AS IsPaid
				,0 AS Seekable
				,0 AS IsPaid1
				,0 AS Seekable1
				,NULL AS TrackType
				,1 AS RN
				,follower
				,unique_strings.value				
				,M.Similarity
				,GenreIds
	INTO #Temp_Artist
	FROM dbo.tbl_Artist AS A WITH (NOLOCK)
	CROSS APPLY (
		SELECT *
		FROM #Temp_SearchText
		) AS unique_strings
	CROSS APPLY(
			SELECT CASE 
				WHEN LEN(unique_strings.value) = 1
					THEN 0
				ELSE dbo.JaccardSimilarity(unique_strings.value, Name)
				END as Similarity					
		) AS M
	WHERE (A.[name] LIKE '' + unique_strings.value + '%') AND Similarity>0
	ORDER BY Similarity DESC, follower DESC

	;WITH CTE_TopResult
	AS (
		SELECT TOP 1 * FROM (
		SELECT DISTINCT TOP 1 0 SL, *
		FROM #Temp_Artist
		WHERE title=@searchText
		UNION ALL
		SELECT DISTINCT TOP 1 1 SL, *
		FROM #Temp_Artist
		WHERE title!=@searchText
		ORDER BY Similarity DESC,follower DESC) X
		ORDER BY SL ASC
		)-- select * from CTE_TopResult;

		,CTE_TopResultGenre 
	AS (		
			SELECT
				g.Id,g.GenreName
			FROM
				dbo.tbl_Artist A
			CROSS APPLY
				OPENJSON(A.GenreIds) AS s
			JOIN
				Genre g ON g.id = s.value
			where A.id=(SELECT artistId FROM CTE_TopResult )
		) --select * from CTE_TopResultGenre;

		,CTE_MostPopularSongsOfArtist
	AS (
		SELECT DISTINCT TOP 10 id
			,'S' ContentType
			,artistId
			,artist
			,ImageUrl
			,title
			,PlayUrl
			,TotalPlayCount
			,AlbumId
			,AlbumTitle
			,'MostPopular' ResultType
		FROM View_ASongs
		--FROM dbo.tbl_Track_Batch
		WHERE artistId = (
				SELECT artistId
				FROM CTE_TopResult
				)
		ORDER BY TotalPlayCount DESC
		) --select * from CTE_MostPopularSongsOfArtist

	,CTE_MostPopularSingleTrack
	AS (
		SELECT DISTINCT TOP 10 id
			,'S' ContentType
			,artistId
			,artist
			,ImageUrl
			,title
			,PlayUrl
			,TotalPlayCount
			,AlbumId
			,AlbumTitle
			,releaseDate
			,'MostPopular' ResultType
		FROM View_ASongs
		--FROM dbo.tbl_Track_Batch
		WHERE artistId = (
				SELECT artistId
				FROM CTE_TopResult
				)
		ORDER BY releaseDate DESC
		) --select * from CTE_MostPopularSingleTrack;

		,CTE_Albums
	AS (
		SELECT DISTINCT TOP 10 *
		--,'R' ContentType
		FROM dbo.View_Albums AS R WITH (NOLOCK)
		WHERE artistId = (
				SELECT artistId
				FROM CTE_TopResult
				)
		ORDER BY releaseDate DESC
		) --select * from CTE_Albums;

		,CTE_PlayList
	AS (
		SELECT DISTINCT TOP 10 PublishId,PlayListId
		,'P' ContentType
		,cte.artistId
		,p.artistAppearsAs
		,Image
		,PlayListName
		,streamUrl		
		,MAX(ReleaseDate) ReleaseDate
		,SUM(TotalPlayCount) TotalPlayCount
		FROM dbo.View_PlayList AS P WITH (NOLOCK)
		INNER JOIN CTE_TopResult cte ON cte.artistId=p.artistId	
		GROUP BY PublishId,PlayListId,cte.artistId,p.artistAppearsAs,Image,PlayListName,streamUrl
		ORDER BY SUM(TotalPlayCount) DESC		
		) --select * from CTE_PlayList;

		,CTE_TopArtist
	AS (
		SELECT DISTINCT TOP 20
		id
		,'A' Type
		,id artistId
		,name artist
		,image ImageUrl
		,name title
		,'' PlayUrl
		,follower as AlbumId
		,'' AlbumName
		, ROW_NUMBER() OVER(ORDER BY follower DESC) as SL
		,'A' ContentType
		,follower
		FROM dbo.tbl_Artist AS A WITH (NOLOCK)
		CROSS APPLY
				(SELECT top 1 * from OPENJSON(A.GenreIds)) AS s
		WHERE s.value IN (SELECT TOP 1 Id FROM CTE_TopResultGenre)
		AND A.id != (SELECT top 1 artistId FROM CTE_TopResult )
		UNION
		SELECT DISTINCT TOP 20
		id
		,'A' Type
		,id artistId
		,name artist
		,image ImageUrl
		,name title
		,'' PlayUrl
		,follower as AlbumId
		,'' AlbumName
		, ROW_NUMBER() OVER(ORDER BY follower DESC) as SL
		,'A' ContentType
		,follower
		FROM dbo.tbl_Artist AS A WITH (NOLOCK)
		CROSS APPLY
				(select A.GenreIds g) AS s
		WHERE ISNULL(A.GenreIds,'') != ''
		AND NOT EXISTS(SELECT TOP 1 Id FROM CTE_TopResultGenre)
		AND A.id != (SELECT top 1 artistId FROM CTE_TopResult )
		UNION
		SELECT DISTINCT TOP 20 
		id
		,ContentType
		,id artistId
		,artist
		,ImageUrl
		,title
		,'' PlayUrl
		,follower as AlbumId
		,'' AlbumName
		, ROW_NUMBER() OVER(ORDER BY follower DESC) as SL
		,'A' ContentType
		,follower
		FROM #Temp_Artist AS A WITH (NOLOCK)
		WHERE A.id != (SELECT top 1 artistId FROM CTE_TopResult )
		ORDER BY SL ASC
		) --select *from CTE_TopArtist;


	SELECT DISTINCT TOP 10 id
		,ContentType
		,artistId
		,artist
		,ImageUrl
		,title
		,PlayUrl 
		,follower AlbumId
		,'' AlbumTitle
		,'Top Result' ResultType
	FROM CTE_TopResult

	UNION ALL

	SELECT TOP 10 * FROM (
		SELECT DISTINCT TOP 10 id
			,ContentType
			,artistId
			,artist
			,ImageUrl
			,title
			,PlayUrl
			,AlbumId 
			,AlbumTitle
			,'Most Popular' ResultType
		FROM CTE_MostPopularSongsOfArtist
		WHERE id NOT IN (
				SELECT ID
				FROM CTE_TopResult
				)	
		
		) AS MP
	
	UNION ALL

	SELECT DISTINCT TOP 10 PlayListId
		,ContentType
		,artistId
		,artistAppearsAs
		,Image
		,PlayListName
		,streamUrl
		,PublishId
		,PlayListName
		,'Featuring' ResultType
	FROM CTE_PlayList

	UNION ALL

	SELECT DISTINCT TOP 10 id
		,ContentType
		,artistId
		,artist
		,ImageUrl
		,title
		,PlayUrl
		,id
		,title
		,'Albums' ResultType
	FROM CTE_Albums

	UNION ALL

	SELECT DISTINCT TOP 10 id
		,ContentType
		,artistId
		,artist
		,ImageUrl
		,title
		,PlayUrl
		,AlbumId
		,AlbumTitle
		,'Singles' ResultType
	FROM CTE_MostPopularSingleTrack
	WHERE id != (SELECT TOP 1 ID FROM CTE_TopResult)

	UNION ALL

	SELECT * FROM (SELECT DISTINCT TOP 200  id
		,ContentType
		,id artistId
		, artist
		, ImageUrl
		,title
		,'' PlayUrl
		,follower as AlbumId
		,'' AlbumName
		,'Artists To Follow' ResultType
	FROM CTE_TopArtist 
	WHERE id != (SELECT TOP 1 ID FROM CTE_TopResult)
	ORDER BY follower DESC) AS art;

	END
	ELSE IF @contentType = 'V'
	BEGIN
		If object_id('tempdb..#Temp_Videos') is not null 
		Drop table #Temp_Videos

		SELECT DISTINCT  id
			,ImageUrl
			,title
			,[Type]
			,ContentType
			,PlayUrl
			,artist
			,artistId
			,duration
			,IsPaid
			,Seekable
			,[TrackType]
			,AlbumId
			,AlbumTitle
			,releaseDate
			,GenreId
			,GenreName
			,unique_strings.value
			,M.Similarity			
		INTO #Temp_Videos
		FROM View_VSongs
		CROSS APPLY (
			SELECT *
			FROM #Temp_SearchText
			) AS unique_strings
		CROSS APPLY(
			SELECT CASE 
				WHEN LEN(unique_strings.value) = 1
					THEN 0
				ELSE dbo.JaccardSimilarity(unique_strings.value, title)
				END as Similarity					
		) AS M
		WHERE (title LIKE '' + unique_strings.value + '%') AND Similarity>0
		ORDER BY Similarity DESC 
		
		;WITH CTE_TopResult
	AS (
		SELECT TOP 1 * FROM (
		SELECT DISTINCT TOP 1 0 SL, *
		FROM #Temp_Videos
		WHERE title=@searchText
		UNION ALL
		SELECT DISTINCT TOP 1 1 SL, *
		FROM #Temp_Videos
		WHERE title!=@searchText
		ORDER BY Similarity DESC) X
		ORDER BY SL ASC
		)
		,CTE_TopResultGenre 
	AS (		
			SELECT
				g.Id,g.GenreName
			FROM
				dbo.tbl_Artist A
			CROSS APPLY
				STRING_SPLIT(A.GenreIds, ',') AS s
			JOIN
				Genre g ON g.id = CAST(REPLACE(REPLACE(REPLACE(s.value,'[',''),']',''),'"','') AS INT)
			where A.id=(SELECT artistId FROM CTE_TopResult )
		) --select * from CTE_TopResultGenre;	
		,CTE_MostPopularRelevant
	AS (
		SELECT DISTINCT TOP 10 *
		FROM #Temp_Videos
		ORDER BY Similarity DESC
		) --select * from CTE_MostPopularRelevant;

		,CTE_LatestReleased
	AS (
		SELECT DISTINCT TOP 10 *
		FROM #Temp_Videos
		ORDER BY [ReleaseDate] DESC
		) --select * from CTE_LatestReleased;
		,CTE_MovieBlockBusters
	AS (
		SELECT DISTINCT TOP 10 *		
		FROM View_VSongs
		WHERE (Genrename like '%Movie Song%')
		ORDER BY [ReleaseDate] DESC
		) --select * from CTE_MovieBlockBusters;

	,CTE_DramaBuzz
	AS (
		SELECT DISTINCT TOP 10 *		
		FROM View_VSongs
		WHERE (genrename like '%Drama%')
		ORDER BY [releaseDate] DESC
		) --select * from CTE_DramaBuzz;
	

	SELECT DISTINCT TOP 1 id
		,ContentType
		,artistId
		,artist
		,ImageUrl
		,title
		,PlayUrl
		,AlbumId
		,AlbumTitle
		,'Top Result' ResultType
	FROM CTE_TopResult

	UNION ALL

	SELECT DISTINCT TOP 10 id
		,ContentType
		,artistId
		,artist
		,ImageUrl
		,title
		,PlayUrl
		,AlbumId
		,AlbumTitle
		,'Most Popular' ResultType
	FROM CTE_MostPopularRelevant
	WHERE id !=(SELECT TOP 1 ID FROM CTE_TopResult)

	UNION ALL

	SELECT DISTINCT TOP 10 id
		,ContentType
		,artistId
		,artist
		,ImageUrl
		,title
		,PlayUrl
		,id
		,title
		,'Latest Releases' ResultType
	FROM CTE_LatestReleased

	UNION ALL

	SELECT DISTINCT TOP 10 id
		,ContentType
		,artistId
		,artist
		,ImageUrl
		,title
		,PlayUrl
		,id
		,title
		,'Movie Blockbusters' ResultType
	FROM CTE_MovieBlockBusters

	UNION ALL

	SELECT DISTINCT TOP 10 id
		,ContentType
		,artistId
		,artist
		,ImageUrl
		,title
		,PlayUrl
		,id
		,title
		,'Drama Buzz' ResultType
	FROM CTE_DramaBuzz;


	END
	ELSE IF @contentType = 'P'
	BEGIN

		If object_id('tempdb..#Temp_PlayList') is not null 
		Drop table #Temp_PlayList

		SELECT DISTINCT --TOP (30) 
			PublishId,PlayListId id,
					ProcessTime,
					PlayListName
					,A.IMAGE AS ImageUrl
					,A.title AS title
					,'P' AS [Type]
					,'P' AS ContentType
					,streamUrl AS PlayUrl
					,A.artistAppearsAs AS artist
					,artistId
					,'' AS duration
					,0 AS IsPaid
					,0 AS Seekable
					,0 AS IsPaid1
					,0 AS Seekable1
					,NULL AS TrackType
					,1 AS RN
					,unique_strings.value				
					,M.Similarity
		INTO #Temp_PlayList
		FROM dbo.View_Playlist AS A WITH (NOLOCK)
		CROSS APPLY (
			SELECT *
			FROM #Temp_SearchText
			) AS unique_strings
		CROSS APPLY(
			SELECT CASE 
				WHEN LEN(unique_strings.value) = 1
					THEN 0
				ELSE dbo.JaccardSimilarity(unique_strings.value, PlayListName)
				END as Similarity					
		) AS M
		WHERE ((A.title LIKE '' + unique_strings.value + '%') OR 
				(A.PlayListName LIKE '' + unique_strings.value + '%'))  AND Similarity>0
		ORDER BY M.Similarity DESC
		-- select * from #Temp_PlayList

		;WITH CTE_TopResult
	AS (
		SELECT TOP 1 * FROM (
		SELECT DISTINCT TOP 1 0 SL, *
		FROM #Temp_PlayList
		WHERE ((PlayListName  like ''+@searchText+'%'))
		UNION ALL
		SELECT DISTINCT TOP 1 1 SL, *
		FROM #Temp_PlayList
		WHERE ((PlayListName not like ''+@searchText+'%'))
		ORDER BY Similarity DESC) X
		ORDER BY SL ASC
		) --select * from CTE_TopResult;		

		,CTE_MostPopularSongsOfPlayList
	AS (
		SELECT DISTINCT TOP 10  [TrackId]
			,'P' AS ContentType
			,artistId
			,artistAppearsAs artist
			,Image ImageUrl
			,title
			,[streamUrl] PlayUrl
			,TotalPlayCount
			,[PlayListId]
			,[PlayListName]
			,'Most Popular' ResultType
		FROM [dbo].[View_PlayList]		
		WHERE [PlayListId] = (
				SELECT TOP 1 [Id]
				FROM CTE_TopResult ORDER BY SL ASC
				)
		ORDER BY TotalPlayCount DESC
		) --select * from CTE_MostPopularSongsOfPlayList

		,CTE_Albums
	AS (
		SELECT DISTINCT TOP 10 R.*
		--,'R' AS ContentType
		,unique_strings.value SeachKey				
		,M.Similarity
		FROM dbo.View_Albums AS R WITH (NOLOCK)
		CROSS APPLY (
			SELECT *
			FROM #Temp_SearchText
			) AS unique_strings
		CROSS APPLY(
			SELECT CASE 
				WHEN LEN(unique_strings.value) = 1
					THEN 0
				ELSE dbo.JaccardSimilarity(unique_strings.value, title)
				END as Similarity					
		) AS M
		WHERE (R.title LIKE '' + unique_strings.value + '%')
		ORDER BY releaseDate DESC,M.Similarity DESC
		
		)-- select * from CTE_Albums;
		,CTE_MorePlayList
	AS (
		SELECT DISTINCT TOP 100 PublishId,id PlaylistId
		,'P' ContentType
		,artistId
		,artist
		,ImageUrl
		,title 		
		,PlayUrl
		,PlayListName
		,MAX(ProcessTime) ReleaseDate						
		,Similarity
		FROM #Temp_PlayList AS P WITH (NOLOCK)		
		GROUP BY PublishId,id,artistId,artist,ImageUrl,title,PlayUrl,PlayListName,
		Similarity
		ORDER BY  releaseDate DESC,Similarity DESC
		) --select * from CTE_MorePlayList;

	
	SELECT DISTINCT TOP 10 id
		,ContentType
		,artistId
		,artist
		,ImageUrl
		,PlayListName title
		,PlayUrl 
		,'' AlbumId
		,'' AlbumTitle
		,'Top Result' ResultType
	FROM CTE_TopResult

	UNION ALL

	SELECT TOP 10 * FROM (
		SELECT DISTINCT TOP 10 [TrackId] id
			,ContentType
			,artistId
			,artist
			,ImageUrl
			,title
			,PlayUrl
			,[PlayListId] AlbumId 
			,[PlayListName] AlbumTitle
			,'Most Popular' ResultType
		FROM CTE_MostPopularSongsOfPlayList					
		) AS MP
	
	UNION ALL

	SELECT DISTINCT TOP 10 id
		,ContentType
		,artistId
		,artist
		,ImageUrl
		,title
		,PlayUrl
		,id
		,title
		,'Albums' ResultType
	FROM CTE_Albums

	UNION ALL
	SELECT DISTINCT TOP 10 PlayListId
		,ContentType
		,artistId
		,artist
		,ImageUrl
		,[PlayListName] title
		,PlayUrl
		,[PublishId] AlbumId
		,[PlayListName] AlbumTitle
		,'More PlayList Like This' ResultType
	FROM CTE_MorePlayList;


	END
	ELSE IF @contentType = 'PS'
	BEGIN
	
	if object_id('tempdb..#Temp_PodcastsTrack') is not null 
	Drop table #Temp_PodcastsTrack

	SELECT * 
	INTO #Temp_PodcastsTrack
	FROM (
	SELECT DISTINCT --top 1000  
	 ROW_NUMBER() OVER (PARTITION BY PodcastTrackContentType ORDER BY Similarity DESC) RankId	
	,'Audio' PodcastCategory
	,[PodcastEpisodeCreateDate]
	,PodcastShowId
	,PodcastEpisodeId
	,PodcastTrackId
	,PodcastShowImageUrl
	,PodcastEpisodeImageUrl
	,PodcastTrackImageUrl
	,PodcastTrack PlayUrl
	,PodcastTrackStarring
	,PodcastShowName
	,PodcastShowSearchName
	,PodcastEpisodeName
	,PodcastEpisodeSearchName
	,PodcastTrackName
	,PodcastTrackSearchName
	,PodcastShowType
	,PodcastEpisodeType
	,PodcastTrackType
	,PodcastShowContentType
	,PodcastEpisodeContentType
	,PodcastTrackContentType
	,PodcastShowPresenter
	,PodcastShowDuration
	,ISNULL(strm.TotalStreamingCount, 0) TotalStreamingCount
	,unique_strings.value
	,M.Similarity
	,Genre
FROM (SELECT * FROM [dbo].[View_PodcastsTrack] WITH (NOLOCK)
UNION ALL 
SELECT * FROM [dbo].[View_PodcastsVideoTrack] WITH (NOLOCK)
) PS
LEFT JOIN [dbo].[View_PodcastTrackStreaming] strm ON PS.PodcastTrackId = strm.ContentId

CROSS APPLY (
	SELECT *
	FROM #Temp_SearchText
	) AS unique_strings
CROSS APPLY (
	SELECT (
			SELECT max(Similarity)
			FROM (
				VALUES (
					CASE 
						WHEN LEN(unique_strings.value) = 1
							THEN 0
						ELSE dbo.JaccardSimilarity(unique_strings.value, PodcastTrackSearchName)
						END
					)
					,(
					CASE 
						WHEN LEN(unique_strings.value) = 1
							THEN 0
						ELSE dbo.JaccardSimilarity(unique_strings.value, PodcastEpisodeSearchName)
						END
					)
					,(
					CASE 
						WHEN LEN(unique_strings.value) = 1
							THEN 0
						ELSE dbo.JaccardSimilarity(unique_strings.value, PodcastShowSearchName)
						END
					)
				) AS tmp(Similarity)
			) AS Similarity
	) AS M
WHERE  PS.ProductBy!= 'Banglalink' AND (
		((PS.PodcastTrackName LIKE '' + unique_strings.value + '%')
			OR (PS.PodcastTrackSearchName LIKE '' + unique_strings.value + '%'))
		OR ((PS.PodcastEpisodeName LIKE '' + unique_strings.value + '%') 
			OR (PS.PodcastEpisodeSearchName LIKE  '' + unique_strings.value + '%'))
		--OR ((PS.PodcastShowName LIKE '' + unique_strings.value + '%')
		--	OR (PS.PodcastShowSearchName LIKE '' + unique_strings.value + '%'))
		) AND Similarity>0
) as rpt
WHERE RankId <=100

--select * from #Temp_PodcastsTrack

	;WITH CTE_TopResult
	AS (
		SELECT TOP 1 PS.PodcastShowId			
			,PS.PodcastShowImageUrl
			,PS.PodcastShowName			
			,PS.PodcastShowType
			,PS.PodcastShowContentType			
			,PS.PodcastShowPresenter
			,PS.PodcastEpisodeId
			,PS.PodcastTrackId
			,PS.PlayUrl
			,PS.Similarity
			,PS.SL
			,PS.Genre
			--FROM CTE_PodcastShows PS
			--WHERE Similarity=(SELECT max(Similarity) from CTE_PodcastShows)
			FROM (
		SELECT DISTINCT TOP 1 0 SL, *
		FROM #Temp_PodcastsTrack		
		WHERE (PodcastShowSearchName=@searchText OR PodcastShowName=@searchText)
		UNION ALL
		SELECT DISTINCT TOP 1 1 SL, *
		FROM #Temp_PodcastsTrack
		WHERE PodcastShowName!=@searchText
		ORDER BY Similarity DESC
		) PS
		ORDER BY SL ASC
		) -- select * from CTE_TopResult;	
		
		,CTE_MostPopular
	AS (
		SELECT DISTINCT TOP 5			
			PS.PodcastTrackId 
			,PS.PodcastTrackImageUrl 
			,PS.PodcastTrackName
			,PS.PodcastEpisodeId
			,PS.PodcastTrackType
			,PS.PodcastTrackContentType				
			,PS.PodcastTrackStarring
			,PS.PlayUrl
			,PS.Similarity
			,TotalStreamingCount
		FROM #Temp_PodcastsTrack PS  WITH (NOLOCK)			
		INNER JOIN (select top 1 * from CTE_TopResult ORDER BY SL ASC) tr
		ON tr.PodcastShowId=PS.PodcastShowId AND tr.PodcastShowName=PS.PodcastShowName
		ORDER BY Similarity DESC
		) --select * from CTE_MostPopular; 

		,CTE_MostPopularRelevant
	AS (
		SELECT DISTINCT TOP 5 PS.PodcastTrackId 
			,PS.PodcastTrackImageUrl
			,PS.PodcastTrackName
			,PS.PodcastEpisodeId
			,PS.PodcastTrackType
			,PS.PodcastTrackContentType			
			,PS.PodcastTrackStarring
			,PS.PlayUrl
			,PS.Similarity
			--,(CASE WHEN LEN(unique_strings.value)=1 THEN 0 ELSE dbo.JaccardSimilarity(unique_strings.value,PodcastTrackSearchName) END) as Similarity 
		FROM #Temp_PodcastsTrack PS
		--CROSS APPLY (
		--SELECT *
		--FROM CTE_SearchText
		--) AS unique_strings		 
		WHERE NOT EXISTS(SELECT 1 FROM CTE_TopResult tr
		WHERE tr.PodcastShowId=PS.PodcastShowId AND tr.PodcastShowName=PS.PodcastShowName)
		ORDER BY Similarity DESC
		)-- select * from CTE_MostPopularRelevant;

		,CTE_MoreEpisodeLikeThis
	AS (
		SELECT DISTINCT TOP 10 
			PS.PodcastEpisodeId			
			,PS.PodcastEpisodeImageUrl
			,PS.PodcastEpisodeName
			,PS.PodcastShowId
			,PS.PodcastEpisodeType
			,PS.PodcastEpisodeContentType			
			,PS.PodcastTrackStarring
			,PS.PlayUrl
			,PS.[PodcastEpisodeCreateDate]
			,PS.Similarity
		FROM #Temp_PodcastsTrack PS
		WHERE  EXISTS(SELECT 1 FROM CTE_TopResult tr
		WHERE tr.PodcastShowId=PS.PodcastShowId)
		ORDER BY [PodcastEpisodeCreateDate] DESC

		UNION ALL

		SELECT DISTINCT TOP 10 
			PS.PodcastEpisodeId			
			,PS.PodcastEpisodeImageUrl
			,PS.PodcastEpisodeName
			,PS.PodcastShowId
			,PS.PodcastEpisodeType
			,PS.PodcastEpisodeContentType			
			,PS.PodcastTrackStarring
			,PS.PlayUrl
			,PS.[PodcastEpisodeCreateDate]
			,PS.Similarity
			--,(CASE WHEN LEN(unique_strings.value)=1 THEN 0 ELSE dbo.JaccardSimilarity(unique_strings.value,PodcastTrackSearchName) END) as Similarity 
		FROM #Temp_PodcastsTrack PS
		--CROSS APPLY (
		--SELECT *
		--FROM CTE_SearchText
		--) AS unique_strings	
		WHERE NOT EXISTS(SELECT 1 FROM CTE_TopResult tr
		WHERE tr.PodcastShowId=PS.PodcastShowId)		
		ORDER BY Similarity DESC	
		
		) --select * from CTE_MoreEpisodeLikeThis WHERE  Similarity>=0.28;

		,CTE_PopularPodcastShows
	AS (
		SELECT DISTINCT TOP 10 
			PS.PodcastShowId			
			,PS.PodcastShowImageUrl
			,PS.PodcastShowName
			,PS.PodcastShowType
			,PS.PodcastShowContentType			
			,PS.PodcastShowPresenter
			,PodcastShowSearchName
			,PS.PodcastTrack PlayUrl
			,Genre
			FROM View_PodcastsTrack PS
			--LEFT JOIN tbl_Artist presen ON PS.PodcastShowPresenter = presen.name
			WHERE PS.Genre=(SELECT top 1 Genre FROM CTE_TopResult)	
			AND PS.ProductBy!= 'Banglalink'
			UNION ALL

			SELECT DISTINCT TOP 10 
			PS.PodcastShowId			
			,PS.PodcastShowImageUrl
			,PS.PodcastShowName
			,PS.PodcastShowType
			,PS.PodcastShowContentType			
			,PS.PodcastShowPresenter
			,PodcastShowSearchName
			,PS.PlayUrl
			,Genre
			FROM #Temp_PodcastsTrack PS
			WHERE PS.Genre=(SELECT top 1 Genre FROM CTE_TopResult)
			AND NOT EXISTS (SELECT top 1 Genre FROM CTE_TopResult)

		) --select * from CTE_PopularPodcastShows;

	,CTE_VideoPodcast
	AS (
		SELECT DISTINCT TOP 10
			PS.PodcastShowId			
			,PS.PodcastShowImageUrl
			,PS.PodcastShowName
			,PS.PodcastShowType
			,PS.PodcastShowContentType			
			,PS.PodcastShowPresenter
			,PS.PodcastTrack PlayUrl
			,PS.Genre
		FROM [dbo].[View_PodcastsVideoTrack] PS
		--LEFT JOIN tbl_Artist presen ON PS.PodcastShowPresenter = presen.name
		WHERE PodcastShowSearchName!='0'
--		--WHERE PS.Genre=(SELECT top 1 Genre FROM CTE_TopResult)			
)


	SELECT fin.id,ContentType,artist.id artistid
	,artist,ImageUrl,title,PlayUrl,AlbumId,AlbumTitle,ResultType 
	FROM (
	SELECT DISTINCT TOP 1 PodcastShowId	id		
			,PodcastShowImageUrl ImageUrl
			,PodcastShowName title
			,PlayUrl
			,null  AlbumId
			,PodcastShowType ContentType
			,PodcastShowContentType AlbumTitle
			,PodcastShowPresenter artist			
		,'Top Result' ResultType
	FROM CTE_TopResult
	UNION ALL
	
	SELECT DISTINCT TOP 10 PodcastTrackId 
			,PodcastTrackImageUrl 
			,PodcastTrackName
			,PlayUrl
			,PodcastEpisodeId 
			,PodcastTrackType
			,PodcastTrackContentType			
			,PodcastTrackStarring			
		,'Most Popular' ResultType
	FROM CTE_MostPopular
	UNION ALL
	--SELECT * FROM (
	SELECT DISTINCT TOP 10 PodcastTrackId 
			,PodcastTrackImageUrl
			,PodcastTrackName
			,PlayUrl
			,PodcastEpisodeId 
			,PodcastTrackType
			,PodcastTrackContentType			
			,PodcastTrackStarring			
		,'Most Popular' ResultType
	FROM CTE_MostPopularRelevant
	

	UNION ALL

	SELECT DISTINCT TOP 10 PodcastEpisodeId			
			,PodcastEpisodeImageUrl
			,PodcastEpisodeName
			,PlayUrl
			,PodcastShowId
			,PodcastEpisodeType
			,PodcastEpisodeContentType
			,PodcastTrackStarring			
		,'More Episodes Like This' ResultType
	FROM CTE_MoreEpisodeLikeThis

	UNION ALL

	SELECT DISTINCT TOP 10 PodcastShowId			
			,PodcastShowImageUrl
			,PodcastShowName
			,PlayUrl
			,null ParentContentId
			,PodcastShowType
			,PodcastShowContentType
			,PodcastShowPresenter			
		,'Podcast Shows' ResultType
	FROM CTE_PopularPodcastShows

	UNION ALL

	SELECT DISTINCT TOP 10 PodcastShowId			
			,PodcastShowImageUrl
			,PodcastShowName
			,PlayUrl
			,null ParentContentId
			,PodcastShowType
			,PodcastShowContentType
			,PodcastShowPresenter			
		,'Video Podcasts' ResultType
	FROM CTE_VideoPodcast) AS Fin
	OUTER APPLY (SELECT top 1 id from tbl_Artist  with (Nolock) WHERE Fin.artist = name) artist;


	END
END

GO


USE [Music_Streaming]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[usp_GetContentbyType] @p_searchText NVARCHAR(1000)	
	,@p_contentType VARCHAR(50)
	,@client INT=1
	,@countryValue INT=1
AS
/*20240319 Created By Mahabubur Rahaman
Change History
Date		Purpose
--------------------

SET STATISTICS TIME ON
select * FROM View_ASongs where title like 'tumi'
Exec [Music_Streaming].[dbo].[usp_GetContentbyType] 'romance','A'
Exec [Music_Streaming].[dbo].[usp_GetContentbyType] 'Pret','PS'
Exec [Music_Streaming].[dbo].[usp_GetContentbyType] 'Habib Wahid','S'
Exec [Music_Streaming].[dbo].[usp_GetContentbyType] 'warfaze','R'
Exec [Music_Streaming].[dbo].[usp_GetContentbyType] 'danpite','A'
Exec [Music_Streaming].[dbo].[usp_GetContentbyType] 'habib wahid','A'
Exec [Music_Streaming].[dbo].[usp_GetContentbyType] 'Priyotoma ''','V'
Exec [Music_Streaming].[dbo].[usp_GetContentbyType] 'Habib Wahid','PS'

select *  FROM View_ASongs where title like '%Tumi Jaio Na%'
*/
--R: Album
--S : Audio Song(Track)
--A: Artist
--V: Video
--PS: PodcastShow
--PE: PodcastEpisode
--PT: PodcastTrack

BEGIN
	DECLARE @searchText NVARCHAR(1000) = @p_searchText
		,@contentType VARCHAR(50) = @p_contentType
		

	SET NOCOUNT ON
	
	IF object_id('tempdb..#Temp_SearchText') is not null 
	DROP TABLE #Temp_SearchText

			;WITH SplitCTE AS (
		SELECT 
			1 AS StartIndex,
			[value] OriginalText,
			CAST(SUBSTRING(value, 1, 1) AS NVARCHAR(100)) AS ProgressiveText,
			LEN(value) AS Length FROM (select * from string_split(@searchText,' ') union select @searchText ) as a

		UNION ALL

		SELECT 
			StartIndex + 1,
			OriginalText,
			CAST(SUBSTRING(OriginalText, 1, StartIndex + 1) AS NVARCHAR(100)) AS ProgressiveText,
			Length 
		FROM 
			SplitCTE
		WHERE 
			StartIndex < Length
		)

	SELECT *
		,COUNT(*) OVER () Cnt
	INTO #Temp_SearchText
	FROM (
		SELECT @searchText value
		
		UNION
		
		SELECT *
		FROM STRING_SPLIT(@searchText, ' ')
		WHERE [value] <> ''
		
		UNION
		
		SELECT REPLACE(@searchText, ' ', '')

		UNION 
		SELECT ProgressiveText FROM SplitCTE Where LEN(ProgressiveText)>2

		) X;

	--SELECT *
	--,COUNT(*) OVER () Cnt
	--INTO #Temp_SearchText
	--FROM (
	--	SELECT @searchText value
		
	--	UNION
		
	--	SELECT *
	--	FROM STRING_SPLIT(@searchText, ' ')
	--	WHERE [value] <> ''
		
	--	UNION
		
	--	SELECT REPLACE(@searchText, ' ', '')
	--	UNION		
	--	SELECT LEFT(value, 1) AS first_letter FROM (SELECT *
	--	FROM STRING_SPLIT(@searchText, ' ')) Single
	--) X

	IF @contentType = 'R'
	BEGIN
		If object_id('tempdb..#Temp_TopAlbums') is not null 
		Drop table #Temp_TopAlbums
		
		SELECT DISTINCT TOP (3000) id
					,ImageUrl
					,title
					,[Type]
					,ContentType
					, ISNULL(PlayUrl,'') PlayUrl
					,artist
					,artistId
					,duration
					,IsPaid
					,Seekable
					,TrackType
					,releaseDate
					,AlbumId
					,AlbumTitle
					,unique_strings.value				
					,M.Similarity
		INTO #Temp_TopAlbums
		FROM (select * from View_Albums UNION select * from View_Albums_track) as A
		CROSS APPLY (
			SELECT *
			FROM #Temp_SearchText
			) AS unique_strings
		CROSS APPLY(
			SELECT CASE 
				WHEN LEN(unique_strings.value) = 1
					THEN 0
				ELSE dbo.JaccardSimilarity(unique_strings.value, artist)
				END as Similarity					
		) AS M
		WHERE (
		(artist LIKE '' + unique_strings.value + '%')
		OR
		(title LIKE '' + unique_strings.value + '%')
		)-- AND Similarity>0
		ORDER BY Similarity DESC
		--) 
		--select * from #Temp_TopAlbums

		;WITH CTE_TopResult
	AS (
		SELECT TOP 1 * FROM (
		SELECT DISTINCT TOP 1 0 SL, *
		FROM #Temp_TopAlbums
		WHERE title=@searchText
		UNION ALL
		SELECT DISTINCT TOP 1 1 SL, *
		FROM #Temp_TopAlbums
		WHERE title!=@searchText
		ORDER BY Similarity DESC) X
		ORDER BY SL ASC
		) --select * from CTE_TopResult;

		,CTE_MostPopularRelevant
	AS (
		SELECT DISTINCT TOP 200 
		id
			,ContentType
			,artistId
			,artist
			,ImageUrl
			,title
			,MAX(PlayUrl) PlayUrl
			,AlbumId
			,AlbumTitle
			,MAX(Similarity) Similarity
		FROM #Temp_TopAlbums
		GROUP BY id
			,ContentType
			,artistId
			,artist
			,ImageUrl
			,title
			--,PlayUrl
			,AlbumId
			,AlbumTitle
		ORDER BY Similarity DESC
		) --select * from CTE_MostPopularRelevant;
		
		SELECT DISTINCT TOP 1 id
		,ContentType
		,artistId
		,artist
		,ImageUrl
		,title
		,PlayUrl
		,AlbumId
		,AlbumTitle
		,'Top Result' ResultType
	FROM CTE_TopResult
		UNION ALL
		SELECT DISTINCT TOP 200 id
			,ContentType
			,artistId
			,artist
			,ImageUrl
			,title
			,PlayUrl
			,AlbumId
			,AlbumTitle
			,'Most Popular' ResultType
		FROM CTE_MostPopularRelevant
		WHERE id != (SELECT ID FROM CTE_TopResult)


	END
	ELSE IF @contentType = 'S'
	BEGIN
		If object_id('tempdb..#Temp_AudioSongs') is not null 
		Drop table #Temp_AudioSongs
	
		SELECT DISTINCT --TOP (300) 
					id
					,ImageUrl
					,title
					,[Type]
					,ContentType
					,PlayUrl
					,artist
					,artistId
					,duration
					,IsPaid
					,Seekable
					,IsPaid1
					,Seekable1
					,TrackType
					,RN
					,releaseDate
					,AlbumId
					,AlbumTitle
					,unique_strings.value
					,M.Similarity 	
					,TotalPlayCount
		INTO #Temp_AudioSongs
		FROM View_ASongs
		CROSS APPLY (
			SELECT *
			FROM #Temp_SearchText
			) AS unique_strings
		CROSS APPLY(
			SELECT CASE 
				WHEN LEN(unique_strings.value) = 1
					THEN 0
				ELSE dbo.JaccardSimilarity(unique_strings.value, artist)
				END as Similarity					
		) AS M
		WHERE ((artist LIKE '' + unique_strings.value + '')
		OR
		(title LIKE '' + unique_strings.value + '%')
		)
		--AND Similarity>0
		ORDER BY M.Similarity,TotalPlayCount DESC	
		

	--select * from #Temp_AudioSongs

	;WITH CTE_TopResult
	AS (
		SELECT TOP 1 * FROM (
		SELECT DISTINCT TOP 1 0 SL, *
		FROM #Temp_AudioSongs
		WHERE title=@searchText
		ORDER BY TotalPlayCount DESC
		UNION ALL
		SELECT DISTINCT TOP 1 1 SL, *
		FROM #Temp_AudioSongs
		WHERE title!=@searchText
		ORDER BY TotalPlayCount DESC) X
		ORDER BY SL ASC
		) --select * from CTE_TopResult;

	,CTE_MostPopularRelevant
	AS (
		SELECT DISTINCT TOP 200 *
		FROM #Temp_AudioSongs
		ORDER BY TotalPlayCount,Similarity DESC
		) --select * from CTE_MostPopularRelevant;

	SELECT DISTINCT TOP 1 id
		,ContentType
		,artistId
		,artist
		,ImageUrl
		,title
		,PlayUrl
		,AlbumId
		,AlbumTitle
		,'Top Result' ResultType
	FROM CTE_TopResult
		UNION ALL
	SELECT DISTINCT TOP 200 id
			,ContentType
			,artistId
			,artist
			,ImageUrl
			,title
			,PlayUrl
			,AlbumId
			,AlbumTitle
			,'Most Popular' ResultType
		FROM CTE_MostPopularRelevant
		WHERE id != (SELECT TOP 1 ID FROM CTE_TopResult)

	END
	ELSE IF @contentType = 'A'
	BEGIN

		If object_id('tempdb..#Temp_AlbumArtist') is not null 
		Drop table #Temp_AlbumArtist
		
		SELECT DISTINCT --TOP (30) 
				id
				,A.IMAGE AS ImageUrl
				,A.name AS title
				,'A' AS [Type]
				,'A' AS ContentType
				,'' AS PlayUrl
				,A.name AS artist
				,A.id AS artistId
				,'' AS duration
				,0 AS IsPaid
				,0 AS Seekable
				,0 AS IsPaid1
				,0 AS Seekable1
				,NULL AS TrackType
				,1 AS RN
				,follower
				,'' value				
				,.5 Similarity
				,GenreIds	
	INTO #Temp_AlbumArtist
	FROM dbo.tbl_Artist AS A WITH (NOLOCK)
	WHERE A.id IN (SELECT [artistId] FROM [dbo].[View_Albums_Track] WHERE [title]=@searchText)

		If object_id('tempdb..#Temp_PlayListArtist') is not null 
		Drop table #Temp_PlayListArtist
		
		SELECT DISTINCT --TOP (30) 
				id
				,A.IMAGE AS ImageUrl
				,A.name AS title
				,'A' AS [Type]
				,'A' AS ContentType
				,'' AS PlayUrl
				,A.name AS artist
				,A.id AS artistId
				,'' AS duration
				,0 AS IsPaid
				,0 AS Seekable
				,0 AS IsPaid1
				,0 AS Seekable1
				,NULL AS TrackType
				,1 AS RN
				,follower
				,'' value				
				,.5 Similarity
				,GenreIds	
	INTO #Temp_PlayListArtist
	FROM dbo.tbl_Artist AS A WITH (NOLOCK)
	WHERE A.id IN (SELECT [artistId] FROM [dbo].[View_PlayList] WHERE PlayListName=@searchText)

	--select * from #Temp_PlayListArtist;

	--select * from CTE_AlbumArtist;
	If object_id('tempdb..#Temp_Artist') is not null 
		Drop table #Temp_Artist

		SELECT DISTINCT --TOP (30) 
				id
				,A.IMAGE AS ImageUrl
				,A.name AS title
				,'A' AS [Type]
				,'A' AS ContentType
				,'' AS PlayUrl
				,A.name AS artist
				,A.id AS artistId
				,'' AS duration
				,0 AS IsPaid
				,0 AS Seekable
				,0 AS IsPaid1
				,0 AS Seekable1
				,NULL AS TrackType
				,1 AS RN
				,follower
				,unique_strings.value				
				,M.Similarity
				,GenreIds
	INTO #Temp_Artist
	FROM dbo.tbl_Artist AS A WITH (NOLOCK)
	CROSS APPLY (
		SELECT *
		FROM #Temp_SearchText
		) AS unique_strings
	CROSS APPLY(
			SELECT CASE 
				WHEN LEN(unique_strings.value) = 1
					THEN 0
				ELSE dbo.JaccardSimilarity(unique_strings.value, Name)
				END as Similarity					
		) AS M
	WHERE (
	(A.[name] LIKE  '' + unique_strings.value + '%')
	OR (A.id IN (SELECT artistId from #Temp_AlbumArtist))
	OR (A.id IN (SELECT artistId from #Temp_PlayListArtist))
	)
	--AND Similarity>0
	ORDER BY Similarity DESC, follower DESC
--select * from #Temp_Artist
--SELECT * FROM #Temp_AlbumArtist
--SELECT *FROM #Temp_PlayListArtist
--select * from #Temp_Artist
;WITH CTE_TopResult
	AS (		
		SELECT TOP 1 * FROM (
		SELECT DISTINCT TOP 1 0 SL, *
		FROM #Temp_Artist
		WHERE ((title=@searchText))
		AND NOT EXISTS(SELECT 1 FROM #Temp_AlbumArtist)
		AND NOT EXISTS(SELECT 1 FROM #Temp_PlayListArtist)
		UNION ALL
		SELECT DISTINCT TOP 1 1 SL, *
		FROM #Temp_Artist
		WHERE title!=@searchText
		AND NOT EXISTS(SELECT 1 FROM #Temp_AlbumArtist)
		AND NOT EXISTS(SELECT 1 FROM #Temp_PlayListArtist)
		UNION
		SELECT  DISTINCT TOP 1 2 SL, *
		FROM #Temp_AlbumArtist	
		WHERE NOT EXISTS(SELECT 1 FROM #Temp_PlayListArtist)
		UNION
		SELECT  DISTINCT TOP 1 2 SL, *
		FROM #Temp_PlayListArtist		
		WHERE NOT EXISTS(SELECT 1 FROM #Temp_AlbumArtist)
		UNION 
		SELECT  DISTINCT TOP 1 2 SL, *
		FROM #Temp_PlayListArtist	
		ORDER BY Similarity DESC,follower DESC
		) X
		ORDER BY SL ASC
		) --select * from CTE_TopResult;
		

		,CTE_TopResultGenre 
	AS (		
			SELECT
				g.Id,g.GenreName
			FROM
				dbo.tbl_Artist A
			CROSS APPLY
				OPENJSON(A.GenreIds) AS s
			JOIN
				Genre g ON g.id = s.value
			where A.id=(SELECT artistId FROM CTE_TopResult )
		) --select * from CTE_TopResultGenre;
	,CTE_TopArtist
	AS (
		SELECT DISTINCT TOP 20
		id
		,'A' Type
		,id artistId
		,name artist
		,image ImageUrl
		,name title
		,'' PlayUrl
		,follower as AlbumId
		,'' AlbumName
		, ROW_NUMBER() OVER(ORDER BY follower DESC) as SL
		,'A' ContentType
		,follower
		FROM dbo.tbl_Artist AS A WITH (NOLOCK)
		CROSS APPLY
				(SELECT top 1 * from OPENJSON(A.GenreIds)) AS s
		WHERE s.value IN (SELECT TOP 1 Id FROM CTE_TopResultGenre)
		AND A.id != (SELECT top 1 artistId FROM CTE_TopResult )
		UNION
		SELECT DISTINCT TOP 20
		id
		,'A' Type
		,id artistId
		,name artist
		,image ImageUrl
		,name title
		,'' PlayUrl
		,follower as AlbumId
		,'' AlbumName
		, ROW_NUMBER() OVER(ORDER BY follower DESC) as SL
		,'A' ContentType
		,follower
		FROM dbo.tbl_Artist AS A WITH (NOLOCK)
		CROSS APPLY
				(select A.GenreIds g) AS s
		WHERE ISNULL(A.GenreIds,'') != ''
		AND NOT EXISTS(SELECT TOP 1 Id FROM CTE_TopResultGenre)
		AND A.id != (SELECT top 1 artistId FROM CTE_TopResult )
		UNION
		SELECT DISTINCT TOP 20 
		id
		,ContentType
		,id artistId
		,artist
		,ImageUrl
		,title
		,'' PlayUrl
		,follower as AlbumId
		,'' AlbumName
		, ROW_NUMBER() OVER(ORDER BY follower DESC) as SL
		,'A' ContentType
		,follower
		FROM #Temp_Artist AS A WITH (NOLOCK)
		WHERE A.id != (SELECT top 1 artistId FROM CTE_TopResult )
		ORDER BY SL ASC
		) --select *from CTE_TopArtist;

	SELECT DISTINCT TOP 1 id
		,ContentType
		,artistId
		,artist
		,ImageUrl
		,title
		,PlayUrl 
		,follower AlbumId
		,'' AlbumTitle
		,'Top Result' ResultType
	FROM CTE_TopResult

		UNION ALL
	SELECT * FROM (SELECT DISTINCT TOP 200  id
		,ContentType
		,id artistId
		, artist
		, ImageUrl
		,title
		,'' PlayUrl
		,follower as AlbumId
		,'' AlbumName
		,'Artists To Follow' ResultType
	FROM CTE_TopArtist ORDER BY follower DESC) AS art;


	END
	ELSE IF @contentType = 'V'
	BEGIN	
		If object_id('tempdb..#Temp_Videos') is not null 
		Drop table #Temp_Videos

		SELECT DISTINCT  id
			,ImageUrl
			,title
			,[Type]
			,ContentType
			,PlayUrl
			,artist
			,artistId
			,duration
			,IsPaid
			,Seekable
			,[TrackType]
			,AlbumId
			,AlbumTitle
			,releaseDate
			,GenreId
			,GenreName
			,unique_strings.value
			,M.Similarity			
		INTO #Temp_Videos
		FROM View_VSongs
		CROSS APPLY (
			SELECT *
			FROM #Temp_SearchText
			) AS unique_strings
		CROSS APPLY(
			SELECT CASE 
				WHEN LEN(unique_strings.value) = 1
					THEN 0
				ELSE dbo.JaccardSimilarity(unique_strings.value, artist)
				END as Similarity					
		) AS M
		WHERE (
		(artist LIKE '' + unique_strings.value + '%')  
		OR
		(title LIKE '' + unique_strings.value + '%')
		)

		--AND Similarity>0
		ORDER BY Similarity DESC 
		
		;WITH CTE_TopResult
	AS (
		SELECT TOP 1 * FROM (
		SELECT DISTINCT TOP 1 0 SL, *
		FROM #Temp_Videos
		WHERE title=@searchText
		UNION ALL
		SELECT DISTINCT TOP 1 1 SL, *
		FROM #Temp_Videos
		WHERE title!=@searchText
		ORDER BY Similarity DESC) X
		ORDER BY SL ASC
		)
		,CTE_TopResultGenre 
	AS (		
			SELECT
				g.Id,g.GenreName
			FROM
				dbo.tbl_Artist A
			CROSS APPLY
				STRING_SPLIT(A.GenreIds, ',') AS s
			JOIN
				Genre g ON g.id = CAST(REPLACE(REPLACE(REPLACE(s.value,'[',''),']',''),'"','') AS INT)
			where A.id=(SELECT artistId FROM CTE_TopResult )
		) --select * from CTE_TopResultGenre;	
		,CTE_MostPopularRelevant
	AS (
		SELECT DISTINCT TOP 200 *
		FROM #Temp_Videos
		ORDER BY Similarity DESC
		) --select * from CTE_MostPopularRelevant;


	SELECT DISTINCT TOP 1 id
		,ContentType
		,artistId
		,artist
		,ImageUrl
		,title
		,PlayUrl
		,AlbumId
		,AlbumTitle
		,'Top Result' ResultType
	FROM CTE_TopResult

	UNION ALL

	SELECT DISTINCT TOP 200 id
		,ContentType
		,artistId
		,artist
		,ImageUrl
		,title
		,PlayUrl
		,AlbumId
		,AlbumTitle
		,'Most Popular' ResultType
	FROM CTE_MostPopularRelevant
	WHERE id !=(SELECT TOP 1 ID FROM CTE_TopResult)


	END
	ELSE IF @contentType = 'P'
	BEGIN
		If object_id('tempdb..#Temp_PlayList') is not null 
		Drop table #Temp_PlayList

		SELECT DISTINCT --TOP (30) 
			PublishId,PlayListId id,
					ProcessTime,
					PlayListName
					,A.IMAGE AS ImageUrl
					,A.title AS title
					,'P' AS [Type]
					,'P' AS ContentType
					,streamUrl AS PlayUrl
					,A.artistAppearsAs AS artist
					,artistId
					,'' AS duration
					,0 AS IsPaid
					,0 AS Seekable
					,0 AS IsPaid1
					,0 AS Seekable1
					,NULL AS TrackType
					,1 AS RN
					,unique_strings.value				
					,M.Similarity
		INTO #Temp_PlayList
		FROM dbo.View_Playlist AS A WITH (NOLOCK)
		CROSS APPLY (
			SELECT *
			FROM #Temp_SearchText
			) AS unique_strings
		CROSS APPLY(
			SELECT CASE 
				WHEN LEN(unique_strings.value) = 1
					THEN 0
				ELSE dbo.JaccardSimilarity(unique_strings.value, A.artistAppearsAs)
				END as Similarity					
		) AS M
		WHERE ((A.artistAppearsAs LIKE '' + unique_strings.value + '%') 
		OR
		(title LIKE '' + unique_strings.value + '%')		
		)--  AND Similarity>0
		ORDER BY M.Similarity DESC
		 --select * from #Temp_PlayList

	;WITH CTE_TopResult
	AS (
		SELECT TOP 1 * FROM (
		SELECT DISTINCT TOP 1 0 SL, *
		FROM #Temp_PlayList
		WHERE ((PlayListName  like ''+@searchText+'%'))
		UNION ALL
		SELECT DISTINCT TOP 1 1 SL, *
		FROM #Temp_PlayList
		WHERE ((PlayListName not like ''+@searchText+'%'))
		ORDER BY Similarity DESC) X
		ORDER BY SL ASC
		) --select * from CTE_TopResult;	
		,CTE_MorePlayList
	AS (
		SELECT DISTINCT TOP 200 PublishId,id PlaylistId
		,'P' ContentType
		,artistId
		,artist
		,ImageUrl
		,title 		
		,MAX(PlayUrl) PlayUrl
		,PlayListName
		,MAX(ProcessTime) ReleaseDate						
		,MAX(Similarity) Similarity
		FROM #Temp_PlayList AS P WITH (NOLOCK)		
		GROUP BY PublishId,id,artistId,artist,ImageUrl,title,PlayListName
		
		ORDER BY  releaseDate DESC,Similarity DESC
		) --select * from CTE_MorePlayList;

	SELECT DISTINCT TOP 1 id
		,ContentType
		,artistId
		,artist
		,ImageUrl
		,title
		,PlayUrl
		,'' AlbumId
		,'' AlbumTitle
		,'Top Result' ResultType
	FROM CTE_TopResult

		UNION ALL
	SELECT DISTINCT TOP 200 PlayListId
		,ContentType
		,MAX(artistId) artistId
		,MAX(artist) artist
		,ImageUrl
		,[PlayListName] title
		,MAX(PlayUrl) PlayUrl
		,0 AlbumId
		,[PlayListName] AlbumTitle
		,'More PlayList Like This' ResultType
	FROM CTE_MorePlayList
	group by PlayListId
		,ContentType	
		,ImageUrl
		,[PlayListName]
		,[PlayListName];

	END
	ELSE IF @contentType = 'PS'
	BEGIN

	if object_id('tempdb..#Temp_PodcastsTrack') is not null 
	Drop table #Temp_PodcastsTrack

	SELECT * 
	INTO #Temp_PodcastsTrack
	FROM (
	SELECT DISTINCT --top 1000  
	 ROW_NUMBER() OVER (PARTITION BY PodcastTrackContentType ORDER BY Similarity DESC) RankId	
	,'Audio' PodcastCategory
	,[PodcastEpisodeCreateDate]
	,PodcastShowId
	,PodcastEpisodeId
	,PodcastTrackId
	,PodcastShowImageUrl
	,PodcastEpisodeImageUrl
	,PodcastTrackImageUrl
	,PodcastTrack PlayUrl
	,PodcastTrackStarring
	,PodcastShowName
	,PodcastShowSearchName
	,PodcastEpisodeName
	,PodcastEpisodeSearchName
	,PodcastTrackName
	,PodcastTrackSearchName
	,PodcastShowType
	,PodcastEpisodeType
	,PodcastTrackType
	,PodcastShowContentType
	,PodcastEpisodeContentType
	,PodcastTrackContentType
	,PodcastShowPresenter
	,PodcastShowDuration
	,ISNULL(strm.TotalStreamingCount, 0) TotalStreamingCount
	,unique_strings.value
	,M.Similarity
	,Genre
FROM (SELECT * FROM [dbo].[View_PodcastsTrack] WITH (NOLOCK)
UNION ALL 
SELECT * FROM [dbo].[View_PodcastsVideoTrack] WITH (NOLOCK)
) PS
LEFT JOIN [dbo].[View_PodcastTrackStreaming] strm ON PS.PodcastTrackId = strm.ContentId

CROSS APPLY (
	SELECT *
	FROM #Temp_SearchText
	) AS unique_strings
CROSS APPLY (
	SELECT (
			SELECT max(Similarity)
			FROM (
				VALUES (
					CASE 
						WHEN LEN(unique_strings.value) = 1
							THEN 0
						ELSE dbo.JaccardSimilarity(unique_strings.value, PodcastTrackSearchName)
						END
					)
					,(
					CASE 
						WHEN LEN(unique_strings.value) = 1
							THEN 0
						ELSE dbo.JaccardSimilarity(unique_strings.value, PodcastEpisodeSearchName)
						END
					)
					,(
					CASE 
						WHEN LEN(unique_strings.value) = 1
							THEN 0
						ELSE dbo.JaccardSimilarity(unique_strings.value, PodcastShowSearchName)
						END
					)
				) AS tmp(Similarity)
			) AS Similarity
	) AS M
WHERE  PS.ProductBy!= 'Banglalink' AND  (
		((PS.PodcastTrackName LIKE '%' + unique_strings.value + '%')
			OR (PS.PodcastTrackSearchName LIKE '%' + unique_strings.value + '%'))
		OR ((PS.PodcastEpisodeName LIKE '%' + unique_strings.value + '%') 
			OR (PS.PodcastEpisodeSearchName LIKE  '%' + unique_strings.value + '%'))
		OR ((PS.PodcastShowName LIKE '%' + unique_strings.value + '%')
			OR (PS.PodcastShowSearchName LIKE '%' + unique_strings.value + '%'))
		OR ((PS.PodcastShowPresenter LIKE '%' + unique_strings.value + '%'))
		)-- AND Similarity>0
) as rpt
WHERE RankId <=100


	;WITH CTE_TopResult
	AS (
		SELECT TOP 1 PS.PodcastShowId			
			,PS.PodcastShowImageUrl
			,PS.PodcastShowName			
			,PS.PodcastShowType
			,PS.PodcastShowContentType			
			,PS.PodcastShowPresenter
			,PS.PodcastEpisodeId
			,PS.PodcastTrackId
			,PS.PlayUrl
			,PS.Similarity
			,PS.SL
			,PS.Genre
			--FROM CTE_PodcastShows PS
			--WHERE Similarity=(SELECT max(Similarity) from CTE_PodcastShows)
			FROM (
		SELECT DISTINCT TOP 1 0 SL, *
		FROM #Temp_PodcastsTrack		
		WHERE (PodcastShowSearchName=@searchText OR PodcastShowName=@searchText)
		UNION ALL
		SELECT DISTINCT TOP 1 1 SL, *
		FROM #Temp_PodcastsTrack
		WHERE PodcastShowName!=@searchText
		ORDER BY Similarity DESC
		) PS
		ORDER BY SL ASC
		) -- select * from CTE_TopResult;	
		
		,CTE_MostPopular
	AS (
		SELECT DISTINCT TOP 200		
			PS.PodcastTrackId 
			,PS.PodcastTrackImageUrl 
			,PS.PodcastTrackName
			,PS.PodcastEpisodeId
			,PS.PodcastTrackType
			,PS.PodcastTrackContentType				
			,PS.PodcastTrackStarring
			,PS.PlayUrl
			,PS.Similarity
			,TotalStreamingCount
		FROM #Temp_PodcastsTrack PS  WITH (NOLOCK)			
		INNER JOIN (select top 1 * from CTE_TopResult ORDER BY SL ASC) tr
		ON tr.PodcastShowId=PS.PodcastShowId AND tr.PodcastShowName=PS.PodcastShowName
		ORDER BY Similarity DESC
		) --select * from CTE_MostPopular; 

		,CTE_MoreEpisodeLikeThis
	AS (
		SELECT DISTINCT TOP 200 
			PS.PodcastEpisodeId			
			,PS.PodcastEpisodeImageUrl
			,PS.PodcastEpisodeName
			,PS.PodcastShowId
			,PS.PodcastEpisodeType
			,PS.PodcastEpisodeContentType			
			,PS.PodcastTrackStarring
			,PS.PlayUrl
			,PS.[PodcastEpisodeCreateDate]
			,PS.Similarity
		FROM #Temp_PodcastsTrack PS
		WHERE  EXISTS(SELECT 1 FROM CTE_TopResult tr
		WHERE tr.PodcastShowId=PS.PodcastShowId)
		ORDER BY [PodcastEpisodeCreateDate] DESC

		UNION ALL

		SELECT DISTINCT TOP 200
			PS.PodcastEpisodeId			
			,PS.PodcastEpisodeImageUrl
			,PS.PodcastEpisodeName
			,PS.PodcastShowId
			,PS.PodcastEpisodeType
			,PS.PodcastEpisodeContentType			
			,PS.PodcastTrackStarring
			,PS.PlayUrl
			,PS.[PodcastEpisodeCreateDate]
			,PS.Similarity
		FROM #Temp_PodcastsTrack PS
		WHERE NOT EXISTS(SELECT 1 FROM CTE_TopResult tr
		WHERE tr.PodcastShowId=PS.PodcastShowId)		
		ORDER BY Similarity DESC	
		
		) --select * from CTE_MoreEpisodeLikeThis WHERE  Similarity>=0.28;

		,CTE_PopularPodcastShows
	AS (
		SELECT DISTINCT TOP 200 
			PS.PodcastShowId			
			,PS.PodcastShowImageUrl
			,PS.PodcastShowName
			,PS.PodcastShowType
			,PS.PodcastShowContentType			
			,PS.PodcastShowPresenter
			,PodcastShowSearchName
			,PS.PodcastTrack PlayUrl
			,Genre
			FROM View_PodcastsTrack PS
			WHERE PS.Genre=(SELECT top 1 Genre FROM CTE_TopResult)	
			AND PS.ProductBy!= 'Banglalink'
			UNION ALL

			SELECT DISTINCT TOP 200 
			PS.PodcastShowId			
			,PS.PodcastShowImageUrl
			,PS.PodcastShowName
			,PS.PodcastShowType
			,PS.PodcastShowContentType			
			,PS.PodcastShowPresenter
			,PodcastShowSearchName
			,PS.PlayUrl
			,Genre
			FROM #Temp_PodcastsTrack PS
			WHERE PS.Genre=(SELECT top 1 Genre FROM CTE_TopResult)
			AND NOT EXISTS (SELECT top 1 Genre FROM CTE_TopResult)

		) --select * from CTE_PopularPodcastShows;

	,CTE_VideoPodcast
	AS (
		SELECT DISTINCT TOP 200
			PS.PodcastShowId			
			,PS.PodcastShowImageUrl
			,PS.PodcastShowName
			,PS.PodcastShowType
			,PS.PodcastShowContentType			
			,PS.PodcastShowPresenter
			,PS.PodcastTrack PlayUrl
			,PS.Genre
		FROM [dbo].[View_PodcastsVideoTrack] PS
		--LEFT JOIN tbl_Artist presen ON PS.PodcastShowPresenter = presen.name
		WHERE PodcastShowSearchName!='0'
		AND PS.Genre=(SELECT top 1 Genre FROM CTE_TopResult)			
)

	SELECT fin.id,ContentType,artist.id artistid
	,artist,ImageUrl,title,PlayUrl,AlbumId,AlbumTitle,ResultType 
	FROM (
			SELECT DISTINCT TOP 1 PodcastShowId	id		
			,PodcastShowImageUrl ImageUrl
			,PodcastShowName title
			,PlayUrl
			,null  AlbumId
			,PodcastShowType ContentType
			,PodcastShowContentType AlbumTitle
			,PodcastShowPresenter artist			
		,'Podcast Stories' ResultType
	FROM CTE_TopResult

	UNION ALL
	
	SELECT DISTINCT TOP 200 PodcastTrackId 
			,PodcastTrackImageUrl 
			,PodcastTrackName
			,PlayUrl
			,PodcastEpisodeId 
			,PodcastTrackType
			,PodcastTrackContentType			
			,PodcastTrackStarring			
		,'Podcast Stories' ResultType
	FROM CTE_MostPopular
	UNION ALL

	SELECT DISTINCT TOP 200 PodcastEpisodeId			
			,PodcastEpisodeImageUrl
			,PodcastEpisodeName
			,PlayUrl
			,PodcastShowId
			,PodcastEpisodeType
			,PodcastEpisodeContentType
			,PodcastTrackStarring			
		,'Podcast Episodes' ResultType
	FROM CTE_MoreEpisodeLikeThis

	UNION ALL

	SELECT DISTINCT TOP 200 PodcastShowId			
			,PodcastShowImageUrl
			,PodcastShowName
			,PlayUrl
			,null ParentContentId
			,PodcastShowType
			,PodcastShowContentType
			,PodcastShowPresenter			
		,'Podcast Shows' ResultType
	FROM CTE_PopularPodcastShows

	UNION ALL

	SELECT DISTINCT TOP 200 PodcastShowId			
			,PodcastShowImageUrl
			,PodcastShowName
			,PlayUrl
			,null ParentContentId
			,PodcastShowType
			,PodcastShowContentType
			,PodcastShowPresenter			
		,'Video Podcasts' ResultType
	FROM CTE_VideoPodcast

	) AS Fin
	OUTER APPLY (SELECT top 1 id from tbl_Artist  with (Nolock) WHERE Fin.artist = name) artist;




	END
END

