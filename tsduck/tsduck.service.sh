#!/bin/bash

/usr/bin/tsp -v -I file /videofifo.ts -P pcrbitrate --min-pcr ${TSDUCK_MIN_PCR} -P regulate -O ip --enforce-burst --packet-burst ${TSDUCK_PACKET_BURST} --local-address ${TSDUCK_LOCAL_IP} --rtp ${TSDUCK_MULTICAST_ADDR}:${TSDUCK_MULTICAST_PORT}
