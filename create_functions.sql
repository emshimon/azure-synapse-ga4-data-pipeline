/*
**
** Office Hour Demo
** テーブル値関数作成スクリプト
** Update 版
** 
*/

IF OBJECT_ID('tvf_data_processing') IS NOT NULL
	DROP FUNCTION [dbo].[tvf_data_processing] ;

IF OBJECT_ID('tvf_event_params') IS NOT NULL
	DROP FUNCTION [dbo].[tvf_event_params] ;

IF OBJECT_ID('tvf_privacy_info') IS NOT NULL
	DROP FUNCTION [dbo].[tvf_privacy_info] ;

IF OBJECT_ID('tvf_user_properties') IS NOT NULL
	DROP FUNCTION [dbo].[tvf_user_properties] ;

IF OBJECT_ID('tvf_user_ltv') IS NOT NULL
	DROP FUNCTION [dbo].[tvf_user_ltv] ;

IF OBJECT_ID('tvf_device') IS NOT NULL
	DROP FUNCTION [dbo].[tvf_device] ;

IF OBJECT_ID('tvf_geo') IS NOT NULL
	DROP FUNCTION [dbo].[tvf_geo] ;

IF OBJECT_ID('tvf_app_info') IS NOT NULL
	DROP FUNCTION [dbo].[tvf_app_info] ;

IF OBJECT_ID('tvf_traffic_source') IS NOT NULL
	DROP FUNCTION [dbo].[tvf_traffic_source] ;

IF OBJECT_ID('tvf_ecommerce') IS NOT NULL
	DROP FUNCTION [dbo].[tvf_ecommerce] ;

IF OBJECT_ID('tvf_items') IS NOT NULL
	DROP FUNCTION [dbo].[tvf_items] ;
GO

IF OBJECT_ID('udf_time') IS NOT NULL
	DROP FUNCTION [dbo].[udf_time] ;
GO

/* timestamp 列を日付に変換する関数 */
CREATE FUNCTION [dbo].[udf_time](@cTime NVARCHAR(max))
RETURNS DATETIME
AS
BEGIN
    DECLARE @StartDate		DATETIME2 = '1970-01-01'
		, @RetDate			DATETIME2
		, @TimeValue1		BIGINT
		, @TimeValue2		BIGINT
		, @TimeValue3		BIGINT
		, @mcs_value		INT
		, @days_value		INT
		, @hours_value		INT
		, @minutes_value	INT
		, @seconds_value	INT

	SET @TimeValue1 = CAST(@cTime AS BIGINT) / (1000 * 1000);
	SET @mcs_value = CAST(@cTime AS BIGINT) % (1000 * 1000) ;
	SET @days_value = @TimeValue1 / (24 * 3600) ;
	SET @TimeValue2 = @TimeValue1 % (24 * 3600) ;
	SET @hours_value = @TimeValue2 / 3600 ;
	SET @TimeValue3 = @TimeValue2 % 3600 ;
	SET @minutes_value = @TimeValue3 / 60 ;
	SET @seconds_value = @TimeValue3 % 60 ;
    SET @RetDate = DATEADD(second
		, @seconds_value
		, DATEADD(minute
			, @minutes_value
			, DATEADD(hour
				, @hours_value
				, DATEADD(day
					, @days_value
					, @StartDate)
				)
			)
		) ;
	SET @RetDate = DATEADD(microsecond, @mcs_value, @RetDate) ;

    RETURN @RetDate ;
END ;
GO

