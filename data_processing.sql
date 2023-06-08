/* 
** Synapse Pipeline で取り込んだ GA4 JSON データを列展開する
*/
TRUNCATE TABLE ga4_json_resultset;

INSERT INTO [dbo].[ga4_json_resultset](
	event_date
	, event_timestamp
	, event_name
	, event_params
	, event_previous_timestamp
	, event_value_in_usd
	, event_bundle_sequence_id
    , event_server_timestamp_offset
	, user_id, user_pseudo_id
	, privacy_info
	, user_properties
	, user_first_touch_timestamp
	, user_ltv
	, device
	, geo,app_info
    , traffic_source
	, stream_id
	, platform
	, event_dimensions
	, ecommerce
	, items
	) 
SELECT tvf.event_date
	, dbo.udf_time(tvf.event_timestamp) AS event_timestamp
	, tvf.event_name
	, tvf.event_params
	, tvf.event_previous_timestamp
	, tvf.event_value_in_usd
	, tvf.event_bundle_sequence_id
    , tvf.event_server_timestamp_offset
	, tvf.user_id
	, tvf.user_pseudo_id
	, tvf.privacy_info
	, tvf.user_properties
	, tvf.user_first_touch_timestamp
	, tvf.user_ltv
	, tvf.device
	, tvf.geo,app_info
    , tvf.traffic_source
	, tvf.stream_id
	, tvf.platform
	, tvf.event_dimensions
	, tvf.ecommerce
	, tvf.items
FROM [dbo].[ga4_json_data] AS t
    CROSS APPLY [dbo].[tvf_data_processing](t.json_line) AS tvf
GO

-- チェック用
SELECT TOP 10 * FROM [dbo].[ga4_json_resultset]
GO

/* 
[サンプル1] 必要な項目のみ選択し、結果を [ga4_data_01] テーブルに挿入する 
*/

IF OBJECT_ID('ga4_data_01') IS NOT NULL
	DROP TABLE [dbo].[ga4_data_01] ;

CREATE TABLE [dbo].[ga4_data_01]
WITH(
    DISTRIBUTION = ROUND_ROBIN,
    HEAP -- nvarchar(max) を使っているため HEAP 形式での指定が必要
)
AS
	WITH cte
	AS
	( -- 必要な列を指定
		SELECT event_date
			, event_timestamp
			, event_name
			, g.region
			, f.[key] AS event_param_key
			, f.[value] AS URL
		FROM [dbo].[ga4_json_resultset] 
			CROSS APPLY [dbo].[tvf_event_params](event_params) AS f --[ga4_json_resultset] の列で JSON 形式の列は function を適用し CROSSS APPLY する
			CROSS APPLY [dbo].[tvf_geo](geo) AS g --[ga4_json_resultset] の列で JSON 形式の列は function を適用し CROSSS APPLY する
	)
	SELECT * FROM cte 
	WHERE event_param_key = 'page_location'
		AND event_name = 'page_view'
GO

-- チェック用
SELECT TOP 10 * FROM [dbo].[ga4_data_01]
GO

/* 
[サンプル2] 結果をテーブルに挿入せずに､必要な項目を表示する 
*/
WITH cte AS ( -- 必要な列を指定
	SELECT r.event_date
		, r.event_timestamp
		, r.event_name
		, g.region
		, p.[key] AS event_param_key
		, p.[value] AS URL
	FROM [dbo].[ga4_json_resultset] AS r
		CROSS APPLY [dbo].[tvf_event_params](event_params) AS p -- [ga4_json_resultset] の列で JSON 形式の列は function を適用し CROSSS APPLY する
	    CROSS APPLY [dbo].[tvf_geo](geo) AS g  -- [ga4_json_resultset] の列で JSON 形式の列は function を適用し CROSSS APPLY する
)
SELECT TOP 10 * 
FROM cte 
WHERE event_param_key = 'page_location'
	AND event_name = 'page_view'
GO
