/* テーブル値関数テスト用スクリプト */
/* tvf_data_processing 関数チェック */
DECLARE @samplejson nvarchar(MAX) = N'{
  "event_date": "20210128",
  "event_timestamp": "1611798022695757",
  "event_name": "page_view",
  "event_params": [
    {
      "key": "page_location",
      "value": { "string_value": "https://shop.googlemerchandisestore.com/payment.html" }
    },
    {
      "key": "debug_mode",
      "value": { "int_value": "1" }
    },
    {
      "key": "page_referrer",
      "value": { "string_value": "https://shop.googlemerchandisestore.com/payment.html?" }
    },
    {
      "key": "session_engaged",
      "value": { "string_value": "1" }
    },
    {
      "key": "page_title",
      "value": { "string_value": "Payment Method" }
    },
    {
      "key": "engagement_time_msec",
      "value": { "int_value": "7" }
    },
    {
      "key": "engaged_session_event",
      "value": { "int_value": "1" }
    },
    {
      "key": "ga_session_id",
      "value": { "int_value": "3599645542" }
    },
    {
      "key": "ga_session_number",
      "value": { "int_value": "1" }
    }
  ],
  "event_bundle_sequence_id": "7658063987",
  "user_pseudo_id": "1146540.1921992520",
  "privacy_info": { "uses_transient_token": "No" },
  "user_properties": [],
  "user_first_touch_timestamp": "1611797439727581",
  "user_ltv": {
    "revenue": 0,
    "currency": "USD"
  },
  "device": {
    "category": "desktop",
    "mobile_brand_name": "Google",
    "mobile_model_name": "Chrome",
    "mobile_marketing_name": "\u003cOther\u003e",
    "operating_system": "Web",
    "operating_system_version": "10",
    "language": "en-us",
    "is_limited_ad_tracking": "No",
    "web_info": {
      "browser": "Chrome",
      "browser_version": "86.0"
    }
  },
  "geo": {
    "continent": "Americas",
    "sub_continent": "Northern America",
    "country": "United States",
    "region": "Florida",
    "city": "(not set)",
    "metro": "(not set)"
  },
  "traffic_source": {
    "medium": "(none)",
    "name": "(direct)",
    "source": "(direct)"
  },
  "stream_id": "2100450278",
  "platform": "WEB",
  "ecommerce": {},
  "items": []
}'

--SELECT ISJSON(@samplejson)
SELECT * FROM [dbo].[tvf_data_processing] (@samplejson) ;
GO

/* tvf_event_params 関数チェック */
DECLARE @eventparam nvarchar(MAX) = N'[
      {
        "key": "session_engaged",
        "value": { "int_value": "1" }
      },
      {
        "key": "page_title",
        "value": { "string_value": "Apparel | Google Merchandise Store" }
      },
      {
        "key": "ga_session_id",
        "value": { "int_value": "6267689519" }
      }
    ]'

--SELECT ISJSON(@eventparam)
SELECT * FROM [dbo].[tvf_event_params] (@eventparam) ;
GO

/*tvf_privacy_info 関数チェック*/
DECLARE @privacyjson nvarchar(MAX) = N'{ "uses_transient_token": "No" }'

--SELECT ISJSON(@privacyjson)
SELECT * FROM [dbo].[tvf_privacy_info] (@privacyjson) ;
GO

/* tvf_user_properties 関数チェック */
DECLARE @userpropertiesjson nvarchar(MAX) = N'[
    {
      "key": "uid_sample",
      "value": {
        "string_value": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
        "set_timestamp_micros": "1234567890123456"
      }
    }
  ]'
--SELECT ISJSON(@userpropertiesjson)
SELECT * FROM [dbo].[tvf_user_properties] (@userpropertiesjson) ;
GO

/* tvf_user_ltv 関数チェック*/
DECLARE @userltvjson nvarchar(MAX) = N'{
    "revenue": 0,
    "currency": "USD"
  }'

--SELECT ISJSON(@userltvjson)
SELECT * FROM [dbo].[tvf_user_ltv] (@userltvjson) ;
GO


/* tvf_device 関数チェック */
DECLARE @devicejson nvarchar(MAX) = N'{
    "category": "desktop",
    "mobile_brand_name": "Google",
    "mobile_model_name": "Chrome",
    "mobile_marketing_name": "\u003cOther\u003e",
    "operating_system": "Web",
    "operating_system_version": "10",
    "language": "en-us",
    "is_limited_ad_tracking": "No",
    "web_info": {
      "browser": "Chrome",
      "browser_version": "86.0"
    }
  }'

--SELECT ISJSON(@devicejson)
SELECT * FROM dbo.tvf_device (@devicejson) ;
GO


/* tvf_geo 関数チェック */
DECLARE @geojson nvarchar(MAX) = N'{
    "continent": "Asia",
    "sub_continent": "Southern Asia",
    "country": "India",
    "region": "Uttar Pradesh",
    "city": "Lucknow",
    "metro": "(not set)"
  }'

--SELECT ISJSON(@geojson)
SELECT * FROM [dbo].[tvf_geo] (@geojson) ;
GO

/* tvf_app_info 関数チェック*/
DECLARE @appjson nvarchar(MAX) = N'{
  "id": "abcd1234",
  "version": "1.0.0",
  "install_store": "Google Play",
  "firebase_app_id": "firebase1234"
}'

--SELECT ISJSON(@appjson)
SELECT * FROM [dbo].[tvf_app_info] (@appjson) ;
GO

/* tvf_traffic_source 関数チェック */
DECLARE @trafficjson nvarchar(MAX) = N'{
    "medium": "(none)",
    "name": "(direct)",
    "source": "(direct)"
  }'

--SELECT ISJSON(@trafficjson)
SELECT * FROM dbo.tvf_traffic_source (@trafficjson) ;
GO

/* tvf_ecommerce  関数チェック */
DECLARE @ecommercejson nvarchar(MAX) = N'{
    "unique_items": "1",
    "transaction_id": "(not set)"
  }'

--SELECT ISJSON(@ecommercejson)
SELECT * FROM dbo.tvf_ecommerce (@ecommercejson) ;
GO


/* tvf_items 関数チェック */
DECLARE @itemjson nvarchar(MAX) = N'[
    {
      "item_id": "(not set)",
      "item_name": "(not set)",
      "item_brand": "(not set)",
      "item_variant": "(not set)",
      "item_category": "(not set)",
      "item_category2": "(not set)",
      "item_category3": "(not set)",
      "item_category4": "(not set)",
      "item_category5": "(not set)",
      "coupon": "(not set)",
      "affiliation": "(not set)",
      "location_id": "(not set)",
      "item_list_id": "(not set)",
      "item_list_name": "(not set)",
      "item_list_index": "Slide 3",
      "promotion_id": "(not set)",
      "promotion_name": "Complete Your Collection",
      "creative_name": "Front Page Carousel",
      "creative_slot": "(not set)"
    }
  ]'

--SELECT ISJSON(@itemjson)
SELECT * FROM [dbo].[tvf_items] (@itemjson) ;
GO


/* udf_time 関数チェック */
DECLARE @timestamp nvarchar(MAX)= N'1234567890123456'
SELECT [dbo].[udf_time](@timestamp)
GO
