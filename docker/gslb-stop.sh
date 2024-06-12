#!/bin/bash

echo "Stopping and removing Site A (DEN) BIND9 server..."
docker stop DEN-bind9 >/dev/null 2>&1
docker rm   DEN-bind9 >/dev/null 2>&1

echo "Stopping and removing Site B (SoCal) BIND9 server..."
docker stop SoCal-bind9 >/dev/null 2>&1
docker rm   SoCal-bind9 >/dev/null 2>&1

# List running Docker containers to verify cleanup
docker ps | grep bind9
