#!/usr/bin/env bash
#$PROJECT_DIR/$PROJECT_NAME/Helpers/ConfusionCode/confuse.sh
TABLENAME=confusion_symbols
SYMBOL_DB_FILE="confusion_symbols"
STRING_SYMBOL_FILE="$PROJECT_DIR/$PROJECT_NAME/Helpers/ConfusionCode/ConfusionFuncs.list"
HEAD_FILE="$PROJECT_DIR/$PROJECT_NAME/Helpers/ConfusionCode/ConfusionDefines.h"
notesGrammer="#pragma"

export LC_CTYPE=C

#维护数据库方便日后作排重
createTable()
{
echo "create table $TABLENAME(src text, des text);" | sqlite3 $SYMBOL_DB_FILE
}

insertValue()
{
echo "insert into $TABLENAME values('$1' ,'$2');" | sqlite3 $SYMBOL_DB_FILE
}

query()
{
echo "select * from $TABLENAME where src='$1';" | sqlite3 $SYMBOL_DB_FILE
}

ramdomString()
{
openssl rand -base64 64 | tr -cd 'a-zA-Z' |head -c 16
}

rm -f $SYMBOL_DB_FILE
rm -f $HEAD_FILE
createTable

touch $HEAD_FILE
echo '#ifndef Demo_codeObfuscation_h
#define Demo_codeObfuscation_h' >> $HEAD_FILE
echo "//confuse string at `date`" >> $HEAD_FILE
cat "$STRING_SYMBOL_FILE" | while read -ra line; do
if [[ ! -z "$line" ]]; then
string=${line:0:7}

if [ "$string"x != "#pragma"x ]; then
ramdom=`ramdomString`
echo $line $ramdom
insertValue $line $ramdom
echo "#define $line $ramdom" >> $HEAD_FILE
else
echo "$line" >> $HEAD_FILE
fi
fi
done
echo "#endif" >> $HEAD_FILE


sqlite3 $SYMBOL_DB_FILE .dump
