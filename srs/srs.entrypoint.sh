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
cp /tmp/bin/tsorts /usr/local/bin/tsorts
cp /tmp/bin/null.ts /null.ts
cp /tmp/srs/main.conf.template /tmp/srs/trunk/conf/main.conf.template
cp /tmp/srs/srs.supervisor.conf.template   /etc/supervisor/conf.d/srs.supervisor.conf.template
cp /tmp/srs/api.supervisor.conf   /etc/supervisor/conf.d/api.conf
cp /tmp/srs/*.sh /tmp/srs/trunk/
rm -rf bigmac.tar.gz 

cp /tmp/tsduck/*.template /etc/supervisor/conf.d/
cp /tmp/tsduck/tsorts*.conf /etc/supervisor/conf.d/
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
 -e "s/_http_api_enabled_/${http_api_enabled}/g" \
 -e "s/_http_server_enabled_/${http_server_enabled}/g" \
 -e "s/_hls_enabled_/${hls_enabled}/g" \
 -e "s/_http_remux_enabled_/${http_remux_enabled}/g" \
/tmp/srs/trunk/conf/main.conf.template > /tmp/srs/trunk/conf/main.conf

sed -e "s/_listen_/${listen}/g" -e "s/_max_connections_/${max_connections}/g" -e "s/_gop_cache_/${gop_cache}/g"  \
    -e "s/_queue_length_/${queue_length}/g"   -e "s/_tcp_nodelay_/${tcp_nodelay}/g"   -e "s/_asprocess_/${asprocess}/g" \
    -e "s/_grace_start_wait_/${grace_start_wait}/g"  -e "s/_grace_final_wait_/${grace_final_wait}/g" \
    -e "s/_srtlisten_/${srtlisten}/g"  -e "s/_srtmaxbw_/${srtmaxbw}/g" \
    -e "s/_connect_timeout_/${connect_timeout}/g"  -e "s/_peerlatency_/${peerlatency}/g" \
    -e "s/_recvlatency_/${recvlatency}/g" \
    /etc/supervisor/conf.d/srs.supervisor.conf.template > /etc/supervisor/conf.d/srs.conf

# rtmp2ts and tsduck config modification

mkfifo /live_videofifo.ts
mkfifo /live_videofifo2.ts
mkfifo /live2_videofifo.ts
mkfifo /live2_videofifo2.ts


sed  -e "s/_RW_TIMEOUT_/${RW_TIMEOUT}/g"  -e "s/_BITRATE_/${BITRATE}/g" -e "s/_STREAMING_ADDR_/${STREAMING_ADDR}/g"  -e "s/_RTMP_PORT_/${RTMP_PORT}/g"   -e "s/_MPEGTS_START_PID_/${MPEGTS_START_PID}/g"  -e "s/_STREAMKEY_/${STREAMKEY}/g" -e "s/_SERVICE_NAME_/${SERVICE_NAME}/g" -e "s/_SERVICE_PROVIDER_/${SERVICE_PROVIDER}/g"   /etc/supervisor/conf.d/rtmp2ts.conf.template > /etc/supervisor/conf.d/rtmp2ts.conf

# disable for the moment
sed -e "s/_TSDUCK_BITRATE_/${TSDUCK_BITRATE}/g" -e "s/_TSDUCK_TOS_/${TSDUCK_TOS}/g" -e "s/_TSDUCK_TTL_/${TSDUCK_TTL}/g"  -e "s/_TSDUCK_PACKET_BURST_/${TSDUCK_PACKET_BURST}/g"    -e "s/_TSDUCK_LOCAL_IP_/${TSDUCK_LOCAL_IP}/g" -e "s/_TSDUCK_MULTICAST_ADDR_/${TSDUCK_MULTICAST_ADDR}/g" -e "s/_TSDUCK_MULTICAST_PORT_/${TSDUCK_MULTICAST_PORT}/g"   /etc/supervisor/conf.d/tsduck.conf.template > /etc/supervisor/conf.d/tsduck.conf
sed -e "s/_TSDUCK_BITRATE2_/${TSDUCK_BITRATE2}/g" -e "s/_TSDUCK_TOS2_/${TSDUCK_TOS2}/g"  -e "s/_TSDUCK_TTL2_/${TSDUCK_TTL2}/g" -e "s/_TSDUCK_PACKET_BURST2_/${TSDUCK_PACKET_BURST2}/g"    -e "s/_TSDUCK_LOCAL_IP2_/${TSDUCK_LOCAL_IP2}/g" -e "s/_TSDUCK_MULTICAST_ADDR2_/${TSDUCK_MULTICAST_ADDR2}/g" -e "s/_TSDUCK_MULTICAST_PORT2_/${TSDUCK_MULTICAST_PORT2}/g"   /etc/supervisor/conf.d/tsduck2.conf.template > /etc/supervisor/conf.d/tsduck2.conf


cp /tmp/bin/tc_trafficshaping.sh.template /usr/local/bin/tc_trafficshaping.sh.template

sed -e "s/_NIC_/${NIC}/g" -e "s/_TSDUCK_BITRATE_/${TSDUCK_BITRATE}/g" -e "s/_TSDUCK_MULTICAST_ADDR_/${TSDUCK_MULTICAST_ADDR}/g" -e "s/_TSDUCK_MULTICAST_ADDR2_/${TSDUCK_MULTICAST_ADDR2}/g" /usr/local/bin/tc_trafficshaping.sh.template > /usr/local/bin/tc_trafficshaping.sh
chmod a+x /usr/local/bin/tc_trafficshaping.sh
/usr/local/bin/tc_trafficshaping.sh

exec /usr/bin/supervisord -n
