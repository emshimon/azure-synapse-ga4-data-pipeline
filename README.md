# azure-synapse-ga4-data-pipeline
<English Follows>  
GA4 のデータを Azure Synapse 専用 SQL Pool に取り込むためのスクリプトとなります｡


## スクリプトが使用できるシナリオ
GA4 の JSON データを Azure Synaapse Analytics Pipeline のコピー アクティビティを使用して､1つのレコードを 1 行の文字列として Synapse 専用 SQL Pool に取り込む必要があります｡

Synapse 専用 SQL Pool 上ににデータをこのような形で登録します
| json_line (DATA_TYPE:NVARCHAR(MAX))|
|---|
|{"event_date":"20201227","event_timestamp":"1609039659225742","event_name":"view_promotion","event_params":[{"key":"engaged_session_event","value":{"int_va ･･･ |

Synapse Pipeline 構成方法も含めた､スクリプトの使用方法の手順は後日公開予定です｡


## 公開されているスクリプトの概要
スクリプトには以下の 4 種類のファイルが含まれます｡
- create_functions.sql
  - GA 4 の JSON データを Synapse 専用 SQL Pool 上に取り込む際に使用する関数定義が記載されたスクリプトです
- check_function.sql
  - create_functions.sql で定義された関数の動作を確認するためのスクリプトです
- create_table.sql
  - データを取り込む過程で必要となる一時的なテーブルを作成するためのスクリプトです
- data_processing.sql
  - Synapse Pipeline により取り込んだ文字列からデータ加工しやすい形に生成するスクリプトです｡ 加工後に目的の項目を抽出するためのサンプルスクリプトも記載しています｡


# azure-synapse-ga4-data-pipeline
This is a script for importing GA4 data into Azure Synapse Dedicated SQL Pool.

## Scenarios Supported by the Script
The script is designed for the scenario where GA4 JSON data needs to be imported into Azure Synapse Analytics Pipeline, with each record as a single line string, into the Synapse Dedicated SQL Pool.

The data will be registered in the Synapse Dedicated SQL Pool in the following format:

| json_line (DATA_TYPE:NVARCHAR(MAX))|
|---|
|{"event_date":"20201227","event_timestamp":"1609039659225742","event_name":"view_promotion","event_params":[{"key":"engaged_session_event","value":{"int_va ･･･ |

Instructions on how to use the script, including Synapse Pipeline configuration, will be provided at a later date.


## Overview of the Provided Scripts
The script includes the following four files:
- create_functions.sql
  - This script contains function definitions used for importing GA4 JSON data into the Synapse Dedicated SQL Pool.
- check_function.sql
  - This script is used to test the functionality of the functions defined in create_functions.sql.
- create_table.sql
  - This script is used to create temporary tables required during the data import process.
- data_processing.sql
  - This script is used to transform the imported string into a format suitable for data processing. It also includes a sample script for extracting the desired fields after transformation.
