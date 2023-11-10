#!/usr/bin/python3
import os
import sys
import geoip2.database
import datetime
from influxdb import InfluxDBClient

IP = str(sys.argv[1])
Domain = str(sys.argv[2])
time = sys.argv[3]
duration = int(sys.argv[4])

reader = geoip2.database.Reader('/share/geoip_grafana/GeoLite2-City.mmdb')
response = reader.city(IP)

Lat = response.location.latitude
ISO = response.country.iso_code
Long = response.location.longitude
State = response.subdivisions.most_specific.name
City = response.city.name
Country = response.country.name
Zip = response.postal.code
reader.close()

print ("IP:", IP)
print ("Country:", Country)
print ("State:", State)
print ("City:", City)
print ("Zip:", Zip)
print ("Long/Lat:", Long + "/"+ Lat)
print ("ISO:", ISO)

# influx configuration - edit these
ifuser = os.getenv('INFLUX_USER')
ifpass = os.getenv('INFLUX_PW')
ifdb   = os.getenv('INFLUX_DB')
ifhost = os.getenv('INFLUX_HOST')
ifport = os.getenv('INFLUX_PORT')

measurement_name = ("ReverseProxyConnections")
print ('*************************************')

# format the data as a single measurement for influx
body = [
    {
        "measurement": measurement_name,
        "time": time,
        "tags": {
            "key": ISO,
            "latitude": Lat,
            "longitude": Long,
            "Domain": Domain,
            "City": City,
            "State": State,
            "name": Country,
            "IP": IP
            },
        "fields": {
            "Domain": Domain,
            "latitude": Lat,
            "longitude": Long,
            "State": State,
            "City": City,
            "key": ISO,
            "IP": IP,
            "name": Country,
            "duration": duration,
            "metric": 1
        }
    }
]

# connect to influx
ifclient = InfluxDBClient(ifhost,ifport,ifuser,ifpass,ifdb)

# write the measurement
ifclient.write_points(body)

