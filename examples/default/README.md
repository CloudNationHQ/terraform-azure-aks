This example illustrates the default setup, in its simplest form.

## Notes

The max_surge setting is defined as a workaround because each plan run resets upgrade_settings.max_surge for the default_node_pool. You can find more details about the issue [here](https://github.com/hashicorp/terraform-provider-azurerm/issues/24020)
