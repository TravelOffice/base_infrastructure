const fs = require('fs');
const path = require('path');
const AWS = require('aws-sdk');

const dynamodb = new AWS.DynamoDB({
  apiVersion: '2012-08-10',
  region: 'ap-southeast-1'
});

const PERMISSION_INDEX = 'PERMISSION';

const main = async () => {
  const { table, permissions } = JSON.parse(fs.readFileSync(path.resolve(__dirname, 'permissions.json'), 'utf-8'));
  while (permissions.length > 0) {
    const chunk = permissions.splice(0, 25)
    await batchWriteToDynamo(table, chunk)
  }
}

const batchWriteToDynamo = async (table, permissions) => {
  let requestItems = {};
  requestItems[`${process.env.ENV}-${table}`] = permissions.map(permission => {
    return {
      PutRequest: {
        Item: AWS.DynamoDB.Converter.marshall({
          pk: PERMISSION_INDEX,
          sk: `${PERMISSION_INDEX}#${permission.name}`,
          action: permission.action,
          path: permission.path
        })
      }
    }
  });
  await dynamodb.batchWriteItem({ RequestItems: requestItems }).promise();
}

main();
