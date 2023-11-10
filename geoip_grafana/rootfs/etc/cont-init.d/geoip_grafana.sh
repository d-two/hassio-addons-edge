#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: GeoIP-Grafana
# This file applies patches so the add-on becomes compatible
# ==============================================================================

# Init
echo "Initializing folders..."
mkdir -p /share/geoip_grafana
now=$(date '+%Y-%m-%d')

if [ ! -f "/share/geoip_grafana/${now}_GeoLite2-City.mmdb" ]
then
	rm -rf /share/geoip_grafana/*GeoLite2-City.mmdb
	wget https://git.io/GeoLite2-City.mmdb -O /share/geoip_grafana/${now}_GeoLite2-City.mmdb
	ln -s /share/geoip_grafana/${now}_GeoLite2-City.mmdb /share/geoip_grafana/GeoLite2-City.mmdb
fi
