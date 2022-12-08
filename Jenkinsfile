node{
    
    stage("Git Clone"){
        git credentialsId: 'GIT_CREDENTIALS', url: 'https://github.com/KingYummy/prodDev.git'
    }
    
    stage("Build Docker Image"){
        sh "docker version"
        sh "docker build . -t oriyombad/website"
        sh "docker image list"
    }
    
    stage("Push Image to Docker Hub"){
        withCredentials([string(credentialsId: 'DOCKER_HUB_CREDENTIALS', variable: 'DOCKER_HUB_CREDENTIALS')]) {
            sh "docker login -u oriyombad -p ${DOCKER_HUB_CREDENTIALS}"
        }
        sh "docker push oriyombad/website "
    }
    
    stage("SSH Into k8s Server") {
        def remote = [:]
        remote.name = 'K8S master'
        remote.host = '0.0.0.0'
        remote.user = 'username'
        remote.password = 'password'
        remote.allowAnyHosts = true
        
        stage("SSH into K8s Master") {
			  withCredentials([sshUserPrivateKey(credentialsId: 'ssh', keyFileVariable: 'identity', passphraseVariable: '', usernameVariable: 'root')]) {
				  remote.user = user
				  remote.identityFile = identityF
				  
				  stage('Put K8s Manifest File Into K8s Master') {
				      sshPut remote: remote, from: './prodDevDeploy.yaml', into: '.'
				  }
				  
				  stage('Deploy App') {
				      sshCommand remote: remote, command: "kubectl apply -f prodDevDeploy.yaml"
				  }
        
			  }
        }  
    }
      
    
}

