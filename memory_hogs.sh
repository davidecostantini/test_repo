#!/bin/sh
ps -xao cmd,pid | awk 'NR>1' | sort -n -k 1 | tail -n 10
