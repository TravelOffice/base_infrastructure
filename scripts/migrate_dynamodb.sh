#!/bin/bash
set -e
page=1
AWS_REGION=ap-southeast-1

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 [SOURCE_TABLE_NAME] [DESTINATION_TABLE_NAME]" >&2
  exit 1
fi
SOURCE_TABLE_NAME=$1
DESTINATION_TABLE_NAME=$2

echo "Copying all rows from $SOURCE_TABLE_NAME to $DESTINATION_TABLE_NAME, 25 rows at a time"
while : ; do # do .. while equivalent
    echo "  Scanning page $page, up to 25 records in $SOURCE_TABLE_NAME table"
    scan_result=$(aws dynamodb scan --region=$AWS_REGION \
        --table-name $SOURCE_TABLE_NAME \
        --page-size 1 \
        --max-items 25 \
        $starting_token)

    # Transform the scan result to a PutRequest:
    put_req_json=$(echo $scan_result | jq '[.Items | .[] | { PutRequest: { Item: . } }]')
    # Get number of records:
    rec_count=$(echo $put_req_json | jq 'length')
    # Get pagination token:
    next_token=$(echo "$scan_result" | jq '.NextToken' -r)
    # Set starting_token for next iteration (blank on first iteration)
    starting_token="--starting-token $next_token"

    echo "  Writing $rec_count records to temporary file"
    tmp_file_name="$DESTINATION_TABLE_NAME.$page.json"
    echo '{
        "'${DESTINATION_TABLE_NAME}'": '"${put_req_json}"'
    }' > "$DESTINATION_TABLE_NAME.$page.json"

    echo "  Writing $rec_count to $DESTINATION_TABLE_NAME"
    aws dynamodb batch-write-item \
        --region=$AWS_REGION \
        --request-items file://"$tmp_file_name" \
    | sed 's/^/  /' # Indent output

    echo "  Deleting temporary file"
    rm "$tmp_file_name"

    # Break loop, if no more pages
    [[ "$next_token" != "null" ]] || break
    # Increment page count
    ((page++))
done

echo "Copied all rows from $SOURCE_TABLE_NAME to $DESTINATION_TABLE_NAME"
