#!/bin/bash

rm -rf public
hugo
rsync -avzP public vic@108.61.184.197:~
