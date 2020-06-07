def repoName = "pipeline-test"                         //Repo to store TF code for the TFE Workspace
def repoSshUrl = "git@github.com:caroonv/pipeline-test.git"   //Must be ssh since we're using sshagent()
//Credentials
def gitCredentials = 'github-ssh'                   //Credential ID in Jenkins of your GitHub SSH Credentials
def tfeCredentials = 'ptfe'                         //Credential ID in Jenkins of your Terraform Enterprise Credentials

pipeline {
  agent any

  stages {

    stage('1. Add new terraform code to Workspace'){
      steps {
        echo "Pull down any existing Terraform code for this pipeline's Workspace..."
        sshagent (credentials: [gitCredentials]) {
          sh """
              #Clear old Workspace directory - VERY important to make sure no old Terraform code or config files are hanging around!
              rm -rf ${repoName} || true
              #Pull down current Workspace code
              git clone ${repoSshUrl}  #must be an ssh path, since we're using sshagent()
          """
        }
      }
    }

    stage('2. Run the Workspace'){
      environment {
          REPO_NAME = "${repoName}"
      }
      steps {
        /*
        Note: I originally had the TFE token stored in Jenkins as a "Secret text" credential, but that seemed to corrupt
        the contents of the string (auth failed), so I recreated it as a "Username with password" credential. Original line:
        withCredentials([string(credentialsId: tfeCredentials, variable: 'TOKEN')]) {
        */
        withCredentials([usernamePassword(credentialsId: tfeCredentials, usernameVariable: 'USER', passwordVariable: 'TOKEN')]) {
          sh '''
            cd $REPO_NAME       #This gets cleared in Stage 1, which is required for terraform init to run properly
            terraform init -backend-config="token=$TOKEN"  #Uses config.tf and the user API token to connect to TFE
            terraform apply
          '''
        }
      }
    }

    stage('3. Do integration or deployment testing'){
      steps {
        echo "Do whatever integration or deployment testing you need to do..."
      }
    }

    stage('4. Cleanup (destroy) the test machines'){
      steps {
        echo "Clean up"
      }
    }

  } //stages

  post {
    always {
      archiveArtifacts artifacts: "${repoName}/*.tf", fingerprint: true
    }
  }

}