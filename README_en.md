# azure-synapse-ga4-data-pipeline
This is a script for importing GA4 data into Azure Synapse Dedicated SQL Pool.

## Scenarios Supported by the Script
The script is designed for the scenario where GA4 JSON data needs to be imported into Azure Synapse Analytics Pipeline, with each record as a single line string, into the Synapse Dedicated SQL Pool.

The data will be registered in the Synapse Dedicated SQL Pool in the following format:

| json_line (DATA_TYPE:NVARCHAR(MAX))|
|---|
|{"event_date":"20201227","event_timestamp":"1609039659225742","event_name":"view_promotion"," ･･･ |

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