/* JSON データから行セットを生成する関数 */
CREATE FUNCTION [dbo].[tvf_data_processing](@json NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN
(
	SELECT
		CONVERT(DATE, [event_date], 23) AS [event_date]
        , dbo.udf_time([event_timestamp]) AS [event_timestamp]
		, [event_name]
		, [event_params]
		, [event_previous_timestamp]
		, [event_value_in_usd]
		, [event_bundle_sequence_id]
		, [event_server_timestamp_offset]
		, [user_id]
		, [user_pseudo_id]
		, [privacy_info]
		, [user_properties]
		, [user_first_touch_timestamp]
		, [user_ltv]
		, [device]
		, [geo]
		, [app_info]
		, [traffic_source]
		, [stream_id]
		, [platform]
		, [event_dimensions]
		, [ecommerce]
		, [items]
    FROM OPENJSON (@json)
	WITH (
		[event_date]						NVARCHAR(100)
		, [event_timestamp]					NVARCHAR(100)
		, [event_name]						NVARCHAR(100)
		, [event_params]					NVARCHAR(MAX) AS JSON
		, [event_previous_timestamp]		NVARCHAR(100)
		, [event_value_in_usd]				NVARCHAR(100)
		, [event_bundle_sequence_id]		NVARCHAR(100)
		, [event_server_timestamp_offset]	NVARCHAR(100) 
		, [user_id]							NVARCHAR(100) 
		, [user_pseudo_id]					NVARCHAR(100)
		, [privacy_info]					NVARCHAR(MAX) AS JSON
		, [user_properties]					NVARCHAR(MAX) AS JSON
		, [user_first_touch_timestamp]		NVARCHAR(100)
		, [user_ltv]						NVARCHAR(MAX) AS JSON
		, [device]							NVARCHAR(MAX) AS JSON
		, [geo]								NVARCHAR(MAX) AS JSON
		, [app_info]						NVARCHAR(MAX) AS JSON 
		, [traffic_source]					NVARCHAR(MAX) AS JSON
		, [stream_id]						NVARCHAR(100)
		, [platform]						NVARCHAR(100)
		, [event_dimensions]				NVARCHAR(100)
		, [ecommerce]						NVARCHAR(MAX) AS JSON
		, [items]							NVARCHAR(MAX) AS JSON
	)
) ;
GO

/* event_params 列を展開するための関数 */
CREATE FUNCTION [dbo].[tvf_event_params](@param1 NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN 
(
	SELECT
		[key]
		, CASE
		WHEN [value1] IS NOT NULL THEN [value1]
		WHEN [value2] IS NOT NULL THEN [value2]
		WHEN [value3] IS NOT NULL THEN [value3]
		WHEN [value4] IS NOT NULL THEN [value4]
		END AS [value]
	FROM OPENJSON (@param1)
	WITH (
		[key]							NVARCHAR(MAX) '$.key'
		, [value1]						NVARCHAR(100) '$.value.string_value'
		, [value2]						NVARCHAR(100) '$.value.int_value'
		, [value3]						NVARCHAR(100) '$.value.double_value'
		, [value4]						NVARCHAR(100) '$.value.float_value'
	)
) ;
GO

/* privacy_info 列を展開するための関数 */
CREATE FUNCTION [dbo].[tvf_privacy_info](@param1 NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN 
(
	SELECT
		[ads_storage]
		, [analytics_storage]
		, [uses_transient_token]
	FROM OPENJSON (@param1)
	WITH (
		[ads_storage]						NVARCHAR(100) '$.ads_storage'
		, [analytics_storage]				NVARCHAR(100) '$.analytics_storage'
		, [uses_transient_token]			NVARCHAR(100) '$.uses_transient_token'
	)
) ;
GO

/* user_properties 列を展開するための関数 */
CREATE FUNCTION [dbo].[tvf_user_properties](@param1 NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN 
(
	SELECT
		[key]
		, CASE
		WHEN [value1] IS NOT NULL THEN [value1]
		WHEN [value2] IS NOT NULL THEN [value2]
		WHEN [value3] IS NOT NULL THEN [value3]
		WHEN [value4] IS NOT NULL THEN [value4]
		END AS [value]
		, [set_timestamp_micros]
	FROM OPENJSON (@param1)
	WITH (
		[key]								NVARCHAR(MAX) '$.key'
		, [value1]							NVARCHAR(100) '$.value.string_value'
		, [value2]							NVARCHAR(100) '$.value.int_value'
		, [value3]							NVARCHAR(100) '$.value.double_value'
		, [value4]							NVARCHAR(100) '$.value.float_value'
		, [set_timestamp_micros]			BIGINT        '$.value.set_timestamp_micros'
	)
) ;
GO

/* user_ltv 列を展開するための関数 */
CREATE FUNCTION [dbo].[tvf_user_ltv](@param1 NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN 
(
	SELECT
		[revenue]
		, [currency]
	FROM OPENJSON (@param1)
	WITH (
		[revenue]						NVARCHAR(100) '$.revenue'
		, [currency]					NVARCHAR(100) '$.currency'
	)
) ;
GO

/* device 列を展開するための関数 */
CREATE FUNCTION [dbo].[tvf_device](@param1 NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN 
(
	SELECT
		[category]
		, [mobile_brand_name]
		, [mobile_model_name]
		, [mobile_marketing_name]
		, [mobile_os_hardware_model]
		, [operating_system]
		, [operating_system_version]
		, [vendor_id]
		, [advertising_id]
		, [language]
		, [time_zone_offset_seconds]
		, [is_limited_ad_tracking]
		, [web_info.browser]
		, [web_info.browser_version]
		, [web_info.hostname]
	FROM OPENJSON (@param1)
	WITH (
		[category]						NVARCHAR(100) '$.category'
		, [mobile_brand_name]			NVARCHAR(100) '$.mobile_brand_name'
		, [mobile_model_name]			NVARCHAR(100) '$.mobile_model_name'
		, [mobile_marketing_name]		NVARCHAR(100) '$.mobile_marketing_name'
		, [mobile_os_hardware_model]	NVARCHAR(100) '$.mobile_os_hardware_model'
		, [operating_system]			NVARCHAR(100) '$.operating_system'
		, [operating_system_version]	NVARCHAR(100) '$.operating_system_version'
		, [vendor_id]					NVARCHAR(100) '$.vendor_id'
		, [advertising_id]				NVARCHAR(100) '$.advertising_id'
		, [language]					NVARCHAR(100) '$.language'
		, [time_zone_offset_seconds]	BIGINT        '$.time_zone_offset_seconds'
		, [is_limited_ad_tracking]		NVARCHAR(100) '$.is_limited_ad_tracking'
		, [web_info.browser]			NVARCHAR(100) '$.web_info.browser'
		, [web_info.browser_version]	NVARCHAR(100) '$.web_info.browser_version'
		, [web_info.hostname]			NVARCHAR(100) '$.web_info.hostname'
	)
) ;
GO

/* geo 列 列を展開するための関数 */
CREATE FUNCTION [dbo].[tvf_geo](@param1 NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN
(
	SELECT
		[continent]
		, [sub_continent]
		, [country]
		, [region]
		, [metro]
		, [city]
	FROM OPENJSON (@param1)
	WITH (
		[continent]						NVARCHAR(100) '$.continent'
		, [sub_continent]				NVARCHAR(100) '$.sub_continent'
		, [country]						NVARCHAR(100) '$.country'
		, [region]						NVARCHAR(100) '$.region'
		, [metro]						NVARCHAR(100) '$.metro'
		, [city]						NVARCHAR(100) '$.city'
	)
) ;
GO

/* app_info 列 列を展開するための関数 */
CREATE FUNCTION [dbo].[tvf_app_info](@param1 NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN
(
	SELECT
		[id]
		, [firebase_app_id]
		, [install_source]
		, [version]
		, [install_store]
	FROM OPENJSON (@param1)
	WITH (
		[id]							NVARCHAR(100) '$.id'
		, [firebase_app_id]				NVARCHAR(100) '$.firebase_app_id'
		, [install_source]				NVARCHAR(100) '$.install_source'
		, [version]						NVARCHAR(100) '$.version'
		, [install_store]				NVARCHAR(100) '$.install_store'
	)
) ;
GO

/* traffice_source 列を展開するための関数 */
CREATE FUNCTION [dbo].[tvf_traffic_source](@param1 NVARCHAR(max))
RETURNS TABLE
AS
RETURN 
(
	SELECT
		[name]
		, [medium]
		, [source]
	FROM OPENJSON (@param1)
	WITH (
		[name]							NVARCHAR(100) '$.name'
		, [medium]						NVARCHAR(100) '$.medium'
		, [source]						NVARCHAR(100) '$.source'
	)
) ;
GO

/* ecommerce 列を展開するための関数 */
CREATE FUNCTION [dbo].[tvf_ecommerce](@param1 NVARCHAR(max))
RETURNS TABLE
AS
RETURN 
(
	SELECT
		[total_item_quantity]
		, [purchase_revenue_in_usd]
		, [purchase_revenue]
		, [refund_value_in_usd]
		, [refund_value]
		, [shipping_value_in_usd]
		, [shipping_value]
		, [tax_value_in_usd]
		, [tax_value]
		, [transaction_id]
		, [unique_items]
	FROM OPENJSON (@param1)
	WITH (
		[total_item_quantity]			BIGINT        '$.total_item_quantity'
		, [purchase_revenue_in_usd]		NVARCHAR(100) '$.purchase_revenue_in_usd'
		, [purchase_revenue]			NVARCHAR(100) '$.purchase_revenue'
		, [refund_value_in_usd]			NVARCHAR(100) '$.refund_value_in_usd'
		, [refund_value]				NVARCHAR(100) '$.refund_value'
		, [shipping_value_in_usd]		NVARCHAR(100) '$.shipping_value_in_usd'
		, [shipping_value]				NVARCHAR(100) '$.shipping_value'
		, [tax_value_in_usd]			NVARCHAR(100) '$.tax_value_in_usd'
		, [tax_value]					NVARCHAR(100) '$.tax_value'
		, [transaction_id]				NVARCHAR(100) '$.transaction_id'
		, [unique_items]				BIGINT        '$.unique_items'
	)
) ;
GO

/* items 列を展開するための関数 */
CREATE FUNCTION [dbo].[tvf_items](@param1 NVARCHAR(max))
RETURNS TABLE
AS
RETURN 
(
	SELECT
		[item_id]
		, [item_name]
		, [item_brand]
		, [item_variant]
		, [item_category]
		, [item_category2]
		, [item_category3]
		, [item_category4]
		, [item_category5]
		, [price_in_usd]
		, [price]
		, [quantity]
		, [item_revenue_in_usd]
		, [item_revenue]
		, [item_refund_in_usd]
		, [item_refund]
		, [coupon]
		, [affiliation]
		, [location_id]
		, [item_list_id]
		, [item_list_name]
		, [item_list_index]
		, [promotion_id]
		, [promotion_name]
		, [creative_name]
		, [creative_slot]
	FROM OPENJSON (@param1)
	WITH (
		[item_id]						NVARCHAR(100) '$.item_id'
		, [item_name]					NVARCHAR(100) '$.item_name'
		, [item_brand]					NVARCHAR(100) '$.item_brand'
		, [item_variant]				NVARCHAR(100) '$.item_variant'
		, [item_category]				NVARCHAR(100) '$.item_category'
		, [item_category2]				NVARCHAR(100) '$.item_category2'
		, [item_category3]				NVARCHAR(100) '$.item_category3'
		, [item_category4]				NVARCHAR(100) '$.item_category4'
		, [item_category5]				NVARCHAR(100) '$.item_category5'
		, [price_in_usd]				NVARCHAR(100) '$.price_in_usd'
		, [price]						NVARCHAR(100) '$.price'
		, [quantity]					BIGINT        '$.quantity'
		, [item_revenue_in_usd]			NVARCHAR(100) '$.item_revenue_in_usd'
		, [item_revenue]				NVARCHAR(100) '$.item_revenue'
		, [item_refund_in_usd]			NVARCHAR(100) '$.item_refund_in_usd'
		, [item_refund]					NVARCHAR(100) '$.item_refund'
		, [coupon]						NVARCHAR(100) '$.coupon'
		, [affiliation]					NVARCHAR(100) '$.affiliation'
		, [location_id]					NVARCHAR(100) '$.location_id'
		, [item_list_id]				NVARCHAR(100) '$.item_list_id'
		, [item_list_name]				NVARCHAR(100) '$.item_list_name'
		, [item_list_index]				NVARCHAR(100) '$.item_list_index'
		, [promotion_id]				NVARCHAR(100) '$.promotion_id'
		, [promotion_name]				NVARCHAR(100) '$.promotion_name'
		, [creative_name]				NVARCHAR(100) '$.creative_name'
		, [creative_slot]				NVARCHAR(100) '$.creative_slot'
	)
) ;
GO

