resource "aws_key_pair" "my-key" {
  key_name   = "my-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJAjGlmeZ5APKqG271oSNH0kH3QQg+uIxZMfYOxgM/4L pepsh@ls"
  # resource "aws_key_pair" "test-key" {
  #   key_name = "test-key"
  #   public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKPVReCzW+jR/ZcxEp1Bd6AcmnubQaD6kqs2q2Z+9FLc pepsh@ls"

}
 