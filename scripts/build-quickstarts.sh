#!/bin/bash -e

if [ -n "$PRODUCT" ] && [ "$PRODUCT" == "true" ]; then
  args="-s $PRODUCT_MVN_SETTINGS  -Dmaven.repo.local=$PRODUCT_MVN_REPO"
else
  args="-s maven-settings.xml"
fi

# generate keycloak.json
for f in $(find . -type f -name 'keycloak-example.json'); do
   cp "$f" "${f%-example.json}.json"
done

for f in $(find . -type f -name 'keycloak-saml-example.xml'); do
   cp "$f" "${f%-example.xml}.xml"
done

if [ -n "$1" ] ; then
  args="$args -D$1"
fi

echo "mvn clean install $args -DskipTests -B -Dnightly"

mvn clean install $args -DskipTests -B -Dnightly
if [ -n "$PRODUCT" ] && [ "$PRODUCT" == "true" ]; then
  dist=$PRODUCT_DIST
else
  dist="keycloak-dist"
fi

if [ "$1" == "extension" ]; then
  cp extension/action-token-authenticator/target/action-token-example.jar $dist/providers
  cp extension/action-token-required-action/target/action-token-req-action-example.jar $dist/providers
  cp extension/event-listener-sysout/target/event-listener-sysout.jar $dist/providers
  cp extension/event-store-mem/target/event-store-mem.jar $dist/providers
  cp extension/extend-account-console/target/keycloak-man-theme.jar $dist/providers
  cp extension/user-storage-simple/target/user-storage-properties-example.jar $dist/providers
  cp extension/user-storage-jpa/conf/quarkus.properties $dist/conf
  cp extension/user-storage-jpa/target/user-storage-jpa-example.jar $dist/providers
fi

