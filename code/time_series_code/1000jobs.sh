#!/bin/bash

ls ./data | sed 's/.parquet//g' >1000jobs.txt
