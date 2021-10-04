#!/bin/bash

# Core variables, don't touch.
LOCALDIR=$(cd "$(dirname ${BASH_SOURCE[0]})" && pwd)
DEAPEXER="$LOCALDIR/../tools/apex/deapexer.py"
TMPDIR="$LOCALDIR/../tmp/apex_ext"
APEXDIR="$1"

# Start process
APEXES=$(ls "$APEXDIR" | grep "\.apex$")
for APEX in $APEXES; do
    APEXNAME=$(echo "$APEX" | sed 's/\.apex//')
    if [[ -d "$APEXDIR/$APEXNAME" || -d "$APEXDIR/$APEX" ]]; then
        continue
    fi
    mkdir -p "$APEXDIR/$APEXNAME"
    7z e -y "$APEXDIR/$APEX" apex_pubkey -o"$APEXDIR/$APEXNAME" >> $TMPDIR/apex_extract.log
    $DEAPEXER extract "$APEXDIR/$APEX" "$APEXDIR/$APEXNAME"
    rm -rf "$APEXDIR/$APEXNAME/lost+found"
done

# For Android 12
CAPEXES=$(ls "$APEXDIR" | grep "\.capex$")
for CAPEX in $CAPEXES; do
    if [[ -z $CAPEX ]]; then
        continue
    fi
    CAPEXNAME=$(echo "$CAPEX" | sed 's/\.capex//')
    7z e -y "$APEXDIR/$CAPEX" original_apex -o"$APEXDIR" >> $TMPDIR/apex_extract.log
    mv -f "$APEXDIR/original_apex" "$APEXDIR/$CAPEXNAME.apex"
    mkdir -p "$APEXDIR/$CAPEXNAME"
    7z e -y "$APEXDIR/$CAPEXNAME.apex" apex_pubkey -o"$APEXDIR/$CAPEXNAME" >> $TMPDIR/apex_extract.log
    $DEAPEXER "$APEXDIR/$CAPEXNAME.apex" "$APEXDIR/$CAPEXNAME"
    rm -rf "$APEXDIR/$CAPEXNAME/lost+found"
    rm -rf "$APEXDIR/$CAPEX"
done
