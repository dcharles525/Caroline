#!/bin/sh
valac --pkg gtk+-3.0 --pkg gee-0.8 --library=Caroline -H Caroline.h ../src/Caroline.vala -X -fPIC -X -shared -o Caroline.so
valac --pkg gtk+-3.0 --pkg gee-0.8 Caroline.vapi ../src/Sample.vala -X Caroline.so -X -I. -o demo
sudo cp Caroline.so /usr/lib/
./demo
