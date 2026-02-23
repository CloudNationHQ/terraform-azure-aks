# Changelog

## [4.3.0](https://github.com/CloudNationHQ/terraform-azure-aks/compare/v4.2.0...v4.3.0) (2026-02-23)


### Features

* added missing properties ([#151](https://github.com/CloudNationHQ/terraform-azure-aks/issues/151)) ([22de409](https://github.com/CloudNationHQ/terraform-azure-aks/commit/22de4096f405841c8630fc96abd941d74622612b))

## [4.2.0](https://github.com/CloudNationHQ/terraform-azure-aks/compare/v4.1.0...v4.2.0) (2026-02-23)


### Features

* **deps:** bump github.com/cloudnationhq/az-cn-go-validor in /tests ([#147](https://github.com/CloudNationHQ/terraform-azure-aks/issues/147)) ([a7c87fa](https://github.com/CloudNationHQ/terraform-azure-aks/commit/a7c87fade27b35f2a033e4cb18d248646b0df734))
* **deps:** bump golang.org/x/crypto from 0.36.0 to 0.45.0 in /tests ([#145](https://github.com/CloudNationHQ/terraform-azure-aks/issues/145)) ([45ba79a](https://github.com/CloudNationHQ/terraform-azure-aks/commit/45ba79abe14bc964f2f62c5070ec1827e8be7f2f))


### Bug Fixes

* correct node_count assignment logic for AKS auto-scaling ([#150](https://github.com/CloudNationHQ/terraform-azure-aks/issues/150)) ([6cb4e20](https://github.com/CloudNationHQ/terraform-azure-aks/commit/6cb4e20dbbd55a8f41fa4b107cf7865f3be1feea))

## [4.1.0](https://github.com/CloudNationHQ/terraform-azure-aks/compare/v4.0.1...v4.1.0) (2025-10-31)


### Features

* add missing properties api server access profile ([#141](https://github.com/CloudNationHQ/terraform-azure-aks/issues/141)) ([f390be9](https://github.com/CloudNationHQ/terraform-azure-aks/commit/f390be9a4c417f93ec3a1dcf4269eb9ec60b1c5b))
* **deps:** bump github.com/cloudnationhq/az-cn-go-validor in /tests ([#138](https://github.com/CloudNationHQ/terraform-azure-aks/issues/138)) ([380de0f](https://github.com/CloudNationHQ/terraform-azure-aks/commit/380de0f5bac6cc65447c30feef63919d1d58e03a))
* **deps:** bump github.com/ulikunitz/xz from 0.5.10 to 0.5.14 in /tests ([#132](https://github.com/CloudNationHQ/terraform-azure-aks/issues/132)) ([8bc8f3c](https://github.com/CloudNationHQ/terraform-azure-aks/commit/8bc8f3c1fd3550e6921f899f2be3a88b6287c76a))

## [4.0.1](https://github.com/CloudNationHQ/terraform-azure-aks/compare/v4.0.0...v4.0.1) (2025-10-02)


### Bug Fixes

* Bugfix for ssh key passing ([#136](https://github.com/CloudNationHQ/terraform-azure-aks/issues/136)) ([f1552ba](https://github.com/CloudNationHQ/terraform-azure-aks/commit/f1552bad6770262b9f7bea52e490be2ac1a93319))

## [4.0.0](https://github.com/CloudNationHQ/terraform-azure-aks/compare/v3.7.0...v4.0.0) (2025-08-28)


### ⚠ BREAKING CHANGES

* this change causes recreates

### Features

* add type definitions and changed data structure ([#130](https://github.com/CloudNationHQ/terraform-azure-aks/issues/130)) ([6d54751](https://github.com/CloudNationHQ/terraform-azure-aks/commit/6d547513bb5ed6b66af8046d52e66605bbe79a4f))

### Upgrade from v3.7.0 to v4.0.0:

- Update module reference to: `version = "~> 4.0"`
- The property and variable resource_group is renamed to resource_group_name
- The user assigned identity resource is moved to a dedicated module
- The use of credentials changed in the data structure. See the examples for more details

## [3.7.0](https://github.com/CloudNationHQ/terraform-azure-aks/compare/v3.6.0...v3.7.0) (2025-08-11)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#123](https://github.com/CloudNationHQ/terraform-azure-aks/issues/123)) ([a0b891e](https://github.com/CloudNationHQ/terraform-azure-aks/commit/a0b891e1b09ca64e79c489aad0f30b8a89f667cf))
* **deps:** bump golang.org/x/net from 0.33.0 to 0.38.0 in /tests ([#127](https://github.com/CloudNationHQ/terraform-azure-aks/issues/127)) ([996376b](https://github.com/CloudNationHQ/terraform-azure-aks/commit/996376b022a0e3c5963a0eb3d4f2016f5206202c))
* schema validation items for aks and resource_group_name change ([#128](https://github.com/CloudNationHQ/terraform-azure-aks/issues/128)) ([05e63a1](https://github.com/CloudNationHQ/terraform-azure-aks/commit/05e63a1c021d016eb0764e99d7261b0f4cb3f623))

## [3.6.0](https://github.com/CloudNationHQ/terraform-azure-aks/compare/v3.5.0...v3.6.0) (2025-01-20)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#118](https://github.com/CloudNationHQ/terraform-azure-aks/issues/118)) ([cbb1532](https://github.com/CloudNationHQ/terraform-azure-aks/commit/cbb153296afa2eb25088ea413c91fd4533a5d4a0))
* **deps:** bump golang.org/x/net from 0.31.0 to 0.33.0 in /tests ([#121](https://github.com/CloudNationHQ/terraform-azure-aks/issues/121)) ([2cef183](https://github.com/CloudNationHQ/terraform-azure-aks/commit/2cef18325b4ef2340c638e9ec14a69ac73f70edc))
* remove temporary files when deployment tests fails ([#119](https://github.com/CloudNationHQ/terraform-azure-aks/issues/119)) ([1dfa021](https://github.com/CloudNationHQ/terraform-azure-aks/commit/1dfa0214cc10dc407119175b9de21f9773aae276))

## [3.5.0](https://github.com/CloudNationHQ/terraform-azure-aks/compare/v3.4.0...v3.5.0) (2024-11-11)


### Features

* enhance testing with sequential, parallel modes and flags for exceptions and skip-destroy ([#114](https://github.com/CloudNationHQ/terraform-azure-aks/issues/114)) ([f10f51a](https://github.com/CloudNationHQ/terraform-azure-aks/commit/f10f51aca126c6b9497304742799e337d21e99d1))

## [3.4.0](https://github.com/CloudNationHQ/terraform-azure-aks/compare/v3.3.0...v3.4.0) (2024-10-16)


### Features

* add identity output ([#112](https://github.com/CloudNationHQ/terraform-azure-aks/issues/112)) ([94501c2](https://github.com/CloudNationHQ/terraform-azure-aks/commit/94501c2067c96e1d468b11f12c83b54dc242fe46))

## [3.3.0](https://github.com/CloudNationHQ/terraform-azure-aks/compare/v3.2.1...v3.3.0) (2024-10-11)


### Features

* auto generated docs and refine makefile ([#110](https://github.com/CloudNationHQ/terraform-azure-aks/issues/110)) ([c056055](https://github.com/CloudNationHQ/terraform-azure-aks/commit/c05605589d6aebaaa8797b3260086fe651628dfd))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#103](https://github.com/CloudNationHQ/terraform-azure-aks/issues/103)) ([ea32885](https://github.com/CloudNationHQ/terraform-azure-aks/commit/ea32885a80428094efbf128cfa62249519ca2823))

## [3.2.1](https://github.com/CloudNationHQ/terraform-azure-aks/compare/v3.2.0...v3.2.1) (2024-10-09)


### Bug Fixes

* remove subfolder from configuration ([#108](https://github.com/CloudNationHQ/terraform-azure-aks/issues/108)) ([d8605ab](https://github.com/CloudNationHQ/terraform-azure-aks/commit/d8605ab76c2bd90411291d3c86f41da7109ed2ef))

## [3.2.0](https://github.com/CloudNationHQ/terraform-azure-aks/compare/v3.1.1...v3.2.0) (2024-10-09)


### Features

* allow custom user assigned identity name ([#105](https://github.com/CloudNationHQ/terraform-azure-aks/issues/105)) ([dcfbebe](https://github.com/CloudNationHQ/terraform-azure-aks/commit/dcfbebee63578d934beecd8e80b828954618aa70))

## [3.1.1](https://github.com/CloudNationHQ/terraform-azure-aks/compare/v3.1.0...v3.1.1) (2024-10-07)


### Bug Fixes

* increment versioning in usages ([#101](https://github.com/CloudNationHQ/terraform-azure-aks/issues/101)) ([62604fe](https://github.com/CloudNationHQ/terraform-azure-aks/commit/62604fed8f5412f031705aae8c768c5401cb0469))

## [3.1.0](https://github.com/CloudNationHQ/terraform-azure-aks/compare/v3.0.0...v3.1.0) (2024-10-07)


### Features

* small refactor ([#99](https://github.com/CloudNationHQ/terraform-azure-aks/issues/99)) ([9a27b69](https://github.com/CloudNationHQ/terraform-azure-aks/commit/9a27b699a6cb7211c9cb4e4a78c760cdd94d7da0))

## [3.0.0](https://github.com/CloudNationHQ/terraform-azure-aks/compare/v2.1.0...v3.0.0) (2024-09-26)


### ⚠ BREAKING CHANGES

* data structure has changed due to renaming of properties.

### Features

* aligned several properties in kubernetes pools ([#96](https://github.com/CloudNationHQ/terraform-azure-aks/issues/96)) ([84d097b](https://github.com/CloudNationHQ/terraform-azure-aks/commit/84d097b05edf3071964c3632801f0c011c601329))

### Upgrade from v2.1.0 to v3.0.0:

- Update module reference to: `version = "~> 3.0"`
  - several small enhancements and integrated the functionality from the locals into the resource kubernetes pools resource itself

## [2.1.0](https://github.com/CloudNationHQ/terraform-azure-aks/compare/v2.0.0...v2.1.0) (2024-09-25)


### Features

* add node soak duration and drain timout in minutes support ([#92](https://github.com/CloudNationHQ/terraform-azure-aks/issues/92)) ([63f7fa5](https://github.com/CloudNationHQ/terraform-azure-aks/commit/63f7fa59486dbaa8601baddf6e5e98053aea958b))

## [2.0.0](https://github.com/CloudNationHQ/terraform-azure-aks/compare/v1.0.0...v2.0.0) (2024-09-25)


### ⚠ BREAKING CHANGES

* Version 4 of the azurerm provider includes breaking changes.

### Features

* upgrade azurerm provider to v4 ([#89](https://github.com/CloudNationHQ/terraform-azure-aks/issues/89)) ([b003a3a](https://github.com/CloudNationHQ/terraform-azure-aks/commit/b003a3a29cf4b5c6a775fac8c438c23f7c646c12))

### Upgrade from v1.0.0 to v2.0.0:

- Update module reference to: `version = "~> 2.0"`
- Changed properties in cluster object:
  - automatic_channel_upgrade -> automatic_upgrade_channel
  - node_os_channel_upgrade -> node_os_upgrade_channel
  - azure_active_directory_role_based_access_control.managed -> removed
  - network_profile.outbound_ip_prefix_ids -> removed
  - network_profile.outbound_ip_address_ids -> removed
  - enable_auto_scaling -> auto_scaling_enabled
  - enable_host_encryption -> host_encryption_enabled
  - enable_node_public_ip -> node_public_ip_enabled

## [1.0.0](https://github.com/CloudNationHQ/terraform-azure-aks/compare/v0.12.0...v1.0.0) (2024-08-22)


### ⚠ BREAKING CHANGES

* data structure has changed due to renaming of properties and output variables.

### Features

* aligned several properties ([#85](https://github.com/CloudNationHQ/terraform-azure-aks/issues/85)) ([b46f077](https://github.com/CloudNationHQ/terraform-azure-aks/commit/b46f077a03cad4bc4d18c9daeb3af40a92ea4bdc))

### Upgrade from v0.12.0 to v1.0.0:

- Update module reference to: `version = "~> 1.0"`
- Rename or remove properties in cluster object:
  - resourcegroup -> resource_group
  - custom_ca_trust_certificates_base64 -> deprecated
  - azure_active_directory_role_based_access_control -> several deprecated properties
  - custom_ca_trust_enabled -> deprecated
  - load_balancer -> load_balancer_profile
  - proxy -> http_proxy_config
  - workspace.enable.oms_agent -> oms_agent
  - workspace.enable.defender -> microsoft_defender
  - profile.service_mesh -> service_mesh_profile
  - profile.autoscaler -> workload_autoscaler_profile
  - maintenance.general -> maintenance_window
  - maintenance.node_os -> maintenance_window_node_os
  - maintenance.auto_upgrade -> maintenance_window_auto_upgrade
  - default_node_pool.config.linux_os -> default_node_pool.linux_os_config
  - default_node_pool.config.kubelet ->  default_node_pool.kubelet_config
- Rename variable (optional):
  - resourcegroup -> resource_group
- Rename output variable:
  - subscriptionId -> subscription_id'
- Change defaults:
  - role_based_access_control_enabled now defaults to true
  - local_account_disabled now defaults to false
  - skip_service_principal_aad_check now defaults to false
- Change required properties:
  - identity is now required for all usages

## [0.12.0](https://github.com/CloudNationHQ/terraform-azure-aks/compare/v0.11.0...v0.12.0) (2024-07-04)


### Features

* update contribution docs ([#80](https://github.com/CloudNationHQ/terraform-azure-aks/issues/80)) ([22734ee](https://github.com/CloudNationHQ/terraform-azure-aks/commit/22734ee710b1dcb7f985fb7fba031620c7b50247))

## [0.11.0](https://github.com/CloudNationHQ/terraform-azure-aks/compare/v0.10.0...v0.11.0) (2024-07-01)


### Features

* add issue templates ([#78](https://github.com/CloudNationHQ/terraform-azure-aks/issues/78)) ([488ab5c](https://github.com/CloudNationHQ/terraform-azure-aks/commit/488ab5c456be70321953faa3514304a029a145e5))
* **deps:** bump github.com/Azure/azure-sdk-for-go/sdk/azidentity ([#69](https://github.com/CloudNationHQ/terraform-azure-aks/issues/69)) ([9184644](https://github.com/CloudNationHQ/terraform-azure-aks/commit/91846448a1ddcba007cf5f86e17b94361cdb8f5f))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#77](https://github.com/CloudNationHQ/terraform-azure-aks/issues/77)) ([32016da](https://github.com/CloudNationHQ/terraform-azure-aks/commit/32016da5fc1d7c587b5b9d5990fc2e88a3fb57d7))
* **deps:** bump github.com/hashicorp/go-getter in /tests ([#70](https://github.com/CloudNationHQ/terraform-azure-aks/issues/70)) ([5d98ee7](https://github.com/CloudNationHQ/terraform-azure-aks/commit/5d98ee77316ab24c5a905d075221f80f62817f26))


### Bug Fixes

* explicitly set fallback values for ssh key and admin password ([#72](https://github.com/CloudNationHQ/terraform-azure-aks/issues/72)) ([a6f7c6e](https://github.com/CloudNationHQ/terraform-azure-aks/commit/a6f7c6e8df5790c15e47af3054a8dc5875b0c341))
* fix validation error when deploying windows cluster with azure network plugin ([#74](https://github.com/CloudNationHQ/terraform-azure-aks/issues/74)) ([706f180](https://github.com/CloudNationHQ/terraform-azure-aks/commit/706f180f095762560d1d9da05e930ed52ba90d1c))

## [0.10.0](https://github.com/CloudNationHQ/terraform-azure-aks/compare/v0.9.0...v0.10.0) (2024-06-21)


### Features

* add support for bring you own ssh keys or passwords ([#67](https://github.com/CloudNationHQ/terraform-azure-aks/issues/67)) ([789f594](https://github.com/CloudNationHQ/terraform-azure-aks/commit/789f59407c8e047c8c33533b281b9e71a788d1b0))
* add web app routing support ([#66](https://github.com/CloudNationHQ/terraform-azure-aks/issues/66)) ([5b49223](https://github.com/CloudNationHQ/terraform-azure-aks/commit/5b49223e7cf907f164f6953857d58ca9f1956f39))
* **deps:** bump github.com/Azure/azure-sdk-for-go/sdk/azidentity ([#64](https://github.com/CloudNationHQ/terraform-azure-aks/issues/64)) ([eff1ce9](https://github.com/CloudNationHQ/terraform-azure-aks/commit/eff1ce99a6df2dab095da509d14726c2fa39078a))

## [0.9.0](https://github.com/CloudNationHQ/terraform-azure-aks/compare/v0.8.0...v0.9.0) (2024-06-07)


### Features

* add pull request template ([#62](https://github.com/CloudNationHQ/terraform-azure-aks/issues/62)) ([c2a7b0b](https://github.com/CloudNationHQ/terraform-azure-aks/commit/c2a7b0b5a69d3b2b17d1d6169ef2a59957babe40))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#61](https://github.com/CloudNationHQ/terraform-azure-aks/issues/61)) ([bde67eb](https://github.com/CloudNationHQ/terraform-azure-aks/commit/bde67eb9bbfac826073f389cd19b94ba12e78d49))
* **deps:** bump github.com/hashicorp/go-getter in /tests ([#59](https://github.com/CloudNationHQ/terraform-azure-aks/issues/59)) ([350cce4](https://github.com/CloudNationHQ/terraform-azure-aks/commit/350cce4624153b586d66efde75783e89b5eae08f))
* **deps:** bump golang.org/x/net from 0.22.0 to 0.23.0 in /tests ([#56](https://github.com/CloudNationHQ/terraform-azure-aks/issues/56)) ([cde241b](https://github.com/CloudNationHQ/terraform-azure-aks/commit/cde241b2be90509ed4d277916e9895f1b7ce7f6b))

## [0.8.0](https://github.com/CloudNationHQ/terraform-azure-aks/compare/v0.7.0...v0.8.0) (2024-04-16)


### Features

* change defaults vm size to enhance cost efficiency ([#55](https://github.com/CloudNationHQ/terraform-azure-aks/issues/55)) ([91ee5a1](https://github.com/CloudNationHQ/terraform-azure-aks/commit/91ee5a17539449022a461bb2e109b2ba3a730ce4))
* **deps:** bump github.com/Azure/azure-sdk-for-go/sdk/azidentity ([#48](https://github.com/CloudNationHQ/terraform-azure-aks/issues/48)) ([e5bd45a](https://github.com/CloudNationHQ/terraform-azure-aks/commit/e5bd45aec674cac23e6c135b5f144cc63e3cdd0a))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#47](https://github.com/CloudNationHQ/terraform-azure-aks/issues/47)) ([2225ed7](https://github.com/CloudNationHQ/terraform-azure-aks/commit/2225ed7369d2872b68bdabf7b74b638f092b53ae))
* **deps:** bump google.golang.org/protobuf in /tests ([#45](https://github.com/CloudNationHQ/terraform-azure-aks/issues/45)) ([f5d7fde](https://github.com/CloudNationHQ/terraform-azure-aks/commit/f5d7fdedbced5dae8fd74ba71f1bb2614fd42357))
* fix upgrade settings default node pool ([#53](https://github.com/CloudNationHQ/terraform-azure-aks/issues/53)) ([d8a0019](https://github.com/CloudNationHQ/terraform-azure-aks/commit/d8a00195665452c8e64453ae29ae3d6ecc795bbd))
* improve allignment local account property ([#54](https://github.com/CloudNationHQ/terraform-azure-aks/issues/54)) ([90a9fca](https://github.com/CloudNationHQ/terraform-azure-aks/commit/90a9fca45566187c1704002d878a9ada8c7830a7))

## [0.7.0](https://github.com/CloudNationHQ/terraform-azure-aks/compare/v0.6.0...v0.7.0) (2024-03-07)


### Features

* improve alignment properties ([#42](https://github.com/CloudNationHQ/terraform-azure-aks/issues/42)) ([16eee92](https://github.com/CloudNationHQ/terraform-azure-aks/commit/16eee925e757e444e647a8132cb396059d43205d))
* optimized dynamic identity blocks ([#44](https://github.com/CloudNationHQ/terraform-azure-aks/issues/44)) ([d4eeaaa](https://github.com/CloudNationHQ/terraform-azure-aks/commit/d4eeaaadcd857b70b42cb37338e1101133463108))

## [0.6.0](https://github.com/CloudNationHQ/terraform-azure-aks/compare/v0.5.0...v0.6.0) (2024-03-06)


### Features

* **deps:** bump github.com/stretchr/testify in /tests ([#39](https://github.com/CloudNationHQ/terraform-azure-aks/issues/39)) ([25ce0c7](https://github.com/CloudNationHQ/terraform-azure-aks/commit/25ce0c7924c926b88e034798b9d1c5617727ff11))
* update documentation ([#40](https://github.com/CloudNationHQ/terraform-azure-aks/issues/40)) ([66ed3b5](https://github.com/CloudNationHQ/terraform-azure-aks/commit/66ed3b50bdf0574a9f5ddc032c9768ab902148d6))

## [0.5.0](https://github.com/CloudNationHQ/terraform-azure-aks/compare/v0.4.2...v0.5.0) (2024-03-01)


### Features

* add monitor metrics support ([#36](https://github.com/CloudNationHQ/terraform-azure-aks/issues/36)) ([09c213a](https://github.com/CloudNationHQ/terraform-azure-aks/commit/09c213a01438739bbcb68f2c388ade7ae02a7ed6))
* add several missing properties ([#38](https://github.com/CloudNationHQ/terraform-azure-aks/issues/38)) ([065d070](https://github.com/CloudNationHQ/terraform-azure-aks/commit/065d0709423e8f089e03e2a037d6a9672534a3cc))

## [0.4.2](https://github.com/CloudNationHQ/terraform-azure-aks/compare/v0.4.1...v0.4.2) (2024-02-13)


### Bug Fixes

* added key vault secrets provider ([#34](https://github.com/CloudNationHQ/terraform-azure-aks/issues/34)) ([091210d](https://github.com/CloudNationHQ/terraform-azure-aks/commit/091210d512e86c8646c0d69a14012354c5e3354e))

## [0.4.1](https://github.com/CloudNationHQ/terraform-azure-aks/compare/v0.4.0...v0.4.1) (2024-02-05)


### Bug Fixes

* oms agent dynamic block iteration and attribute access ([#30](https://github.com/CloudNationHQ/terraform-azure-aks/issues/30)) ([69d558a](https://github.com/CloudNationHQ/terraform-azure-aks/commit/69d558a82baa1aaf1f58b4bbf56d20ec63b9b74c))

## [0.4.0](https://github.com/CloudNationHQ/terraform-azure-aks/compare/v0.3.0...v0.4.0) (2024-01-29)


### Features

* **deps:** bump github.com/Azure/azure-sdk-for-go/sdk/azidentity ([#24](https://github.com/CloudNationHQ/terraform-azure-aks/issues/24)) ([ca0fc89](https://github.com/CloudNationHQ/terraform-azure-aks/commit/ca0fc89470bb03fddd1b3aef2b89b71c046c37fc))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#23](https://github.com/CloudNationHQ/terraform-azure-aks/issues/23)) ([3ad41be](https://github.com/CloudNationHQ/terraform-azure-aks/commit/3ad41be622a77a5b6c7976fcd744f7639fcd8d2f))
* disable node count on default pool when auto scaling is used ([#28](https://github.com/CloudNationHQ/terraform-azure-aks/issues/28)) ([ddf20f9](https://github.com/CloudNationHQ/terraform-azure-aks/commit/ddf20f9120325fa92c7510144c9da3976b2199e9))
* improve naming node pools ([#25](https://github.com/CloudNationHQ/terraform-azure-aks/issues/25)) ([c83c82b](https://github.com/CloudNationHQ/terraform-azure-aks/commit/c83c82ba85d3a29c3706b0a5233b768f3f63a9c4))
* improving autoscaler block iteration to exist only once ([#27](https://github.com/CloudNationHQ/terraform-azure-aks/issues/27)) ([5495709](https://github.com/CloudNationHQ/terraform-azure-aks/commit/54957097e5bf18f91e3bf1c196612e407cebd1c2))

## [0.3.0](https://github.com/CloudNationHQ/terraform-azure-aks/compare/v0.2.0...v0.3.0) (2024-01-19)


### Features

* add missing properties node pools ([#13](https://github.com/CloudNationHQ/terraform-azure-aks/issues/13)) ([29a155f](https://github.com/CloudNationHQ/terraform-azure-aks/commit/29a155f480240bf731231a6dd3764770070e4808))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#15](https://github.com/CloudNationHQ/terraform-azure-aks/issues/15)) ([c89038b](https://github.com/CloudNationHQ/terraform-azure-aks/commit/c89038b68bf7e9cd8728d3c88092c74e9ffe0ff3))
* **deps:** bump golang.org/x/crypto from 0.14.0 to 0.17.0 in /tests ([#6](https://github.com/CloudNationHQ/terraform-azure-aks/issues/6)) ([f035e1b](https://github.com/CloudNationHQ/terraform-azure-aks/commit/f035e1b7fbb30d174d6ebdab0dfce946ebdfb9db))
* small refactor workflows ([#22](https://github.com/CloudNationHQ/terraform-azure-aks/issues/22)) ([d8d47b1](https://github.com/CloudNationHQ/terraform-azure-aks/commit/d8d47b19d5b8a0c3cdc7d7162a1d9442efb285cf))

## [0.2.0](https://github.com/CloudNationHQ/terraform-azure-aks/compare/v0.1.0...v0.2.0) (2023-12-18)


### Features

* small refactor extended tests ([#5](https://github.com/CloudNationHQ/terraform-azure-aks/issues/5)) ([a2d9f79](https://github.com/CloudNationHQ/terraform-azure-aks/commit/a2d9f79cedafba165b9e7a0e9bde470a46ceedc5))
* update documentation ([c637bf5](https://github.com/CloudNationHQ/terraform-azure-aks/commit/c637bf5e297c05bbed230257d8b548861c430357))

## 0.1.0 (2023-12-15)


### Features

* add initial resources ([#1](https://github.com/CloudNationHQ/terraform-azure-aks/issues/1)) ([b4536c3](https://github.com/CloudNationHQ/terraform-azure-aks/commit/b4536c36e21fa647f7a652293638847786ecefd8))
