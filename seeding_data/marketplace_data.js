export const MK_TABLE = 'marketplace_role_permission_table';

export const MK_DEFAULT_ROLES = {
  roles: [
    {
      name: 'ROOT',
      extend: ['SALE', 'ADMIN'],
      isDefault: true,
      permissions: [],
    },
    {
      name: 'ADMIN',
      extend: ['SALE'],
      isDefault: true,
      permissions: [
        'modify_organization',
        'modify_user',
        'view_all_feedback',
        'view_specified_feedback',
        'view_organization_offer'
      ],
    },
    {
      name: 'SALE',
      isDefault: true,
      permissions: [
        'view_organization',
        'view_specified_feedback',
        'modify_organization_feedback',
        'view_post',
        'view_post_comment',
        'modify_post_comment',
        'view_post_rating',
        'modify_post_rating',
        'modify_post_bookmark',
        'follow_post',
        'view_post_offer',
        'modify_post_offer',
        'view_user'
      ],
    },
  ],
};

export const MK_DEFAULT_PERMISSIONS = {
  groups: [
    {
      name: 'Oganization',
      permissions: [
        {
          name: 'view_organization',
          title: 'View Organization',
          statements: [
            {
              path: '/marketplace/organizations/{id}',
              action: 'GET'
            },
            {
              path: '/marketplace/organizations',
              action: 'GET'
            },
            {
              path: '/marketplace/organizations/{id}/ratings',
              action: 'GET'
            },
          ]
        },
        {
          name: 'modify_organization',
          statements: [
            {
              path: '/marketplace/organizations',
              action: 'POST'
            },
            {
              path: '/marketplace/organizations',
              action: 'PUT'
            },
            {
              path: '/marketplace/organizations',
              action: 'DELETE'
            },
          ]
        },
      ],
    },
    {
      name: 'Organization Feedback',
      permissions: [
        {
          name: 'view_all_feedback',
          title: 'View All Feedback',
          statements: [
            {
              path: '/marketplace/organizations/{id}/feedback',
              action: 'GET'
            },
          ]
        },
        {
          name: 'view_specified_feedback',
          title: 'View Specified Feedback',
          statements: [
            {
              path: '/marketplace/organizations/{id}/feedback/{feedbackId',
              action: 'GET'
            },
          ]
        },
        {
          name: 'modify_organization_feedback',
          title: 'Modify organization feedback',
          statements: [
            {
              path: '/marketplace/organizations/{id}/feedback',
              action: 'POST'
            },
            {
              path: '/marketplace/organizations/{id}/feedback/{feedbackId',
              action: 'PUT'
            },
          ]
        },
      ],
    },
    {
      name: 'Post',
      permissions: [
        {
          name: 'view_post',
          title: 'View Post',
          statements: [
            {
              path: '/marketplace/posts/{id}',
              action: 'GET'
            },
            {
              path: '/marketplace/posts',
              action: 'GET'
            },
 
          ]
        },
        {
          name: 'modify_post',
          title: 'Modify Post',
          statements: [
            {
              path: '/marketplace/posts',
              action: 'POST'
            },
            {
              path: '/marketplace/posts/{id}',
              action: 'PUT'
            },
 
          ]
        },
      ],
    },
    {
      name: 'Post Comment',
      permissions: [
        {
          name: 'view_post_comment',
          title: 'View Post Comment',
          statements: [
            {
              path: '/marketplace/posts/{id}/comments/{commentId}',
              action: 'GET'
            },
            {
              path: '/marketplace/posts/{id}/comments',
              action: 'GET'
            },
 
          ]
        },
        {
          name: 'modify_post_comment',
          title: 'Modify Post Comment',
          statements: [
            {
              path: '/marketplace/posts/{id}/comments',
              action: 'POST'
            },
            {
              path: '/marketplace/posts/{id}/comments/{commentId}',
              action: 'PUT'
            },
            {
              path: '/marketplace/posts/{id}/comments/{commentId}',
              action: 'DELETE'
            },
          ]
        },
      ],
    },
    {
      name: 'Post Rating',
      permissions: [
        {
          name: 'view_post_rating',
          title: 'View Post Rating',
          statements: [
            {
              path: '/marketplace/posts/{id}/ratings/{ratingId}',
              action: 'GET'
            },
            {
              path: '/marketplace/posts/{id}/ratings',
              action: 'GET'
            },
 
          ]
        },
        {
          name: 'modify_post_rating',
          title: 'Modify Post Rating',
          statements: [
            {
              path: '/marketplace/posts/{id}/ratings',
              action: 'POST'
            },
            {
              path: '/marketplace/posts/{id}/ratings/{ratingId}',
              action: 'PUT'
            },
            {
              path: '/marketplace/posts/{id}/ratings/{ratingId}',
              action: 'DELETE'
            },
          ]
        },
      ],
    },
    {
      name: 'Post Bookmark',
      permissions: [
        {
          name: 'modify_post_bookmark',
          title: 'Modify Post Bookmark',
          statements: [
            {
              path: '/marketplace/posts/{id}/bookmark',
              action: 'POST'
            },
            {
              path: '/marketplace/posts/{id}/bookmark',
              action: 'DELETE'
            },
          ]
        },
      ],
    },
    {
      name: 'Follow Post',
      permissions: [
        {
          name: 'follow_post',
          title: 'Follow Post',
          statements: [
            {
              path: '/marketplace/posts/{id}/follow',
              action: 'POST'
            },
            {
              path: '/marketplace/posts/{id}/follow',
              action: 'DELETE'
            },
          ]
        },
      ],
    },
    {
      name: 'Post Offer',
      permissions: [
        {
          name: 'view_post_offer',
          title: 'View Post Offer',
          statements: [
            {
              path: '/marketplace/posts/{id}/offers',
              action: 'GET'
            },
            {
              path: '/marketplace/offers/{id}',
              action: 'GET'
            },
 
          ]
        },
        {
          name: 'view_organization_offer',
          title: 'View Organization Offer',
          statements: [
            {
              path: '/marketplace/me/organizations/sent-offers',
              action: 'GET'
            },
            {
              path: '/marketplace/me/organizations/received-offers',
              action: 'GET'
            },
 
          ]
        },
        {
          name: 'modify_post_offer',
          title: 'Modify Post Offer',
          statements: [
            {
              path: '/marketplace/posts/{id}/offers',
              action: 'POST'
            },
            {
              path: '/marketplace/offers/{id}',
              action: 'PUT'
            },
            {
              path: '/marketplace/offers/{id}/cancel',
              action: 'PUT'
            },
            {
              path: '/marketplace/offers/{id}/accept',
              action: 'PUT'
            },
            {
              path: '/marketplace/offers/{id}/reject',
              action: 'PUT'
            },
          ]
        },
      ],
    },
    {
      name: 'Marketplace User',
      permissions: [
        {
          name: 'view_user',
          title: 'View user',
          statements: [
            {
              path: '/marketplace/users',
              action: 'GET'
            },
            {
              path: '/marketplace/users/{id}',
              action: 'GET'
            }
          ]
        },
        {
          name: 'modify_user',
          title: 'Modify user',
          statements: [
            {
              path: '/marketplace/users',
              action: 'POST'
            },
            {
              path: '/marketplace/enable-user',
              action: 'PUT'
            }
          ]
        },
      ],
    },
  ]
}

export const MK_DEFAULT_WHITELIST = {
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
              path: '/marketplace/me',
            },
            {
              action: 'GET',
              path: '/marketplace/me/posts'
            },
            {
              action: 'GET',
              path: '/marketplace/me/offers'
            },
            {
              action: 'GET',
              path: '/marketplace/me/bookmarked-posts'
            },
            {
              action: 'GET',
              path: '/marketplace/me/followed-posts'
            }
          ],
        },
        {
          name: 'modify',
          title: 'Modify',
          statements: [
            {
              action: 'PUT',
              path: '/marketplace/me',
            },
          ],
        },
      ],
    },
  ],
};
