# basic test
assert = require('assert')
# require function
parser = require("../../ble-packet-parser");

# test packet 1
packet1 = ["04",
          "3E", # LE Meta Event: LE Connection Complete
          "20", # Packet Length
          "02", # Subevent Code (for LE Advertising Report event)
          "01", # Num_Reports (Number of Responses in Event) for each:
            "03", # Event-Type 0x00 ADV_IND, 0x01 ADV_DIRECT_IND, 0x02 ADV_SCAN_IND, 0x03 ADV_NONCONN_IND, 0x04 SCAN_RSP
            "01", # Address-Type: 0x00 Public, 0x01 Random
            "9A","8B","7C","6D","5E","4F", # Adress
            "16",
              "02", # flags
                "01","04",
              "0D", # full local name
                "09","48","65","6C","6C","6F","20","57","6F","72","6C","64","21",
              "04", # service data: Service UUID: 0x0A11, data 48
                "16","0A","11","48",
            "BF"] # RSSI 0xBF (signed int)

# test packet 2
packet2 = ["04",
          "3E", # LE Meta Event: LE Connection Complete
          "3F", # Packet Length
          "02", # Subevent Code (for LE Advertising Report event)
          "02", # Num_Reports (Number of Responses in Event) for each:
            "03", # Event-Type 0x00 ADV_IND, 0x01 ADV_DIRECT_IND, 0x02 ADV_SCAN_IND, 0x03 ADV_NONCONN_IND, 0x04 SCAN_RSP
            "01", # Address-Type: 0x00 Public, 0x01 Random
            "9A","8B","7C","6D","5E","4F", # Adress
            "16",
              "02", # flags
                "01","04",
              "0D", # full local name
                "09","48","65","6C","6C","6F","20","57","6F","72","6C","64","21",
              "04", # service data: Service UUID: 0x0A11, data 48
                "16","0A","11","48",
            "BF", # RSSI 0xBF (signed int)
            "03", # Event-Type 0x00 ADV_IND, 0x01 ADV_DIRECT_IND, 0x02 ADV_SCAN_IND, 0x03 ADV_NONCONN_IND, 0x04 SCAN_RSP
            "01", # Address-Type: 0x00 Public, 0x01 Random
            "9A","8B","7C","6D","5E","4F", # Adress
            "10",
              "02", # flags
                "01","04",
              "07", # full local name
                "09","57","6F","72","6C","64","21",
              "04", # service data: Service UUID: 0x0A11, data 48
                "16","0A","11","48",
            "BF"] # RSSI 0xBF (signed int)

# test packets

# parse packet 1
parsedPacket = parser(packet1)
assert.equal(parsedPacket.Event_Code,0x3E,"EventCode equals 0x3E")
assert.equal(parsedPacket.Subevent_Code,0x02,"SubeventCode equals 0x02")
assert.equal(parsedPacket.Reports.length,0x01,"Number of Reports equals 1")
assert.notEqual(parsedPacket.Reports.length,0x02,"Number of Reports equals NOT 2")
assert.equal(parsedPacket.Reports[0].data[1].data,"Hello World!","Report_0: Full Local Name is Hello World!")

# parse packet 2
parsedPacket = parser(packet2)
assert.equal(parsedPacket.Event_Code,0x3E,"EventCode equals 0x3E")
assert.equal(parsedPacket.Subevent_Code,0x02,"SubeventCode equals 0x02")
assert.equal(parsedPacket.Reports.length,0x02,"Number of Reports equals 2")
assert.notEqual(parsedPacket.Reports.length,0x01,"Number of Reports equals NOT 1")
assert.equal(parsedPacket.Reports[0].data[1].data,"Hello World!","Report_0: Full Local Name is Hello World!")
assert.equal(parsedPacket.Reports[1].data[1].data,"World!","Report_1: Full Local Name is World!")
