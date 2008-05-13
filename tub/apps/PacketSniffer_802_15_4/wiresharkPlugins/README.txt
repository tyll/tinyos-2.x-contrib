The plugins in this subdirectory are composed against wireshark 1.0.0 

QUICK INSTALL INFO
------------------
1. Prepare the sources:

tar xzvf wireshark-1.0.0.tar.gz
cd wireshark-1.0.0
cp -ra ~/tos/tinyos-2.x-contrib/tub/apps/PacketSniffer_802_15_4/wiresharkPlugins/802_15_4/ plugins/
cp -ra ~/tos/tinyos-2.x-contrib/tub/apps/PacketSniffer_802_15_4/wiresharkPlugins/cc2420/ plugins/
cp -ra ~/tos/tinyos-2.x-contrib/tub/apps/PacketSniffer_802_15_4/wiresharkPlugins/t2sf/ plugins/
cp -ra ~/tos/tinyos-2.x-contrib/tub/apps/PacketSniffer_802_15_4/wiresharkPlugins/t2am/ plugins/
find ~/tos/tinyos-2.x-contrib/tub/apps/PacketSniffer_802_15_4/wiresharkPlugins/patches -maxdepth 1 -name "*.patch" | xargs -i patch -p1 -i{}

2. Build the sources:

./configure --prefix=/opt/wireshark
make
sudo make install

3. To use the patched wireshark start it in the same folder as the java
control application using:

sudo /opt/wireshark/bin/wireshark &

4. Make sure TCP Checksum Verification is disabled, if your system is
using TCP Cheksum offloading:

http://wiki.wireshark.org/TCP_Checksum_Verification

5. Additional info:

See /doc/README.plugins in your wireshark directory for more info!
See filter.info to know what can be filtered with wireshark display filters!

