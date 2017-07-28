# This bash script copies an existing domain project and replaces its contents to obtain a new domain project.
#
# Usage:
# /copyAndReplaceDomain.sh 1 2 3 4 5 6
# 	1 is folderOfTheSourceDomain 
# 	2 is 'Current description for the module in folderOfTheSourceDomain/pom.xml'
#	3 is tld.domain.namespace.of.the.sourcedomainmm
#	4 is folderOfTheTargetDomain 
#	5 is 'New description for the module'
#	6 is tld.domain.namespace.of.the.targetdomainmm
#
toFirstUpper() {
  S=$1;
  echo "$(tr '[:lower:]' '[:upper:]' <<< ${S:0:1})${S:1}"
}
replace() {
  MATCH=$1;
  REPLACE=$2;
  sed -i 's/'"$MATCH"'/'"$REPLACE"'/g' bundles/${TARGET_FOLDER}/pom.xml bundles/${TARGET_FOLDER}/${TARGET_PROJECT_FOLDER}/.project bundles/${TARGET_FOLDER}/${TARGET_PROJECT_FOLDER}/plugin.xml features/${TARGET_PROJECT_FOLDER}.feature/feature.properties features/${TARGET_PROJECT_FOLDER}.feature/feature.xml bundles/${TARGET_FOLDER}/$TARGET_PROJECT_FOLDER/${DOMAIN_PREFIX_FOLDERS}/${TARGET_NAME}/${TARGET_CLASSES_PREFIX}*.xtend bundles/${TARGET_FOLDER}/$TARGET_PROJECT_FOLDER/META-INF/MANIFEST.MF;
}
DOMAIN_PREFIX='tools.vitruv.domains.';
DOMAIN_PREFIX_FOLDERS='src/tools/vitruv/domains';

SOURCE_FOLDER=$1;
SOURCE_NAME=$1;
SOURCE_DESCRIPTION=$2;
SOURCE_NAMESPACE=$3;
TARGET_FOLDER=$4;
TARGET_NAME=$4;
TARGET_DESCRIPTION=$5;
TARGET_NAMESPACE=$6;

SOURCE_PROJECT_FOLDER=${DOMAIN_PREFIX}${SOURCE_NAME};
TARGET_PROJECT_FOLDER=${DOMAIN_PREFIX}${TARGET_NAME};

SOURCE_CLASSES_PREFIX=`toFirstUpper ''"$SOURCE_NAME"''`;
TARGET_CLASSES_PREFIX=`toFirstUpper ''"$TARGET_NAME"''`;

cd bundles;
cp -R -v -i $SOURCE_FOLDER $TARGET_FOLDER;
cd $TARGET_FOLDER;
mv -v -i $SOURCE_PROJECT_FOLDER $TARGET_PROJECT_FOLDER;
cd $TARGET_PROJECT_FOLDER/${DOMAIN_PREFIX_FOLDERS};
mv -v -i $SOURCE_NAME $TARGET_NAME;
cd $TARGET_NAME;
mv -v -i ${SOURCE_CLASSES_PREFIX}DomainProvider.xtend ${TARGET_CLASSES_PREFIX}DomainProvider.xtend;
mv -v -i ${SOURCE_CLASSES_PREFIX}Domain.xtend ${TARGET_CLASSES_PREFIX}Domain.xtend;
mv -v -i ${SOURCE_CLASSES_PREFIX}Namespace.xtend ${TARGET_CLASSES_PREFIX}Namespace.xtend;
cd ../../../../../../../../features;
cp -R -v -i ${SOURCE_PROJECT_FOLDER}.feature ${TARGET_PROJECT_FOLDER}.feature;
cd ../;
replace ''"$SOURCE_NAMESPACE"'' ''"$TARGET_NAMESPACE"'';
replace ''"$SOURCE_DESCRIPTION"'' ''"$TARGET_DESCRIPTION"'';
replace ''"$SOURCE_CLASSES_PREFIX"'' ''"$TARGET_CLASSES_PREFIX"'';
replace ''"$SOURCE_NAME"'' ''"$TARGET_NAME"'';
echo done;