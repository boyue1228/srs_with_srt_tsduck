# Compiled srt from source
- git clone https://github.com/Haivision/srt.git  

# Build tsduck 

 $ git clone https://github.com/tsduck/tsduck.git
 $ cd tsduck
 $ ./build/install-prerequisites.sh
 $ make NOPCSC=1 NOCURL=1 NODTAPI=1 NOSRT=0 NOTEST=1
 $ install SYSPREFIX=$HOME/tsduckbuilt

