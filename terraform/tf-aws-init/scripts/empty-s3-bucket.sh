#!/bin/bash

bucket=$1
profile=$2
region=$3

set -e

echo "Removing all versions from $bucket"

versions=`aws --region $region --profile $profile s3api list-object-versions --bucket $bucket |jq '.Versions'`
markers=`aws --region $region --profile $profile s3api list-object-versions --bucket $bucket |jq '.DeleteMarkers'`
let count=`echo $versions |jq 'length'`-1

if [ $count -gt -1 ]; then
        echo "removing files"
        for i in $(seq 0 $count); do
                key=`echo $versions | jq .[$i].Key |sed -e 's/\"//g'`
                versionId=`echo $versions | jq .[$i].VersionId |sed -e 's/\"//g'`
                echo "aws --region $region --profile $profile s3api delete-object --bucket $bucket --key $key --version-id $versionId &"
                aws --region $region --profile $profile s3api delete-object --bucket $bucket --key $key --version-id $versionId &
        done
fi

let count=`echo $markers |jq 'length'`-1

if [ $count -gt -1 ]; then
        echo "removing delete markers"

        for i in $(seq 0 $count); do
                key=`echo $markers | jq .[$i].Key |sed -e 's/\"//g'`
                versionId=`echo $markers | jq .[$i].VersionId |sed -e 's/\"//g'`
                echo "aws --region $region --profile $profile s3api delete-object --bucket $bucket --key $key --version-id $versionId &"
                aws --region $region --profile $profile s3api delete-object --bucket $bucket --key $key --version-id $versionId &
        done
fi