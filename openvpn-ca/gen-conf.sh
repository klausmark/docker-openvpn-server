#!/bin/sh
if [ $# -eq 0 ]
then
    echo "Remember parameter <client>"
    exit 1
fi

CLIENT=$1
FILEEXT=".conf"
CERTEXT=".crt"
FILE=$CLIENT$FILEEXT

cp client.conf $FILE
echo "<ca>" >> $FILE
cat pki/ca.crt >> $FILE
echo "</ca>" >> $FILE
echo "<cert>" >> $FILE
cat pki/issued/$CLIENT.crt >> $FILE
echo "</cert>" >> $FILE
echo "<key>" >> $FILE
cat pki/private/$CLIENT.key >> $FILE
echo "</key>" >> $FILE
echo "<tls-auth>" >> $FILE
cat ta.key >> $FILE
echo "</tls-auth>" >> $FILE
