resource "cloudru_mcm_server_group" "sg1" {
# NOTE: Это обязательный параметр
  name = "terraform-created-sg"

  # NOTE: Это обязательный параметр
  platform_name = "e2etest_openstack_1eeccd74-74ec-4b80-a61c-773ebb0ec68c"

  # NOTE: Это обязательный параметр, может иметь два значения "anti-affinity" и "soft-anti-affinity"
  policy = "anti-affinity"
}