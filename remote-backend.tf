terraform {
  backend "remote" {
    hostname     = "app.terraform.io" #For SaaS use "app.terraform.io"
    organization = "ByteArray"        #Your Org, top-left corner of the TFE UI

    workspaces {
      name = "pipeline-test" #Workspace to connect to (lives within the Org)
    }
  }
}
