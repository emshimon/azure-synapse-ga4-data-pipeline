/*
**
** Office Hour Demo
** テーブル作成スクリプト
**
*/

IF OBJECT_ID('ga4_json_data') IS NOT NULL
	DROP TABLE [dbo].[ga4_json_data] ;

IF OBJECT_ID('ga4_json_resultset') IS NOT NULL
	DROP TABLE [dbo].[ga4_json_resultset] ;

-- GA4 JSON データを 1 行ずつ格納するテーブル
CREATE TABLE [dbo].[ga4_json_data] (
	[json_line]						NVARCHAR(MAX)
)
WITH (
	DISTRIBUTION = ROUND_ROBIN
	, HEAP -- nvarchar (MAX) を利用するため
) ;

-- ga4_json_data テーブルのデータから生成した行セットを格納するテーブル
CREATE TABLE [dbo].[ga4_json_resultset] (
	[event_date]						NVARCHAR(100)
	, [event_timestamp]					NVARCHAR(100)
	, [event_name]						NVARCHAR(100)
	, [event_params]					NVARCHAR(max) 
	, [event_previous_timestamp]		NVARCHAR(100)
	, [event_value_in_usd]				NVARCHAR(100)
	, [event_bundle_sequence_id]		NVARCHAR(100)
	, [event_server_timestamp_offset]	NVARCHAR(100) 
	, [user_id]							NVARCHAR(100) 
	, [user_pseudo_id]					NVARCHAR(100)
	, [privacy_info]					NVARCHAR(max)
	, [user_properties]					NVARCHAR(max) 
	, [user_first_touch_timestamp]		NVARCHAR(100)
	, [user_ltv]						NVARCHAR(max)
	, [device]							NVARCHAR(max)
	, [geo]								NVARCHAR(max)
	, [app_info]						NVARCHAR(max) 
	, [traffic_source]					NVARCHAR(max)
	, [stream_id]						NVARCHAR(100)
	, [platform]						NVARCHAR(100)
	, [event_dimensions]				NVARCHAR(100)
	, [ecommerce]						NVARCHAR(max)
	, [items]							NVARCHAR(max)
)
WITH (
	DISTRIBUTION = ROUND_ROBIN
	, HEAP 
) ;
GO
