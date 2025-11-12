resource "cloudru_mcm_network" "net" {
    # NOTE: Это вычисляемый параметр
    # id = "1"

    # NOTE: Это обязательный параметр
    name = "terraform_test_net"

    # NOTE: Это обязательный параметр
    platform_name = "openstack_1"

    # NOTE: Это обязательный параметр
    subnet_range = "192.168.0.1/24"

    # NOTE: Это опциональный параметр
    gateway = "192.168.0.1"
}
