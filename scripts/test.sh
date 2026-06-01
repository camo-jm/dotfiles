#! /usr/bin/env sh

time (for x in $(seq $1); do
$2
done )
