ui            = true
api_addr      = "http://127.0.0.1:8200"
disable_mlock = true

listener "tcp" {
  tls_disable = 1
  address     = "[::]:8200"
}

storage "file" {
  path = "/vault/data"
}
