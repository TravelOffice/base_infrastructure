export const MK_TABLE = 'marketplace_role_permission_table';

export const MK_DEFAULT_ROLES = {
  roles: [
    {
      name: 'ROOT',
      extend: ['ADMIN', 'SALE'],
      isDefault: true,
      permissions: [
        'create_organization',
      ],
    },
    {
      name: 'ADMIN',
      extend: ['SALE'],
      isDefault: true,
      permissions: [
        'update_organization',
        'view_org_feedback',
      ],
    },
    {
      name: 'SALE',
      isDefault: true,
      permissions: [
        'view_organization',
        'create_org_feedback',
        'update_org_feedback',
        'delete_org_feedback',
        'view_post',
        'create_post',
        'update_post',
        'view_post_comment',
        'create_post_comment',
        'update_post_comment',
        'delete_post_comment',
        'view_post_rating',
        'create_post_rating',
        'update_post_rating',
        'delete_post_rating',
        'create_post_bookmark',
        'delete_post_bookmark',
        'follow_post',
        'unfollow_post'
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
              path: 'marketplace/organizations/{id}',
              action: 'GET'
            },
            {
              path: 'marketplace/organizations',
              action: 'GET'
            },
            {
              path: 'marketplace/organizations/{id}/ratings',
              action: 'GET'
            },
          ]
        },
        {
          name: 'create_organization',
          title: 'Create Organization',
          statements: [
            {
              path: 'marketplace/organizations',
              action: 'POST'
            },
 
          ]
        },
        {
          name: 'update_organization',
          title: 'Update Organization',
          statements: [
            {
              path: 'marketplace/organizations',
              action: 'PUT'
            },
 
          ]
        },
        {
          name: 'delete_organization',
          title: 'Delete Organization',
          statements: [
            {
              path: 'marketplace/organizations',
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
          name: 'view_org_feedback',
          title: 'View Organizaiton Feedback',
          statements: [
            {
              path: 'marketplace/organization/{id}/feedback/{feedbackId}',
              action: 'GET'
            },
            {
              path: 'marketplace/organization/{id}/feedback',
              action: 'GET'
            },
 
          ]
        },
        {
          name: 'create_org_feedback',
          title: 'Create Org Feedback',
          statements: [
            {
              path: 'marketplace/organization/{id}/feedback',
              action: 'POST'
            },
 
          ]
        },
        {
          name: 'update_org_feedback',
          title: 'Update Org Feedback',
          statements: [
            {
              path: 'marketplace/organization/{id}/feedback/{feedbackId}',
              action: 'PUT'
            },
          ]
        },
        {
          name: 'delete_org_feedback',
          title: 'Delete Org Feedback',
          statements: [
            {
              path: 'marketplace/organization/{id}/feedback/{feedbackId}',
              action: 'DELETE'
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
              path: 'marketplace/posts/{id}',
              action: 'GET'
            },
            {
              path: 'marketplace/posts',
              action: 'GET'
            },
 
          ]
        },
        {
          name: 'create_post',
          title: 'Create Post',
          statements: [
            {
              path: 'marketplace/posts',
              action: 'POST'
            },
 
          ]
        },
        {
          name: 'update_post',
          title: 'Update Post',
          statements: [
            {
              path: 'marketplace/posts/{id}',
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
              path: 'marketplace/posts/{id}/comments/{commentId}',
              action: 'GET'
            },
            {
              path: 'marketplace/posts/{id}/comments',
              action: 'GET'
            },
 
          ]
        },
        {
          name: 'create_post_comment',
          title: 'Create Post Comment',
          statements: [
            {
              path: 'marketplace/posts/{id}/comments',
              action: 'POST'
            },
 
          ]
        },
        {
          name: 'update_post_comment',
          title: 'Update Post Comment',
          statements: [
            {
              path: 'marketplace/posts/{id}/comments/{commentId}',
              action: 'PUT'
            },
          ]
        },
        {
          name: 'delete_post_comment',
          title: 'Delete Post Comment',
          statements: [
            {
              path: 'marketplace/posts/{id}/comments/{commentId}',
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
              path: 'marketplace/posts/{id}/ratings/{ratingId}',
              action: 'GET'
            },
            {
              path: 'marketplace/posts/{id}/ratings',
              action: 'GET'
            },
 
          ]
        },
        {
          name: 'create_post_rating',
          title: 'Create Post Rating',
          statements: [
            {
              path: 'marketplace/posts/{id}/ratings',
              action: 'POST'
            },
 
          ]
        },
        {
          name: 'update_post_rating',
          title: 'Update Post Rating',
          statements: [
            {
              path: 'marketplace/posts/{id}/ratings/{ratingId}',
              action: 'PUT'
            },
          ]
        },
        {
          name: 'delete_post_rating',
          title: 'Delete Post Rating',
          statements: [
            {
              path: 'marketplace/posts/{id}/ratings/{ratingId}',
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
          name: 'create_post_bookmark',
          title: 'Create Post Bookmark',
          statements: [
            {
              path: '/marketplace/posts/{id}/bookmark',
              action: 'POST'
            },
          ]
        },
        {
          name: 'delete_post_bookmark',
          title: 'Delete Post Bookmark',
          statements: [
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
          ]
        },
        {
          name: 'unfollow_post',
          title: 'Unfollow Post',
          statements: [
            {
              path: '/marketplace/posts/{id}/follow',
              action: 'DELETE'
            },
          ]
        },
      ],
    }
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
          name: 'update',
          title: 'Update',
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
