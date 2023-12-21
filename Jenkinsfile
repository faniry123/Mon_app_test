pipeline{
agent any
stages('Build'){
  steps{
    sh '/home/faniry/maven3/mvm clean install'
}
}
  stages('Build'){
  steps{
    sh '/home/faniry/maven3/mvm test'
}
}
}
