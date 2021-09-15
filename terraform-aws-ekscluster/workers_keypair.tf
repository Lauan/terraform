resource "aws_key_pair" "workers_key" {
  key_name   = "${local.name_prefix}-keypair-workers"
  public_key = var.public_key
  tags              = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-keypair-workers"
    },
    {
      Lifecycle = "Common Infrasctructure"
    }
  )
}