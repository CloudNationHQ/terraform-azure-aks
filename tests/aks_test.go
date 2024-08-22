package main

import (
	"os"
	"testing"

	"github.com/cloudnationhq/terraform-azure-aks/shared"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestApplyNoError(t *testing.T) {
	t.Parallel()

	tests := []shared.TestCase{
		{Name: os.Getenv("TF_PATH"), Path: "../examples/" + os.Getenv("TF_PATH")},
	}

	for _, test := range tests {
		t.Run(test.Name, func(t *testing.T) {
			terraformOptions := shared.GetTerraformOptions(test.Path)

			terraform.WithDefaultRetryableErrors(t, &terraform.Options{})

			defer shared.Cleanup(t, terraformOptions)
			terraform.InitAndApply(t, terraformOptions)
		})
	}
}


//package main

//import (
	//"os"
	//"path/filepath"
	//"testing"

	//"github.com/gruntwork-io/terratest/modules/terraform"
//)

//var filesToCleanup = []string{
	//"*.terraform*",
	//"*tfstate*",
//}

//type TestCase struct {
	//Name string
	//Path string
//}

//func GetTerraformOptions(terraformDir string) *terraform.Options {
	//return &terraform.Options{
		//TerraformDir: terraformDir,
		//NoColor:      true,
	//}
//}

//func Cleanup(t *testing.T, tfOpts *terraform.Options) {
	//SequentialDestroy(t, tfOpts)
	//CleanupFiles(t, tfOpts.TerraformDir)
//}

//func CleanupFiles(t *testing.T, dir string) {
	//for _, pattern := range filesToCleanup {
		//matches, err := filepath.Glob(filepath.Join(dir, pattern))
		//if err != nil {
			//t.Logf("Error: %v", err)
			//continue
		//}
		//for _, filePath := range matches {
			//if err := os.RemoveAll(filePath); err != nil {
				//t.Logf("Failed to remove %s: %v\n", filePath, err)
			//} else {
				//t.Logf("Successfully removed %s\n", filePath)
			//}
		//}
	//}
//}

//func SequentialDestroy(t *testing.T, tfOpts *terraform.Options) {
	//tfOpts.Parallelism = 1
	//terraform.Destroy(t, tfOpts)
//}

//func TestApplyNoError(t *testing.T) {
	//t.Parallel()
	//tests := []TestCase{
		//{Name: os.Getenv("TF_PATH"), Path: "../examples/" + os.Getenv("TF_PATH")},
	//}
	//for _, test := range tests {
		//test := test // capture range variable
		//t.Run(test.Name, func(t *testing.T) {
			//terraformOptions := GetTerraformOptions(test.Path)
			//terraform.WithDefaultRetryableErrors(t, &terraform.Options{})
			//defer Cleanup(t, terraformOptions)
			//terraform.InitAndApply(t, terraformOptions)
		//})
	//}
//}
