resource "local_file" "distros" {
  filename = "/tmp/nix.txt"
  content = "I Love Linux distros like Ubuntu. Debian, RHEL, Rocky Linux & Kali Linux etc"
}