#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libtomcat.sh
. /opt/bitnami/scripts/liblog.sh

# Load Tomcat environment variables
. /opt/bitnami/scripts/tomcat-env.sh

info "** Starting Tomcat **"

# Copy New Security Config
cp -r -L /opt/bitnami/scripts/jasperreports/config/security-config.properties /bitnami/tomcat/webapps/jasperserver/WEB-INF/classes/esapi/security-config.properties
cp -r -L /opt/bitnami/scripts/jasperreports/config/validation.properties /bitnami/tomcat/webapps/jasperserver/WEB-INF/classes/esapi/validation.properties
cp -r -L /opt/bitnami/scripts/jasperreports/libs/Baht.jar /bitnami/tomcat/webapps/jasperserver/WEB-INF/lib/Baht.jar 
cp -r -L "/opt/bitnami/scripts/jasperreports/libs/TH SarabunPSK.jar" "/bitnami/tomcat/webapps/jasperserver/WEB-INF/lib/TH SarabunPSK.jar"
cp -r -L /opt/bitnami/scripts/jasperreports/libs/ojdbc6-11.2.0.3.jar /bitnami/tomcat/webapps/jasperserver/WEB-INF/lib/ojdbc6-11.2.0.3.jar

if am_i_root; then
    exec gosu "$TOMCAT_DAEMON_USER" "${TOMCAT_BIN_DIR}/catalina.sh" run "$@"
else
    exec "${TOMCAT_BIN_DIR}/catalina.sh" run "$@"
fi

