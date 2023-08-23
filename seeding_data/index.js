import AWS from 'aws-sdk';
import {
  DEFAULT_PERMISSIONS,
  DEFAULT_WHITELIST,
  DEFAULT_ROLES,
  TO_TABLE,
} from './to_data.js';

import {
  MK_DEFAULT_PERMISSIONS,
  MK_DEFAULT_WHITELIST,
  MK_DEFAULT_ROLES,
  MK_TABLE,
} from './marketplace_data.js';

const dynamodb = new AWS.DynamoDB({
  apiVersion: '2012-08-10',
  region: 'ap-southeast-1',
});

const ROLE_INDEX = 'ROLE';
const PERMISSION_INDEX = 'PERMISSION';
const WHITELIST_INDEX = 'PERMISSION#WHITELIST';

const main = async () => {
  await initTravelOfficeInfo();
  await initMarketplaceInfo();
};

const initTravelOfficeInfo = async () => {
  // Init default permissions
  await writePermissionToDynamo(
    TO_TABLE,
    DEFAULT_PERMISSIONS.groups.concat([]),
    PERMISSION_INDEX,
    PERMISSION_INDEX
  );
  // Init default whitelist
  await writePermissionToDynamo(
    TO_TABLE,
    DEFAULT_WHITELIST.groups.concat([]),
    WHITELIST_INDEX,
    PERMISSION_INDEX
  );
  // Init default role
  await writeRoleToDynamo(
    TO_TABLE,
    listDefaultPermissions(DEFAULT_PERMISSIONS),
    DEFAULT_ROLES.roles,
  );
}

const initMarketplaceInfo = async () => {
  // Init default permissions
  await writePermissionToDynamo(
    MK_TABLE,
    MK_DEFAULT_PERMISSIONS.groups.concat([]),
    PERMISSION_INDEX,
    PERMISSION_INDEX
  );
  // Init default whitelist
  await writePermissionToDynamo(
    MK_TABLE,
    MK_DEFAULT_WHITELIST.groups.concat([]),
    WHITELIST_INDEX,
    PERMISSION_INDEX
  );
  // Init default role
  await writeRoleToDynamo(
    MK_TABLE,
    listDefaultPermissions(MK_DEFAULT_PERMISSIONS),
    MK_DEFAULT_ROLES.roles,
  );
}

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

const writeRoleToDynamo = async (table, defaultPermissions, defaultRoles) => {
  const requestItems = {};
  requestItems[`${process.env.BUILD_ENV}-${table}`] =
    defaultRoles.map((role) => {
      let { permissions } = role;
      if (role.extend) {
        const sourceRoles = defaultRoles.filter((x) =>
          role.extend.includes(x.name)
        );
        sourceRoles.map((sourceRole) => {
          permissions = permissions.concat(sourceRole.permissions);
          permissions = permissions.filter(
            (item, index) => permissions.indexOf(item) === index
          );
        })
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

const listDefaultPermissions = (defaultPermissions) => {
  let permissions = [];
  defaultPermissions.groups.forEach((group) => {
    permissions = permissions.concat(group.permissions);
  })
  return permissions;
}

main();
