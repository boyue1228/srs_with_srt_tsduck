#!/bin/sh


#COPY bin/ffmpeg /usr/local/bin/ffmpeg
#COPY bin/ffprobe /usr/local/bin/ffprobe

#COPY srs/main.conf.template /tmp/srs/trunk/conf/main.conf.template
#COPY srs/srs.supervisor.conf.template   /etc/supervisor/conf.d/srs.supervisor.conf.template
#COPY srs/srs.api.conf   /etc/supervisor/conf.d/api.conf
#COPY srs/srs.service.sh  /tmp/srs/trunk/srs.service.sh
#COPY srs/api.service.sh  /tmp/srs/trunk/api.service.sh
#COPY srs/srs.entrypoint.sh /tmp/srs/trunk/srs.entrypoint.sh

# rtmp2ts and tsduck
#COPY tsduck/rtmp2ts.conf.template /etc/supervisor/conf.d/rtmp2ts.conf.template
#COPY tsduck/tsduck.conf.template /etc/supervisor/conf.d/tsduck.conf.template
#COPY tsduck/rtmp2ts.service.sh /tmp/srs/trunk/rtmp2ts.service.sh
#COPY tsduck/tsduck.service.sh /tmp/srs/trunk/tsduck.service.sh

#RUN ["chmod", "+x", "/tmp/srs/trunk/srs.service.sh"]
#RUN ["chmod", "+x", "/tmp/srs/trunk/api.service.sh"]
#RUN ["chmod", "+x", "/tmp/srs/trunk/srs.entrypoint.sh"]

#RUN ["chmod", "+x", "/tmp/srs/trunk/rtmp2ts.service.sh"]
#RUN ["chmod", "+x", "/tmp/srs/trunk/tsduck.service.sh"]

cd /tmp/
tar -xvf bigmac.tar.gz 
cp /tmp/bin/ffmpeg /usr/local/bin/ffmpeg
cp /tmp/bin/ffprobe /usr/local/bin/ffprobe
cp /tmp/srs/main.conf.template /tmp/srs/trunk/conf/main.conf.template
cp /tmp/srs/srs.supervisor.conf.template   /etc/supervisor/conf.d/srs.supervisor.conf.template
cp /tmp/srs/srs.api.conf   /etc/supervisor/conf.d/api.conf
cp /tmp/srs/*.sh /tmp/srs/trunk/
rm -rf bigmac.tar.gz 

cp /tmp/tsduck/*.template /etc/supervisor/conf.d/
cp /tmp/tsduck/*.sh /tmp/srs/trunk/
chmod +x /tmp/srs/trunk/*.sh 
cd /tmp/srs/trunk

# remove all necessary files
rm -rf /usr/local/share/man  /usr/share/doc 

# srs server config modification
sed -e "s/_listen_/${listen}/g" -e "s/_max_connections_/${max_connections}/g" -e "s/_gop_cache_/${gop_cache}/g" \
 -e "s/_queue_length_/${queue_length}/g"   -e "s/_tcp_nodelay_/${tcp_nodelay}/g"   -e "s/_asprocess_/${asprocess}/g"  \
 -e "s/_grace_start_wait_/${grace_start_wait}/g"  -e "s/_grace_final_wait_/${grace_final_wait}/g" \
 -e "s/_srtlisten_/${srtlisten}/g"  -e "s/_srtmaxbw_/${srtmaxbw}/g" \
 -e "s/_connect_timeout_/${connect_timeout}/g"  -e "s/_peerlatency_/${peerlatency}/g" \
 -e "s/_recvlatency_/${recvlatency}/g" \
/tmp/srs/trunk/conf/main.conf.template > /tmp/srs/trunk/conf/main.conf

sed -e "s/_listen_/${listen}/g" -e "s/_max_connections_/${max_connections}/g" -e "s/_gop_cache_/${gop_cache}/g"  \
    -e "s/_queue_length_/${queue_length}/g"   -e "s/_tcp_nodelay_/${tcp_nodelay}/g"   -e "s/_asprocess_/${asprocess}/g" \
    -e "s/_grace_start_wait_/${grace_start_wait}/g"  -e "s/_grace_final_wait_/${grace_final_wait}/g" \
    -e "s/_srtlisten_/${srtlisten}/g"  -e "s/_srtmaxbw_/${srtmaxbw}/g" \
    -e "s/_connect_timeout_/${connect_timeout}/g"  -e "s/_peerlatency_/${peerlatency}/g" \
    -e "s/_recvlatency_/${recvlatency}/g" \
    /etc/supervisor/conf.d/srs.supervisor.conf.template > /etc/supervisor/conf.d/srs.conf

# rtmp2ts and tsduck config modification

mkfifo /videofifo.ts

sed -e "s/_BITRATE_/${BITRATE}/g" -e "s/_STREAMING_ADDR_/${STREAMING_ADDR}/g"  -e "s/_RTMP_PORT_/${RTMP_PORT}/g"   -e "s/_MPEGTS_START_PID_/${MPEGTS_START_PID}/g"  -e "s/_STREAMKEY_/${STREAMKEY}/g" -e "s/_SERVICE_NAME_/${SERVICE_NAME}/g" -e "s/_SERVICE_PROVIDER_/${SERVICE_PROVIDER}/g"   /etc/supervisor/conf.d/rtmp2ts.conf.template > /etc/supervisor/conf.d/rtmp2ts.conf
# disable for the moment
#sed -e "s/_BITRATE_/${BITRATE}/g" -e "s/_MULTICAST_ADDR_/${MULTICAST_ADDR}/g" -e "s/_OUTGOING_ADDR_/${OUTGOING_ADDR}/g" -e "s/_TSUDP_PORT_/${TSUDP_PORT}/g"  -e "s/_TTL_/${TTL}/g"   /etc/supervisor/conf.d/tsduck.conf.template > /etc/supervisor/conf.d/tsduck.conf


exec /usr/bin/supervisord -n