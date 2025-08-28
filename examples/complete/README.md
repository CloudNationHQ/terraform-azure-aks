This example highlights the complete usage.

## Notes

When setting the identity type to UserAssigned, the module will generate a user-assigned identity automatically.

However, if you specify identity_ids under the identity property, the module will skip the generating one, and your specified identities will be used instead.

You can specify a custom kubelet identity using user_assigned_identity_id, client_id, and object_id.

Note that assigning the "Managed Identity Operator" role to the user-assigned identity is a requirement for proper permissions.
