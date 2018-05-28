job "fabio" {
  datacenters = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e"]
  type = "system"
  update {
    stagger = "5s"
    max_parallel = 1
  }

  group "fabio" {
    task "fabio" {
      driver = "exec"
      config {
        command = "fabio-1.3.3-go1.7.1-linux_amd64"
      }

      artifact {
        source = "https://github.com/eBay/fabio/releases/download/v1.3.3/fabio-1.3.3-go1.7.1-linux_amd64"
      }

      resources {
        cpu = 500
        memory = 128
        network {
          mbits = 1

          port "http" {
            static = 9999
          }
          port "ui" {
            static = 9998
          }
        }
      }
    }
  }
}