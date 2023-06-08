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
