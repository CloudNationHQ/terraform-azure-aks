package main

import (
	"context"
	"strings"
	"testing"
	"time"

	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/containerservice/armcontainerservice"
	"github.com/cloudnationhq/terraform-azure-aks/shared"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

type AksDetails struct {
	ResourceGroupName string
	Name              string
}

type AksClient struct {
	SubscriptionId string
	AksClient      *armcontainerservice.ManagedClustersClient
}

func NewAksClient(t *testing.T, subscriptionId string) *AksClient {
	cred, err := azidentity.NewDefaultAzureCredential(nil)
	require.NoError(t, err, "Failed to create credential")

	aksClient, err := armcontainerservice.NewManagedClustersClient(subscriptionId, cred, nil)
	require.NoError(t, err, "Failed to create aks client")

	return &AksClient{
		SubscriptionId: subscriptionId,
		AksClient:      aksClient,
	}
}

func (c *AksClient) GetAks(ctx context.Context, t *testing.T, details *AksDetails) *armcontainerservice.ManagedCluster {
	resp, err := c.AksClient.Get(ctx, details.ResourceGroupName, details.Name, nil)
	require.NoError(t, err, "Failed to get aks cluster")
	return &resp.ManagedCluster
}

func InitializeTerraform(t *testing.T) *terraform.Options {
	tfOpts := shared.GetTerraformOptions("../examples/complete")
	terraform.InitAndApply(t, tfOpts)
	return tfOpts
}

func CLeanupTerraform(t *testing.T, tfOpts *terraform.Options) {
	shared.Cleanup(t, tfOpts)
}

func TestAks(t *testing.T) {
	tfOpts := InitializeTerraform(t)
	defer CLeanupTerraform(t, tfOpts)

	subscriptionId := terraform.Output(t, tfOpts, "subscriptionId")
	aksClient := NewAksClient(t, subscriptionId)

	aksMap := terraform.OutputMap(t, tfOpts, "cluster")
	aksDetails := AksDetails{
		ResourceGroupName: aksMap["resource_group_name"],
		Name:              aksMap["name"],
	}

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Minute)
	defer cancel()

	aks := aksClient.GetAks(ctx, t, &aksDetails)
	verifyAks(t, &aksDetails, aks)
}

func verifyAks(t *testing.T, details *AksDetails, aks *armcontainerservice.ManagedCluster) {
	t.Helper()

	require.Equal(
		t,
		details.Name,
		*aks.Name,
		"Aks name does not match expected value",
	)

	require.Equal(
		t,
		"Succeeded",
		string(*aks.Properties.ProvisioningState),
		"Aks provisioning state is not Suceeded",
	)

	require.True(
		t,
		strings.HasPrefix(details.Name, "aks"),
		"Aks name does not start with the right abbreviation",
	)
}
