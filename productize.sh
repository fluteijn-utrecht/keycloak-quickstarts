# surrounding_tags will be master in the end
git config user.name "${GH_USER_NAME}"
git config user.email "{GH_USER_EMAIL}"


# Rename Keycloak to Red Hat SSO
find . -type f -name "*README*" -exec sed -i 's@<span>Keycloak</span>@Red Hat SSO@g' {} +
# Rename WildFly to JBoss EAP
find . -type f -name "*README*" -exec sed -i 's@<span>WildFly</span>@JBoss EAP@g' {} +
find . -type f -name "*README*" -exec sed -i 's@<span>WildFly 10</span>@JBoss EAP@g' {} +

# Rename env
find . -type f -name "*README*" -exec sed -i 's@<span>KEYCLOAK_HOME</span>@RHSSO_HOME@g' {} +
find . -type f -name "*README*" -exec sed -i 's@<span>WILDFLY_HOME</span>@EAP_HOME@g' {} +

# Rename commands
find . -type f -name "*README*" -exec sed -i 's@KEYCLOAK_HOME/bin@RHSSO_HOME/bin@g' {} +
find . -type f -name "*README*" -exec sed -i 's@KEYCLOAK_HOME\bin@RHSSO_HOME\bin@g' {} +
find . -type f -name "*README*" -exec sed -i 's@WILDFLY_HOME/bin@EAP_HOME/bin@g' {} +
find . -type f -name "*README*" -exec sed -i 's@WILDFLY_HOME\bin@EAP_HOME\bin@g' {} +

# Add RHSSO Repo
sed -i '/<\/project>/{ 
    r scripts/ssorepo.txt
    a \</project>
    d 
}' pom.xml

#rename groupId in POMs
find . -type f -name "*pom.xml*" -exec sed -i 's@<groupId>org.keycloak.bom</groupId>@<groupId>com.redhat.bom.rh-sso</groupId>@g' {} +
find . -type f -name "*pom.xml*" -exec sed -i 's@<groupId>org.keycloak.quickstarts</groupId>@<groupId>com.redhat.rh-sso</groupId>@g' {} +

git checkout -b prod_staging
git rm -r action-token-authenticator
git rm -r action-token-required-action
git status

git commit . -m "rename pom and readme"
git push --force "https://${GH_TOKEN}@${GH_REF}" prod_staging:production-test
