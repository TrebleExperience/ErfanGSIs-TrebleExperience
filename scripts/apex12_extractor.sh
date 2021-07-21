#!/bin/bash

LOCALDIR=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`
EXT4EXTRACT=$LOCALDIR/../tools/ext4extract/ext4extract.py

TMPDIR=$LOCALDIR/../tmp/apex_ext
mkdir -p "$TMPDIR"

APEXDIR="$1"
APEXES=$(ls "$APEXDIR" | grep ".apex" | grep -v ".capex" )
for APEX in $APEXES; do
    APEXNAME=$(echo "$APEX" | sed 's/.apex//')
    if [[ -d "$APEXDIR/$APEXNAME" ]]; then
        continue
    fi
    mkdir -p "$APEXDIR/$APEXNAME"
    7z e "$APEXDIR/$APEX" apex_payload.img apex_pubkey -o"$APEXDIR/$APEXNAME" 2>/dev/null >> "$TMPDIR"/zip.log
    $EXT4EXTRACT "$APEXDIR/$APEXNAME/apex_payload.img" -D "$APEXDIR/$APEXNAME" 2>/dev/null
    rm "$APEXDIR/$APEXNAME/apex_payload.img"
    rm -rf "$APEXDIR/$APEXNAME/lost+found"
done

CAPEXES=$(ls "$APEXDIR" | grep ".capex" )
for CAPEX in $CAPEXES; do
   if [[ -z $CAPEX ]] ; then
       continue
   fi
   CAPEXNAME=$(echo "$CAPEX" | sed 's/.capex//')
   7z e -y "$APEXDIR/$CAPEX" original_apex -o"$APEXDIR" >> "$TMPDIR"/zip.log
   rm -rf "$APEXDIR/$CAPEX"
   mv -f "$APEXDIR/original_apex" "$APEXDIR/$CAPEXNAME.apex"
   mkdir -p "$APEXDIR/$CAPEXNAME"
   7z e -y "$APEXDIR/$CAPEXNAME.apex" apex_payload.img apex_pubkey -o"$APEXDIR/$CAPEXNAME" 2>/dev/null >> "$TMPDIR"/zip.log
   $EXT4EXTRACT "$APEXDIR/$CAPEXNAME/apex_payload.img" -D "$APEXDIR/$CAPEXNAME" 2>/dev/null
   rm -rf "$APEXDIR/$CAPEXNAME/apex_payload.img"
   rm -rf "$APEXDIR/$CAPEXNAME/lost+found"
done

rm -rf "$TMPDIR"