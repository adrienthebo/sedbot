#!/bin/bash

TEXT=$1
CHANNEL=$2
KEY=$3

LEN=$(wc -l ${TEXT})

IDX=0

MSGS=50

WAIT=2

while true; do

  NICK=$(shuf -n1 /usr/share/dict/words)
  MAX=$(($IDX + $MSGS))
  sed -n "${IDX},${MAX}p" $TEXT \
  | sed -e "1iUSER $NICK $NICK 0 $NICK" \
        -e "1iNICK $NICK" \
        -e "1iJOIN $CHANNEL $KEY" \
        -ne "/^[[:space:]]*$/d" \
        -ne "s/^/PRIVMSG $CHANNEL :/p" \
        -e "\$iQUIT" \
  | while read line; do sleep $WAIT; echo $line; done \
  | nc irc.freenode.net 6667

  IDX=$MAX

  sleep 5
done

