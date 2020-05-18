#!/bin/bash

/usr/bin/tsp -I file /videofifo.ts -P regulate --packet-burst 128 -P pcrbitrate --min-pcr 256 -O ip ${IP}:${PORT}
