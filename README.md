SRS build with tsduck, mediainfo, srt
===================

*STATUS*:

------------------
 - V4.5 add iproute2 package so that we have tc qdisc traffic shaping, see srs/srs.env NIC param and /usr/local/bin/tc_trafficshaping.sh script
 - V4 Bring 2x tsduck, 2x tsort and srs into a single docker, using srs native exec module $name to make difference of two stream. Under all-in-one branch
 -  V3 has only one stream
 - This is a fork from https://github.com/zimbatm/ffmpeg-static made by zimbatm etc... 
 - This docker file is built for ubuntu 18.04 bionic 
 - latest modification add supervisor to start srs, api at 8085 and rtmp2ts, tsduck (disabled by default for the moment)

 
Checkout from git and build docker with srs

---------------
    $ docker build -t <s1> .
    $ docker run -it -p 1935:1935 -p 1985:1985 -p 8080:8080 -p 8085:8085 <s1> bash 
    $ docker run -it --env-file srs/srs.env --entrypoint="./srs.entrypoint.sh" -p 1935:1935 -p 1985:1985 -p 8080:8080 -p 8085:8085 -d s1:latest 
    $ docker run -it --env-file srs/srs.env --entrypoint="./srs.entrypoint.sh" -p 1935:1935 -p 1985:1985 -p 8080:8080 -p 8085:8085 -d xxx.dkr.ecr.eu-west-1.amazonaws.com/media_tool:v4
    $
    $# /tmp/srs/trunk/research/api-server# python server.py 8085 & 
    $# cd /tmp/srs/trunk && ./objs/srs -c conf/console.conf 
    $ source stream e.g ffmpeg -re -i myfavouritevideo.mkv -c copy -f flv rtmp://192.168.1.xxx/live/livestream  
    $ open with a web browser on http://192.168.1.xxx:8085/ to see streaming on web 

* build step

```
 1957  docker stop unruffled_johnson
 1958  rm -rf bigmac.tar.gz 
 1959  tar cvfz bigmac.tar.gz bin srs tsduck 
 1960  docker build  -t xxx.dkr.ecr.eu-west-1.amazonaws.com/media_tool:v4  .
 1961  docker run -it --env-file srs/srs.env --entrypoint="./srs.entrypoint.sh" -p 1935:1935 -p 1985:1985 -p 8080:8080 -p 8085:8085 -d xxx.dkr.ecr.eu-west-1.amazonaws.com/media_tool:v4
```


### TODO
 * srt is not able to be compiled with ffmpeg in static mode --enable-libsrt not working 

Related projects
----------------
* FFmpeg Static Builds - http://johnvansickle.com/ffmpeg/

License
-------
This project is licensed under the ISC. See the [LICENSE](LICENSE) file for
the legalities.

204971755566.dkr.ecr.eu-west-1.amazonaws.com/media_tool:v3
