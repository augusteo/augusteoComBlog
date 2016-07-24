#!/bin/bash

rm -rf public
hugo
rsync -azP public vic@108.61.184.197:~
