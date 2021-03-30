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
        remote.host = '54.234.85.125'
        remote.user = 'root'
        remote.password = 'admin'
        remote.allowAnyHosts = true
        
        stage("SSH into K8s Master") {
			  withCredentials([sshUserPrivateKey(credentialsId: 'ssh2', keyFileVariable: 'identity', passphraseVariable: '', usernameVariable: 'root')]) {
				  remote.user = root
				  remote.identityFile = identity
				  
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

