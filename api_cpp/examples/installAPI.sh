#!/bin/bash

#Download kortex pi file if not already present in the build folder
if [ ! -e kortex_api-1.1.3.zip ]; then
    CONFIRM=$(wget --quiet --save-cookies ./cookies.txt --keep-session-cookies --no-check-certificate "https://drive.google.com/a/kinova.ca/uc?id=19zfCNlRUfNBbZoMW9LOpLjVrYOO2BwYb&export=download" -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')
    wget --load-cookies ./cookies.txt "https://drive.google.com/a/kinova.ca/uc?authuser=0&id=19zfCNlRUfNBbZoMW9LOpLjVrYOO2BwYb&export=download&confirm=$CONFIRM" -O kortex_api-1.1.3.zip
    RESULT=$?
    if [ "${RESULT}" -ne 0 ]; then
        echo "ERROR while fetching the kortex api. code = ${RESULT}"
        exit $?
    fi
fi

#Clear googoe drive cookie
rm ./cookies.txt

#Unzip kortex file here
unzip -o kortex_api-1.1.3.zip


RESULT=$?
if [ "${RESULT}" -ne 0 ]; then
    echo "ERROR while extracting the kortex api. code = ${RESULT}"
    exit $?
fi

#Create or cleanup api folder
if [ -d ../kortex_api ]; then
    rm ../kortex_api/* -R
else
   mkdir ../kortex_api
fi

#Copy include folder
cp -R kortex_api/cpp/linux_x86/include ../kortex_api/
RESULT=$?
if [ "${RESULT}" -ne 0 ]; then
    echo "ERROR while copying the kortex api header files. code = ${RESULT}"
    rm kortex_api -R
    exit $?
fi

#Copy lib folder
cp -R kortex_api/cpp/linux_x86/lib/ ../kortex_api/
RESULT=$?
if [ "${RESULT}" -ne 0 ]; then
    echo "ERROR while copying the kortex api library. code = ${RESULT}"
    rm kortex_api -R
    exit $?
fi

#Remove unzipped folder
rm kortex_api -R

exit ${RESULT}
