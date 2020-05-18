SRS build with tsduck, mediainfo, srt
===================

*STATUS*: 
------------------
 - This is a fork from https://github.com/zimbatm/ffmpeg-static made by zimbatm etc... 
 - This docker file is built for ubuntu 18.04 bionic 
 - latest modification add supervisor to start srs, api at 8085 and rtmp2ts, tsduck (disabled by default for the moment)
 
Checkout from git and build docker with srs
---------------
    $ docker build -t <s1> .
    $ docker run -it -p 1935:1935 -p 1985:1985 -p 8080:8080 -p 8085:8085 <s1> bash 
    $ docker run -it --env-file srs/srs.env --entrypoint="./srs.entrypoint.sh" -p 1935:1935 -p 1985:1985 -p 8080:8080 -p 8085:8085 -d s1:latest 
    $ 
    $
    $# /tmp/srs/trunk/research/api-server# python server.py 8085 & 
    $# cd /tmp/srs/trunk && ./objs/srs -c conf/console.conf 
    $ source stream e.g ffmpeg -re -i myfavouritevideo.mkv -c copy -f flv rtmp://192.168.1.xxx/live/livestream  
    $ open with a web browser on http://192.168.1.xxx:8085/ to see streaming on web 

### TODO
 * srt is not able to be compiled with ffmpeg in static mode --enable-libsrt not working 

Related projects
----------------
* FFmpeg Static Builds - http://johnvansickle.com/ffmpeg/

License
-------
This project is licensed under the ISC. See the [LICENSE](LICENSE) file for
the legalities.

