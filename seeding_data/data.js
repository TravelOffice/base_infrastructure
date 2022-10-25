export const DEFAULT_ROLES = {
  table: "role_permission_table",
  roles: [
    {
      name: "ROOT",
      extend: ["ADMIN"],
      isDefault: true,
      permissions: [],
    },
    {
      name: "ADMIN",
      isDefault: true,
      permissions: [
        {
          name: "link_page",
          title: "Link page",
          statements: [
            {
              path: "/facebook/link",
              action: "POST",
            },
            {
              path: "/zalo/link",
              action: "POST",
            },
            {
              action: "POST",
              path: "/telegram/link",
            },
          ],
        },
        {
          name: "unlink_page",
          title: "Unlink page",
          statements: [
            {
              path: "/admin/linked_pages",
              action: "DELETE",
            },
          ],
        },
        {
          name: "assign_chat",
          title: "Assign chat",
          statements: [
            {
              action: "POST",
              path: "/admin/assign-chat",
            },
          ],
        },
        {
          name: "view_all_conversations",
          title: "View all conversations",
          statements: [
            {
              path: "adminAllFbConversations",
            },
            {
              path: "adminAllZaloConversations",
            },
            {
              path: "adminAllTelegramConversations",
            },
            {
              action: "GET",
              path: "/admin/linked_pages",
            },
          ],
        },
        {
          name: "view_message",
          title: "View message",
          statements: [
            {
              path: "allFbMessages",
            },
            {
              path: "allZaloMessages",
            },
            {
              path: "allTelegramMessages",
            },
            {
              path: "getTelegramFileInfo",
            },
            {
              path: "userProfile",
            },
            {
              path: "onNewMessageReceived",
            },
          ],
        },
        {
          name: "read_user",
          title: "Read",
          statements: [
            {
              action: "GET",
              path: "/users/{userId}",
            },
          ],
        },
        {
          name: "create_user",
          title: "Create",
          statements: [
            {
              action: "POST",
              path: "/users",
            },
          ],
        },
        {
          name: "update_user",
          title: "Update",
          statements: [
            {
              action: "PUT",
              path: "/users/{userId}",
            },
          ],
        },
        {
          name: "delete_user",
          title: "Delete",
          statements: [
            {
              action: "DELETE",
              path: "/users/{userId}",
            },
          ],
        },
        {
          name: "view_all_users",
          title: "View all",
          statements: [
            {
              action: "GET",
              path: "/users",
            },
          ],
        },
        {
          name: "view_permission",
          title: "View Permissions",
          statements: [
            {
              path: "/admin/permissions",
              action: "GET",
            },
          ],
        },
        {
          name: "get_roles",
          title: "View Roles",
          statements: [
            {
              path: "/admin/roles",
              action: "GET",
            },
          ],
        },
        {
          name: "create_role",
          title: "Create Role",
          statements: [
            {
              path: "/admin/roles",
              action: "POST",
            },
          ],
        },
        {
          name: "update_role",
          title: "Update Role",
          statements: [
            {
              path: "/admin/roles/{roleName}",
              action: "PUT",
            },
          ],
        },
        {
          name: "delete_roles",
          title: "Delete Role",
          statements: [
            {
              path: "/admin/roles/{roleName}",
              action: "DELETE",
            },
          ]
        },
        {
          name: 'get_leads',
          title: 'View All Leads',
          statements: [
            {
              path: '/leads',
              action: 'GET'
            },
          ]
        },
        {
          name: 'create_lead',
          title: 'Create Lead',
          statements: [
            {
              path: '/leads',
              action: 'POST'
            },
          ]
        },
        {
          name: 'update_lead',
          title: 'Update Lead',
          statements: [
            {
              path: '/leads',
              action: 'PUT'
            },
          ]
        },
        {
          name: 'get_lead',
          title: 'View Lead',
          statements: [
            {
              path: '/leads/{leadID}',
              action: 'GET'
            },
          ]
        },
        {
          name: 'get_bookings',
          title: 'View All Bookings',
          statements: [
            {
              path: '/leads/{leadID}/bookings',
              action: 'GET'
            },
          ]
        },
        {
          name: 'view_opportunities_of_lead',
          title: 'View All Opportunities of Lead',
          statements: [
            {
              path: '/leads/{leadID}/opportunities',
              action: 'GET'
            },
          ]
        },
        {
          name: 'create_opportunity',
          title: 'Create Opportunity',
          statements: [
            {
              path: '/leads/{leadID}/opportunities',
              action: 'POST'
            },
          ]
        },
        {
          name: 'view_opportunity',
          title: 'View Opportunity',
          statements: [
            {
              path: '/leads/{leadID}/opportunities/{opportunityID}',
              action: 'GET'
            },
          ]
        },
        {
          name: 'update_opportunity',
          title: 'Update Opportunity',
          statements: [
            {
              path: '/leads/{leadID}/opportunities/{opportunityID}',
              action: 'PUT'
            },
          ]
        },
        {
          name: 'view_quotes',
          title: 'View All Quotes',
          statements: [
            {
              path: '/leads/{leadID}/opportunities/{opportunityID}/quotes',
              action: 'GET'
            },
          ]
        },
        {
          name: 'view_opportunities_of_tenant',
          title: 'View All Opportunities of Tenant',
          statements: [
            {
              path: '/opportunities',
              action: 'GET'
            },
          ]
        },
        {
          name: 'delete_opportunity',
          title: 'Delete Opportunity',
          statements: [
            {
              path: '/opportunities/{id}',
              action: 'DELETE'
            },
          ]
        }
      ],
    },
    {
      name: "SALE",
      isDefault: true,
      permissions: [
        {
          name: "view_assigned_conversations",
          title: "View assigned conversations",
          statements: [
            {
              path: "allFbConversations",
            },
            {
              path: "allZaloConversations",
            },
            {
              path: "allTelegramConversations",
            },
            {
              action: "GET",
              path: "/admin/linked_pages",
            },
          ],
        },
        {
          name: "view_message",
          title: "View message",
          statements: [
            {
              path: "allFbMessages",
            },
            {
              path: "allZaloMessages",
            },
            {
              path: "allTelegramMessages",
            },
            {
              path: "getTelegramFileInfo",
            },
            {
              path: "userProfile",
            },
            {
              path: "onNewMessageReceived",
            },
          ],
        },
        {
          name: "send_message",
          title: "Send message",
          statements: [
            {
              path: "sendMessage",
            },
            {
              path: "/presigned-url",
              action: "GET",
            },
            {
              action: "GET",
              path: "/upload-file-to-chat-platform",
            },
          ],
        },
        {
          name: 'get_leads',
          title: 'View All Leads',
          statements: [
            {
              path: '/leads',
              action: 'GET'
            },
          ]
        },
        {
          name: 'create_lead',
          title: 'Create Lead',
          statements: [
            {
              path: '/leads',
              action: 'POST'
            },
          ]
        },
        {
          name: 'update_lead',
          title: 'Update Lead',
          statements: [
            {
              path: '/leads',
              action: 'PUT'
            },
          ]
        },
        {
          name: 'get_lead',
          title: 'View Lead',
          statements: [
            {
              path: '/leads/{leadID}',
              action: 'GET'
            },
          ]
        },
        {
          name: 'get_bookings',
          title: 'View All Bookings',
          statements: [
            {
              path: '/leads/{leadID}/bookings',
              action: 'GET'
            },
          ]
        },
        {
          name: 'view_opportunities_of_lead',
          title: 'View All Opportunities of Lead',
          statements: [
            {
              path: '/leads/{leadID}/opportunities',
              action: 'GET'
            },
          ]
        },
        {
          name: 'create_opportunity',
          title: 'Create Opportunity',
          statements: [
            {
              path: '/leads/{leadID}/opportunities',
              action: 'POST'
            },
          ]
        },
        {
          name: 'view_opportunity',
          title: 'View Opportunity',
          statements: [
            {
              path: '/leads/{leadID}/opportunities/{opportunityID}',
              action: 'GET'
            },
          ]
        },
        {
          name: 'update_opportunity',
          title: 'Update Opportunity',
          statements: [
            {
              path: '/leads/{leadID}/opportunities/{opportunityID}',
              action: 'PUT'
            },
          ]
        },
        {
          name: 'view_quotes',
          title: 'View All Quotes',
          statements: [
            {
              path: '/leads/{leadID}/opportunities/{opportunityID}/quotes',
              action: 'GET'
            },
          ]
        },
        {
          name: 'view_opportunities_of_tenant',
          title: 'View All Opportunities of Tenant',
          statements: [
            {
              path: '/opportunities',
              action: 'GET'
            },
          ]
        },
        {
          name: 'delete_opportunity',
          title: 'Delete Opportunity',
          statements: [
            {
              path: '/opportunities/{id}',
              action: 'DELETE'
            },
          ]
        }
      ],
    },
  ],
};

