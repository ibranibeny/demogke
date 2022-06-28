#!/bin/bash

CONTAINER_ALREADY_STARTED="CONTAINER_ALREADY_STARTED_PLACEHOLDER"
if [ ! -e $CONTAINER_ALREADY_STARTED ]; then
    touch $CONTAINER_ALREADY_STARTED
    echo "-- First container startup --"
    /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisor.conf 
else
    echo "-- Not first container startup --"
fi