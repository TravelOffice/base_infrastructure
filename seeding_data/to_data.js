export const TO_TABLE = 'role_permission_table';

export const DEFAULT_ROLES = {
  roles: [
    {
      name: 'ROOT',
      extend: ['ADMIN', 'SALE', 'OPERATOR', 'OPERATOR_MANAGER'],
      isDefault: true,
      permissions: [],
    },
    {
      name: 'ADMIN',
      extend: ['OPERATOR', 'OPERATOR_MANAGER'],
      isDefault: true,
      permissions: [
        'link_page',
        'unlink_page',
        'assign_chat',
        'view_all_conversations',
        'view_message',
        'read_user',
        'create_user',
        'update_user',
        'delete_user',
        'view_all_users',
        'get_permissions',
        'get_roles',
        'create_role',
        'update_role',
        'delete_roles',
        'create_customer',
        'update_customer',
        'get_customers',
        'get_my_customers',
        'create_lead',
        'get_leads',
        'get_my_leads',
        'update_lead',
        'create_booking',
        'update_booking',
        'get_bookings',
        'create_source',
        'update_source',
        'delete_source',
        'delete_supplier',
        'delete_payment_voucher',
        'approve_payment_voucher',
      ],
    },
    {
      name: 'SALE',
      isDefault: true,
      permissions: [
        'view_assigned_conversations',
        'view_message',
        'send_message',
        'create_customer',
        'update_customer',
        'get_customers',
        'get_my_customers',
        'create_lead',
        'get_my_leads',
        'update_lead',
        'create_booking',
        'update_booking',
        'get_bookings',
        'create_source',
        'update_source',
        'get_sources',
        'delete_source',
        'create_tour_location',
        'update_tour_location',
        'get_tour_locations',
        'delete_tour_location',
        'get_departure_tours',
        'get_tour_templates',
        'view_all_users',
        'get_suppliers',
      ],
    },
    {
      name: 'OPERATOR',
      isDefault: true,
      permissions: [
        'create_departure_tour',
        'update_departure_tour',
        'get_departure_tours',
        'delete_departure_tour',
        'create_tour_template',
        'update_tour_template',
        'get_tour_templates',
        'delete_tour_template',
        'create_tour_location',
        'update_tour_location',
        'get_tour_locations',
        'delete_tour_location',
        'create_receipt',
        'update_receipt',
        'get_receipts',
        'delete_receipt',
        'create_payment_voucher',
        'update_payment_voucher',
        'get_payment_vouchers',
        'self_assign_tour_operator',
        'view_tour_plan',
        'update_tour_plan',
        'view_tour_estimation',
        'create_tour_estimation',
        'update_tour_estimation',
        'delete_tour_estimation',
        'view_all_users',
        'get_sources',
        'get_suppliers',
        'create_supplier',
        'update_supplier',
        'get_bookings',
      ],
    },
    {
      name: 'OPERATOR_MANAGER',
      extend: ['OPERATOR'],
      isDefault: true,
      permissions: [
        'assign_tour_operator'
      ],
    },
  ],
};

