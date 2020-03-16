properties(
  [
    parameters(
      [
        string(
          defaultValue: 'https://github.com/redhat-multiarch-qe/multiarch-ci-libraries',
          description: 'Repo for shared libraries.',
          name: 'LIBRARIES_REPO'
        ),
        string(
          defaultValue: 'v1.3.0',
          description: 'Git reference to the branch or tag of shared libraries.',
          name: 'LIBRARIES_REF'
        ),
	string(
	  defaultValue: 'hp-moonshot-01-c29.ml3.eng.bos.redhat.com',
	  description: 'Hostname of the preprovisoined host.',
	  name: 'PREPROVISIONED_HOST'
	),
	string(
	  defaultValue:'osp-jenkins-private-key',
	  description: 'SSH private key Jenkins credential ID for Beaker/SSH operations',
	  name: 'SSHPRIVKEYCREDENTIALID'
	),
      ]
    )
  ]
)

library(
  changelog: false,
  identifier: "multiarch-ci-libraries@${params.LIBRARIES_REF}",
  retriever: modernSCM([$class: 'GitSCMSource',remote: "${params.LIBRARIES_REPO}"])
)

def errorMessages = ''
def config = MAQEAPI.v1.getProvisioningConfig(this)
config.jobgroup = 'multiarch-qe'

def targetHost = MAQEAPI.v1.newTargetHost()
targetHost.hostname = params.PREPROVISIONED_HOST
targetHost.name = params.PREPROVISIONED_HOST
targetHost.arch = 'x86_64'
targetHost.provisioner = 'NOOP'

withCredentials([usernamePassword(credentialsId:'osp16-gitlab-consulting-rh', 
				  usernameVariable:'USERNAME', 
				  passwordVariable:'TOKEN',)
]){
	targetHost.scriptParams = "$USERNAME $TOKEN"
}

MAQEAPI.v1.runTest(
  this,
  targetHost,
  config,
  { host ->
    /*********************************************************/
    /* TEST BODY                                             */
    /* @param host               Provisioned host details.   */
    /*********************************************************/
    stage ('Download Test Files') {
      downloadTests()
    }

    stage ('Run Test') {
      runTests(config, host)
    }

    /*****************************************************************/
    /* END TEST BODY                                                 */
    /* Do not edit beyond this point                                 */
    /*****************************************************************/
  },
  { Exception exception, def host ->
    def error = "Exception ${exception} occured on ${host.arch}\n"
    errorMessages += error
    currentBuild.result = 'FAILURE'
  }
)
