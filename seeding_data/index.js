import AWS from "aws-sdk";
import {
  DEFAULT_PERMISSIONS,
  DEFAULT_WHITELIST,
  DEFAULT_ROLES,
} from "./data.js";

const dynamodb = new AWS.DynamoDB({
  apiVersion: "2012-08-10",
  region: "ap-southeast-1",
});

const ROLE_INDEX = "ROLE";
const PERMISSION_INDEX = "PERMISSION";
const WHITELIST_INDEX = "PERMISSION#WHITELIST";

const main = async () => {
  // Init default permissions
  await writePermissionToDynamo(
    DEFAULT_PERMISSIONS.table,
    DEFAULT_PERMISSIONS.groups.concat([]),
    PERMISSION_INDEX,
    PERMISSION_INDEX
  );
  // Init default whitelist
  await writePermissionToDynamo(
    DEFAULT_WHITELIST.table,
    DEFAULT_WHITELIST.groups.concat([]),
    WHITELIST_INDEX,
    PERMISSION_INDEX
  );
  // Init default role
  await writeRoleToDynamo();
};

const writePermissionToDynamo = async (table, records, pk, skPrefix) => {
  while (records.length > 0) {
    const record = records.splice(0, 25);
    let requestItems = {};
    requestItems[`${process.env.BUILD_ENV}-${table}`] = record.map((item) => {
      return {
        PutRequest: {
          Item: AWS.DynamoDB.Converter.marshall({
            pk: pk,
            sk: `${skPrefix}#${item.name}`,
            ...item,
          }),
        },
      };
    });
    await dynamodb.batchWriteItem({ RequestItems: requestItems }).promise();
  }
};

const writeRoleToDynamo = async () => {
  const requestItems = {};
  const defaultPermissions = listDefaultPermissions();
  requestItems[`${process.env.BUILD_ENV}-${DEFAULT_ROLES.table}`] =
    DEFAULT_ROLES.roles.map((role) => {
      let { permissions } = role;
      if (role.extend) {
        const sourceRole = DEFAULT_ROLES.roles.find((x) =>
          role.extend.includes(x.name)
        );
        if (sourceRole) {
          permissions = permissions.concat(sourceRole.permissions);
          permissions = permissions.filter(
            (item, index) => permissions.indexOf(item) === index
          );
        }
      }
      permissions = permissions.map(permission => {
        return defaultPermissions.find(item => item.name === permission);
      })
      return {
        PutRequest: {
          Item: AWS.DynamoDB.Converter.marshall({
            pk: ROLE_INDEX,
            sk: `${ROLE_INDEX}#${role.name}`,
            extend: role.extend,
            isDefault: role.isDefault,
            permissions,
          }),
        },
      };
    });
  await dynamodb.batchWriteItem({ RequestItems: requestItems }).promise();
};

const listDefaultPermissions = () => {
  let permissions = [];
  DEFAULT_PERMISSIONS.groups.forEach((group) => {
    permissions = permissions.concat(group.permissions);
  })
  return permissions;
}

main();
