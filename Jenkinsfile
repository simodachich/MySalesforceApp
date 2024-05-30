#!groovy
import groovy.json.JsonSlurperClassic
node {
    def BUILD_NUMBER=env.BUILD_NUMBER
    def RUN_ARTIFACT_DIR="tests/${BUILD_NUMBER}"
    def SFDC_USERNAME

    def HUB_ORG=env.HUB_ORG_DH
    def SFDC_HOST = env.SFDC_HOST_DH
    def JWT_KEY_CRED_ID = env.JWT_CRED_ID_DH
    def CONNECTED_APP_CONSUMER_KEY=env.CONNECTED_APP_CONSUMER_KEY_DH

    println "KEY IS: ${JWT_KEY_CRED_ID}"
    println "HUB_ORG: ${HUB_ORG}"
    println "SFDC_HOST: ${SFDC_HOST}"
    println "CONNECTED_APP_CONSUMER_KEY: ${CONNECTED_APP_CONSUMER_KEY}"

    if (!JWT_KEY_CRED_ID) {
        error "JWT_KEY_CRED_ID is not set!"
    }
    if (!HUB_ORG) {
        error "HUB_ORG is not set!"
    }
    if (!SFDC_HOST) {
        error "SFDC_HOST is not set!"
    }
    if (!CONNECTED_APP_CONSUMER_KEY) {
        error "CONNECTED_APP_CONSUMER_KEY is not set!"
    }

    def toolbelt = tool name: 'toolbelt', type: 'com.cloudbees.jenkins.plugins.customtools.CustomTool'

    stage('checkout source') {
        // when running in multi-branch job, one must issue this command
        checkout scm
    }

    withCredentials([file(credentialsId: JWT_KEY_CRED_ID, variable: 'jwt_key_file')]) {
        stage('Deploy Code') {
            if (isUnix()) {
                rc = sh returnStatus: true, script: "${toolbelt} force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile ${jwt_key_file} --setdefaultdevhubusername --instanceurl ${SFDC_HOST}"
            } else {
                def sfdxPath = "${toolbelt}\\bin\\sfdx"
                rc = bat returnStatus: true, script: "\"${sfdxPath}\" force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile \"${jwt_key_file}\" --setdefaultdevhubusername --instanceurl ${SFDC_HOST}"
            }
            if (rc != 0) {
                error 'hub org authorization failed'
            }

            println rc

            // need to pull out assigned username
            if (isUnix()) {
                rmsg = sh returnStdout: true, script: "${toolbelt} force:mdapi:deploy -d manifest/. -u ${HUB_ORG}"
            } else {
                rmsg = bat returnStdout: true, script: "\"${sfdxPath}\" force:mdapi:deploy -d manifest/. -u ${HUB_ORG}"
            }

            printf rmsg
            println('Hello from a Job DSL script!')
            println(rmsg)
        }
    }
}
