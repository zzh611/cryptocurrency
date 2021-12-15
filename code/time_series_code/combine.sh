#!/bin/bash

ls *.csv | sed 's/_.*//g' > choices.txt

cat *.csv > combine.txt
