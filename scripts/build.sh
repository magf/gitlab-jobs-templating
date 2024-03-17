#!/bin/bas
# Скрипт, запускающийся из дочерних пайплайнов
echo "I'm BUILD script. I was got this parameters:"
echo
echo BRAND: $BRAND
echo BUNDLE: $BUNDLE
echo MODE: $MODE
echo PRODUCT: $PRODUCT
echo FRONT_TAG: $FRONT_TAG
echo TROUBLESHOOTING_ENABLE: $TROUBLESHOOTING_ENABLE
echo TYPE: $TYPE
echo
echo "I'll generate $PACKAGE_NAME"