export const DEFAULT_PERMISSIONS = {
  table: "role_permission_table",
  groups: [
    {
      name: "Setting",
      permissions: [
        {
          name: "link_page",
          title: "Link page",
          statements: [
            {
              path: "/facebook/link",
              action: "POST",
            },
            {
              path: "/zalo/link",
              action: "POST",
            },
            {
              action: "POST",
              path: "/telegram/link",
            },
          ],
        },
        {
          name: "unlink_page",
          title: "Unlink page",
          statements: [
            {
              path: "/admin/linked_pages",
              action: "DELETE",
            },
          ],
        },
      ],
    },
    {
      name: "Chat",
      permissions: [
        {
          name: "assign_chat",
          title: "Assign chat",
          statements: [
            {
              action: "POST",
              path: "/admin/assign-chat",
            },
          ],
        },
        {
          name: "view_all_conversations",
          title: "View all conversations",
          statements: [
            {
              path: "adminAllFbConversations",
            },
            {
              path: "adminAllZaloConversations",
            },
            {
              path: "adminAllTelegramConversations",
            },
            {
              action: "GET",
              path: "/admin/linked_pages",
            },
          ],
        },
        {
          name: "view_assigned_conversations",
          title: "View assigned conversations",
          statements: [
            {
              path: "allFbConversations",
            },
            {
              path: "allZaloConversations",
            },
            {
              path: "allTelegramConversations",
            },
            {
              action: "GET",
              path: "/admin/linked_pages",
            },
          ],
        },
        {
          name: "view_message",
          title: "View message",
          statements: [
            {
              path: "allFbMessages",
            },
            {
              path: "allZaloMessages",
            },
            {
              path: "allTelegramMessages",
            },
            {
              path: "getTelegramFileInfo",
            },
            {
              path: "userProfile",
            },
            {
              path: "onNewMessageReceived",
            },
          ],
        },
        {
          name: "send_message",
          title: "Send message",
          statements: [
            {
              path: "sendMessage",
            },
            {
              path: "/presigned-url",
              action: "GET",
            },
            {
              action: "GET",
              path: "/upload-file-to-chat-platform",
            },
          ],
        },
      ],
    },
    {
      name: "User",
      permissions: [
        {
          name: "read_user",
          title: "Read",
          statements: [
            {
              action: "GET",
              path: "/users/{userId}",
            },
          ],
        },
        {
          name: "create_user",
          title: "Create",
          statements: [
            {
              action: "POST",
              path: "/users",
            },
          ],
        },
        {
          name: "update_user",
          title: "Update",
          statements: [
            {
              action: "PUT",
              path: "/users/{userId}",
            },
          ],
        },
        {
          name: "delete_user",
          title: "Delete",
          statements: [
            {
              action: "DELETE",
              path: "/users/{userId}",
            },
          ],
        },
        {
          name: "view_all_users",
          title: "View all",
          statements: [
            {
              action: "GET",
              path: "/users",
            },
          ],
        },
      ],
    },
    {
      name: "Role Permissions",
      permissions: [
        {
          name: "get_permissions",
          title: "View Permissions",
          statements: [
            {
              path: "/admin/permissions",
              action: "GET",
            },
          ],
        },
        {
          name: "get_roles",
          title: "View Roles",
          statements: [
            {
              path: "/admin/roles",
              action: "GET",
            },
          ],
        },
        {
          name: "create_roles",
          title: "Create Role",
          statements: [
            {
              path: "/admin/roles",
              action: "POST",
            },
          ],
        },
        {
          name: "update_role",
          title: "Update Role",
          statements: [
            {
              path: "/admin/roles/{roleName}",
              action: "PUT",
            },
          ],
        },
        {
          name: "delete_roles",
          title: "Delete Role",
          statements: [
            {
              path: "/admin/roles/{roleName}",
              action: "DELETE",
            },
          ]
        }
      ]
    },
    {
      name: 'Lead',
      permissions: [
        {
          name: 'get_leads',
          title: 'View All Leads',
          statements: [
            {
              path: '/leads',
              action: 'GET'
            },
          ]
        },
        {
          name: 'create_lead',
          title: 'Create Lead',
          statements: [
            {
              path: '/leads',
              action: 'POST'
            },
          ]
        },
        {
          name: 'update_lead',
          title: 'Update Lead',
          statements: [
            {
              path: '/leads',
              action: 'PUT'
            },
          ]
        },
        {
          name: 'get_lead',
          title: 'View Lead',
          statements: [
            {
              path: '/leads/{leadID}',
              action: 'GET'
            },
          ]
        }
      ]
    },
    {
      name: 'Booking',
      permissions: [
        {
          name: 'get_bookings',
          title: 'View All Bookings',
          statements: [
            {
              path: '/leads/{leadID}/bookings',
              action: 'GET'
            },
          ]
        },
      ]
    },
    {
      name: 'Quotes',
      permissions: [
        {
          name: 'view_quotes',
          title: 'View All Quotes',
          statements: [
            {
              path: '/leads/{leadID}/opportunities/{opportunityID}/quotes',
              action: 'GET'
            },
          ]
        }
      ]
    },
    {
      name: 'Opportunities',
      permissions: [
        {
          name: 'view_opportunities_of_tenant',
          title: 'View All Opportunities of Tenant',
          statements: [
            {
              path: '/opportunities',
              action: 'GET'
            },
          ]
        },
        {
          name: 'view_opportunities_of_lead',
          title: 'View All Opportunities of Lead',
          statements: [
            {
              path: '/leads/{leadID}/opportunities',
              action: 'GET'
            },
          ]
        },
        {
          name: 'create_opportunity',
          title: 'Create Opportunity',
          statements: [
            {
              path: '/leads/{leadID}/opportunities',
              action: 'POST'
            },
          ]
        },
        {
          name: 'view_opportunity',
          title: 'View Opportunity',
          statements: [
            {
              path: '/leads/{leadID}/opportunities/{opportunityID}',
              action: 'GET'
            },
          ]
        },
        {
          name: 'update_opportunity',
          title: 'Update Opportunity',
          statements: [
            {
              path: '/leads/{leadID}/opportunities/{opportunityID}',
              action: 'PUT'
            },
          ]
        },
        {
          name: 'delete_opportunity',
          title: 'Delete Opportunity',
          statements: [
            {
              path: '/opportunities/{id}',
              action: 'DELETE'
            },
          ]
        }
      ]
    }
  ]
}

export const DEFAULT_WHITELIST = {
  table: "role_permission_table",
  groups: [
    {
      name: "Me",
      permissions: [
        {
          name: "read",
          title: "Read",
          statements: [
            {
              action: "GET",
              path: "/me",
            },
          ],
        },
        {
          name: "update",
          title: "Update",
          statements: [
            {
              action: "PUT",
              path: "/me",
            },
          ],
        },
      ],
    },
    {
      name: "Common",
      permissions: [
        {
          name: "sendAndSubscribeNewNotification",
          title: "Send / subscribe new notification",
          statements: [
            { path: "onNewNotificationReceived" },
            { path: "sendNotification" },
            { path: "syncEmail" }
          ],
        },
      ],
    },
  ],
};
