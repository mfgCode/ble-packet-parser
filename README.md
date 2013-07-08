# BLE-Packet-Parser
This packet parser can be used as a callback for the node-module `ble-scanner` and process Bluetooth LE advertising packets.
The output is JSON.

## Usage
The packet parser receives the packet as an array of hex strings or integers and produces a json output.

    #require module
    bleParser = require("ble-packet-parser");

    # define input
    packet = ["04","3E",...]
    # parse packet
    json = bleParser(packet)

    # or if the input is as array of integers
    packetInt = [4,62,...]
    json = bleParser(packet,true)

The packet will be parsed into a JSON, e.g.:

    {
     "Event_Code": 62,
     "Subevent_Code": 2,
     "Packet_Length": 32,
     "Reports": [
       {
         "eventType": 3,
         "addressType": 1,
         "address": "4F:5E:6D:7C:8B:9A",
         "data": [
           {
           "fieldType": 1,
           "fieldName": "Flags",
           "data": 4
           },
           {
            "fieldType": 9,
            "fieldName": "Full Local Name",
            "data": "Hello World!"
           },
           {
            "fieldType": 22,
            "fieldName": "Service Data",
            "data": {
              "uuid": 2577,
              "data": [ 72 ] }
           }
         ],
         "rssi": -65
       }
     ]
    }

## Notes

1. Little Endian Byte order is reversed for Service Data fields.
2. Length fields are omitted from the JSON object
3. Num_Reports is omitted from the JSON, can be retrieved by packet.Reports.length

## Known issues
1. Multi-Report packets have not been tested, due to lack of encountering them. Please report if parsing doesn't work.