export const DEFAULT_PERMISSIONS = {
  groups: [
    {
      name: 'Setting',
      permissions: [
        {
          name: 'link_page',
          title: 'Link page',
          statements: [
            {
              path: '/facebook/link',
              action: 'POST',
            },
            {
              path: '/zalo/link',
              action: 'GET',
            },
            {
              path: '/zalo/link',
              action: 'POST',
            },
            {
              action: 'POST',
              path: '/telegram/link',
            },
          ],
        },
        {
          name: 'unlink_page',
          title: 'Unlink page',
          statements: [
            {
              path: '/admin/linked_pages',
              action: 'DELETE',
            },
          ],
        },
      ],
    },
    {
      name: 'Chat',
      permissions: [
        {
          name: 'assign_chat',
          title: 'Assign chat',
          statements: [
            {
              action: 'POST',
              path: '/admin/assign-chat',
            },
          ],
        },
        {
          name: 'view_all_conversations',
          title: 'View all conversations',
          statements: [
            {
              path: 'adminAllFbConversations',
            },
            {
              path: 'adminAllZaloConversations',
            },
            {
              path: 'adminAllTelegramConversations',
            },
            {
              action: 'GET',
              path: '/admin/linked_pages',
            },
          ],
        },
        {
          name: 'view_assigned_conversations',
          title: 'View assigned conversations',
          statements: [
            {
              path: 'allFbConversations',
            },
            {
              path: 'allZaloConversations',
            },
            {
              path: 'allTelegramConversations',
            },
            {
              action: 'GET',
              path: '/admin/linked_pages',
            },
          ],
        },
        {
          name: 'view_message',
          title: 'View message',
          statements: [
            {
              path: 'allFbMessages',
            },
            {
              path: 'allZaloMessages',
            },
            {
              path: 'allTelegramMessages',
            },
            {
              path: 'getTelegramFileInfo',
            },
            {
              path: 'userProfile',
            },
            {
              path: 'onNewMessageReceived',
            },
            {
              path: 'getZaloAudio'
            }
          ],
        },
        {
          name: 'send_message',
          title: 'Send message',
          statements: [
            {
              path: 'sendMessage',
            },
            {
              path: '/presigned-url',
              action: 'GET',
            },
            {
              action: 'GET',
              path: '/upload-file-to-chat-platform',
            },
          ],
        },
      ],
    },
    {
      name: 'User',
      permissions: [
        {
          name: 'create_user',
          title: 'Create User',
          statements: [
            {
              action: 'POST',
              path: '/users',
            },
          ],
        },
        {
          name: 'update_user',
          title: 'Update User',
          statements: [
            {
              action: 'PUT',
              path: '/users/{userId}',
            },
          ],
        },
        {
          name: 'delete_user',
          title: 'Delete User',
          statements: [
            {
              action: 'DELETE',
              path: '/users/{userId}',
            },
          ],
        },
        {
          name: 'view_all_users',
          title: 'View All Users',
          statements: [
            {
              action: 'GET',
              path: '/users',
            },
            {
              action: 'GET',
              path: '/users/{userId}',
            },
          ],
        },
      ],
    },
    {
      name: 'Role Permissions',
      permissions: [
        {
          name: 'get_permissions',
          title: 'View Permissions',
          statements: [
            {
              path: '/admin/permissions',
              action: 'GET',
            },
          ],
        },
        {
          name: 'get_roles',
          title: 'View Roles',
          statements: [
            {
              path: '/admin/roles',
              action: 'GET',
            },
          ],
        },
        {
          name: 'create_role',
          title: 'Create Role',
          statements: [
            {
              path: '/admin/roles',
              action: 'POST',
            },
          ],
        },
        {
          name: 'update_role',
          title: 'Update Role',
          statements: [
            {
              path: '/admin/roles/{roleName}',
              action: 'PUT',
            },
          ],
        },
        {
          name: 'delete_roles',
          title: 'Delete Role',
          statements: [
            {
              path: '/admin/roles/{roleName}',
              action: 'DELETE',
            },
          ]
        }
      ]
    },
    {
      name: 'Lead',
      permissions: [
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
          name: 'get_leads',
          title: 'View All Leads',
          statements: [
            {
              path: '/leads',
              action: 'GET'
            },
            {
              path: '/leads/{leadId}',
              action: 'GET'
            }
          ]
        },
        {
          name: 'get_my_leads',
          title: 'View My Leads',
          statements: [
            {
              path: '/me/leads',
              action: 'GET'
            },
            {
              path: '/leads/{leadId}',
              action: 'GET'
            }
          ]
        },
        {
          name: 'update_lead',
          title: 'Update Lead',
          statements: [
            {
              path: '/leads/{leadId}',
              action: 'PUT'
            },
            {
              path: '/leads/{leadId}/status',
              action: 'PUT'
            },
            {
              path: '/leads/{leadId}/cancel',
              action: 'PUT'
            },
            {
              path: '/leads/{leadId}/assignee',
              action: 'PUT'
            }
          ]
        },
      ]
    },
    {
      name: 'Customer',
      permissions: [
        {
          name: 'create_customer',
          title: 'Create Customer',
          statements: [
            {
              path: '/customers',
              action: 'POST'
            },
          ]
        },
        {
          name: 'update_customer',
          title: 'Update Customer',
          statements: [
            {
              path: '/customers/{customerId}',
              action: 'PUT'
            },
            {
              path: '/customers/{customerId}/assignee',
              action: 'PUT'
            },
          ]
        },
        {
          name: 'get_customers',
          title: 'View All Customers',
          statements: [
            {
              path: '/customers',
              action: 'GET'
            },
            {
              path: '/customers/{customerId}',
              action: 'GET'
            },
            {
              path: '/customers/{customerId}/leads',
              action: 'GET'
            },
            {
              path: '/customers/{customerId}/bookings',
              action: 'GET'
            },
          ]
        },
        {
          name: 'get_my_customers',
          title: 'View My Customers',
          statements: [
            {
              path: '/me/customers',
              action: 'GET'
            },
            {
              path: '/customers/{customerId}',
              action: 'GET'
            },
            {
              path: '/customers/{customerId}/leads',
              action: 'GET'
            },
            {
              path: '/customers/{customerId}/bookings',
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
          name: 'create_booking',
          title: 'Create Booking',
          statements: [
            {
              path: '/bookings',
              action: 'POST'
            },
            {
              path: '/bookings/create-from-lead',
              action: 'POST'
            },
          ]
        },
        {
          name: 'update_booking',
          title: 'Update Booking',
          statements: [
            {
              path: '/bookings/{id}',
              action: 'PUT'
            },
            {
              path: '/bookings/{id}/cancel',
              action: 'PUT'
            },
            {
              path: '/bookings/{id}/confirm',
              action: 'PUT'
            },
            {
              path: '/bookings/{id}/payment-pending',
              action: 'PUT'
            },
            {
              path: '/bookings/{id}/notes',
              action: 'POST'
            },
            {
              path: '/bookings/{id}/notes/{noteId}',
              action: 'PUT'
            },
            {
              path: '/bookings/{id}/notes/{noteId}',
              action: 'DELETE'
            },
            {
              path: '/passengers/attached-docs/presigned-url',
              action: 'GET'
            }
          ]
        },
        {
          name: 'get_bookings',
          title: 'View All Bookings',
          statements: [
            {
              path: '/bookings',
              action: 'GET'
            },
            {
              path: '/bookings/{id}',
              action: 'GET'
            },
            {
              path: '/bookings-by-status/{status}',
              action: 'GET'
            },
          ]
        }
      ]
    },
    {
      name: 'Departure tour',
      permissions: [
        {
          name: 'create_departure_tour',
          title: 'Create Departure Tour',
          statements: [
            {
              path: '/departure-tours',
              action: 'POST'
            },
          ]
        },
        {
          name: 'update_departure_tour',
          title: 'Update Departure Tour',
          statements: [
            {
              path: '/departure-tours/{id}',
              action: 'PUT'
            },
            {
              path: '/departure-tours/{id}/operation-status',
              action: 'PUT'
            },
         
            {
              path: '/me/departure-tours',
              action: 'PUT'
            },
          ]
        },
        {
          name: 'get_departure_tours',
          title: 'View All Departure Tours',
          statements: [
            {
              path: '/departure-tours',
              action: 'GET'
            },
            {
              path: '/departure-tours/{id}',
              action: 'GET'
            },
            {
              path: '/departure-tours/{id}/bookings',
              action: 'GET'
            }
          ]
        },
        {
          name: 'delete_departure_tour',
          title: 'Delete Departure Tour',
          statements: [
            {
              path: '/departure-tours/{id}',
              action: 'DELETE'
            }
          ]
        },
        {
          name: 'assign_tour_operator',
          title: 'Assign tour operator',
          statements: [
            {
              path: '/departure-tours/{id}/assignee',
              action: 'PUT'
            }
          ]
        },
        {
          name: 'self_assign_tour_operator',
          title: 'Self assign tour operator',
          statements: [
            {
              path: '/me/take-care-tour',
              action: 'PUT'
            }
          ]
        }
      ]
    },
    {
      name: 'Tour Template',
      permissions: [
        {
          name: 'create_tour_template',
          title: 'Create Tour Template',
          statements: [
            {
              path: '/tour-templates',
              action: 'POST'
            },
          ]
        },
        {
          name: 'update_tour_template',
          title: 'Update Tour Template',
          statements: [
            {
              path: '/tour-templates/{id}',
              action: 'PUT'
            }
          ]
        },
        {
          name: 'get_tour_templates',
          title: 'View All Tour Templates',
          statements: [
            {
              path: '/tour-templates',
              action: 'GET'
            },
            {
              path: '/tour-templates/{id}',
              action: 'GET'
            }
          ]
        },
        {
          name: 'delete_tour_template',
          title: 'Delete Tour Template',
          statements: [
            {
              path: '/tour-templates/{id}',
              action: 'DELETE'
            }
          ]
        },
      ]
    },
    {
      name: 'Tour Location',
      permissions: [
        {
          name: 'create_tour_location',
          title: 'Create Tour Location',
          statements: [
            {
              path: '/tour-locations',
              action: 'POST'
            },
          ]
        },
        {
          name: 'update_tour_location',
          title: 'Update Tour Location',
          statements: [
            {
              path: '/tour-locations/{id}',
              action: 'PUT'
            }
          ]
        },
        {
          name: 'get_tour_locations',
          title: 'View All Tour Locations',
          statements: [
            {
              path: '/tour-locations',
              action: 'GET'
            },
            {
              path: '/tour-locaitons/{id}',
              action: 'GET'
            }
          ]
        },
        {
          name: 'delete_tour_location',
          title: 'Delete Tour Location',
          statements: [
            {
              path: '/tour-locations/{id}',
              action: 'DELETE'
            }
          ]
        },
      ]
    },
    {
      name: 'Receipt',
      permissions: [
        {
          name: 'create_receipt',
          title: 'Create Receipt',
          statements: [
            {
              path: '/receipts',
              action: 'POST'
            },
          ]
        },
        {
          name: 'update_receipt',
          title: 'Update Receipt',
          statements: [
            {
              path: '/receipts/{id}',
              action: 'PUT'
            }
          ]
        },
        {
          name: 'get_receipts',
          title: 'View All Receipts',
          statements: [
            {
              path: '/receipts',
              action: 'GET'
            },
            {
              path: '/receipts/{id}',
              action: 'GET'
            }
          ]
        },
        {
          name: 'delete_receipt',
          title: 'Delete Receipt',
          statements: [
            {
              path: '/receipts/{id}',
              action: 'DELETE'
            }
          ]
        },
      ]
    },
    {
      name: 'Payment Voucher',
      permissions: [
        {
          name: 'create_payment_voucher',
          title: 'Create Payment Voucher',
          statements: [
            {
              path: '/payment-vouchers',
              action: 'POST'
            },
          ]
        },
        {
          name: 'update_payment_voucher',
          title: 'Update Payment Voucher',
          statements: [
            {
              path: '/payment-vouchers/{id}',
              action: 'PUT'
            }
          ]
        },
        {
          name: 'get_payment_vouchers',
          title: 'View All Payment Vouchers',
          statements: [
            {
              path: '/payment-vouchers',
              action: 'GET'
            },
            {
              path: '/payment-vouchers/{id}',
              action: 'GET'
            },
            {
              path: '/payment-vouchers/presigned-url',
              action: 'GET'
            },
          ]
        },
        {
          name: 'delete_payment_voucher',
          title: 'Delete Payment Voucher',
          statements: [
            {
              path: '/payment-vouchers/{id}',
              action: 'DELETE'
            }
          ]
        },
        {
          name: 'approve_payment_voucher',
          title: 'approve Payment Voucher',
          statements: [
            {
              path: '/payment-vouchers/{id}/approve',
              action: 'PUT'
            }
          ]
        },
      ]
    },
    {
      name: 'Source',
      permissions: [
        {
          name: 'create_source',
          title: 'Create Source',
          statements: [
            {
              path: '/sources',
              action: 'POST'
            },
          ]
        },
        {
          name: 'update_source',
          title: 'Update Source',
          statements: [
            {
              path: '/sources/{id}',
              action: 'PUT'
            }
          ]
        },
        {
          name: 'get_sources',
          title: 'View All Sources',
          statements: [
            {
              path: '/sources',
              action: 'GET'
            },
            {
              path: '/sources/{id}',
              action: 'GET'
            }
          ]
        },
        {
          name: 'delete_source',
          title: 'Delete Source',
          statements: [
            {
              path: '/sources/{id}',
              action: 'DELETE'
            }
          ]
        },
      ]
    },
    {
      name: 'Supplier',
      permissions: [
        {
          name: 'create_supplier',
          title: 'Create Supplier',
          statements: [
            {
              path: '/suppliers',
              action: 'POST'
            },
          ]
        },
        {
          name: 'update_supplier',
          title: 'Update Supplier',
          statements: [
            {
              path: '/suppliers/{id}',
              action: 'PUT'
            }
          ]
        },
        {
          name: 'get_suppliers',
          title: 'View All Suppliers',
          statements: [
            {
              path: '/suppliers',
              action: 'GET'
            },
            {
              path: '/suppliers/{id}',
              action: 'GET'
            }
          ]
        },
        {
          name: 'delete_supplier',
          title: 'Delete Supplier',
          statements: [
            {
              path: '/suppliers/{id}',
              action: 'DELETE'
            }
          ]
        },
      ]
    },
    {
      name: 'Tour Operation',
      permissions: [
        {
          name: 'view_tour_plan',
          title: 'View Tour Plan',
          statements: [
            {
              path: '/tours/{tourId}/operation/plan',
              action: 'GET'
            },
          ]
        },
        {
          name: 'update_tour_plan',
          title: 'Update Tour Plan',
          statements: [
            {
              path: '/tours/{tourId}/operation/plan',
              action: 'PUT'
            },
          ]
        },
        {
          name: 'view_tour_estimation',
          title: 'View Tour Estimation',
          statements: [
            {
              path: '/tours/{tourId}/estimations',
              action: 'GET'
            },
            {
              path: '/tours/{tourId}/estimations/{estimationId}',
              action: 'GET'
            },
            {
              path: '/tours/{tourId}/payment-vouchers',
              action: 'GET'
            },
          ]
        },
        {
          name: 'create_tour_estimation',
          title: 'Create Tour Estimation',
          statements: [
            {
              path: '/tours/{tourId}/estimations',
              action: 'POST'
            },
          ]
        },
        {
          name: 'update_tour_estimation',
          title: 'Update Tour Estimation',
          statements: [
            {
              path: '/tours/{tourId}/estimations/{estimationId}',
              action: 'PUT'
            },
          ]
        },
        {
          name: 'delete_tour_estimation',
          title: 'Delete Tour Estimation',
          statements: [
            {
              path: '/tours/{tourId}/estimations/{estimationId}',
              action: 'DELETE'
            },
          ]
        },
      ]
    },
  ]
}

export const DEFAULT_WHITELIST = {
  groups: [
    {
      name: 'Me',
      permissions: [
        {
          name: 'read',
          title: 'Read',
          statements: [
            {
              action: 'GET',
              path: '/me',
            },
            {
              action: 'GET',
              path: '/me/avatar/presigned-url'
            },
            {
              action: 'GET',
              path: '/presigned-url'
            }
          ],
        },
        {
          name: 'update',
          title: 'Update',
          statements: [
            {
              action: 'PUT',
              path: '/me',
            },
          ],
        },
      ],
    },
    {
      name: 'Statistic',
      permissions: [
        {
          name: 'read',
          title: 'Read',
          statements: [
            {
              action: 'GET',
              path: '/statistic/tenant',
            },
            {
              action: 'GET',
              path: '/statistic/sales/{id}',
            }
          ],
        },
      ],
    },
    {
      name: 'Common',
      permissions: [
        {
          name: 'sendAndSubscribeNewNotification',
          title: 'Send / subscribe new notification',
          statements: [
            { path: 'onNewNotificationReceived' },
            { path: 'sendNotification' },
            { path: 'syncEmail' }
          ],
        },
      ],
    },
  ],
};
