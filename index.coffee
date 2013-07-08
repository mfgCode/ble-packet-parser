# BLE-Packet-Parser

# parseBlePacket( packet Array(), isIntegers Boolean )
# packet :      an array with the ble packet
# isIntegers :  true if array is already of integers,
#               false parses hex strings to intergers

parseBlePacket = (packet,isIntegers) ->
  # format array
  packet = integerfy(packet) if !isIntegers
  # read header data
  packetEvent = packet[1]
  packetSubevent = packet[3]
  packetLength = packet[2]
  # Event && Subevent Code: LE Advertising Report
  if packetEvent == 0x3E && packetSubevent == 0x02
    # Num_Reports (how many reports are in the packet)
    num_reports = packet[4]
    # create report array
    packetReports = new Array(num_reports)
    # loop through array and populate it
    offset = 5
    for r,id in packetReports
      packetReports[id] =
        eventType : packet[offset]
        addressType : packet[offset+1]
        address : toHex(packet.slice(offset+2,offset+2+6).reverse()).join(":").toUpperCase()
        data : parseData(packet.slice(offset+9,offset+9+packet[offset+8]))
        rssi : toSigned(packet[offset+9+packet[offset+8]])
      offset += 10 + packet[offset+8]

  # return parsed packet
  return {
    Event_Code : packet[1]
    Subevent_Code : packet[3]
    Packet_Length : packetLength
    Reports : packetReports
  }

# Helpers
# parse data part of the packet
parseData = (data) ->
  # data parser returns json
  result = []
  i=0
  while i < data.length
    length = data[i]
    type = data[i+1]
    payload = data.slice(i+2,i+1+length)
    name = "unknown"

    # treat known data fields
    switch type
      when 0x01
        # flags
        name = "Flags"
        payload = payload[0]
      when 0x08
        # full local name
        name = "Shortened Local Name"
        payload = toChar(payload)
      when 0x09
        # short or full local name
        name = "Full Local Name"
        payload = toChar(payload)
      when 0x16
        # Service Data
        name = "Service Data"
        payload =
          uuid : parseInt(toHex((payload.slice 0,2)).join(""),16)
          data : payload.slice(2,payload.length).reverse()
    # add field to result
    result.push
      fieldType : type
      fieldName : name
      data : payload

    i += length+1
  return result

# convert array of integer to array of proper hex string
toHex = (data) ->
  # data parser returns json
  for a,id in data
    data[id] = a.toString(16)
    data[id] = "0"+data[id] if a < 16
    data[id] = "0"+data[id] if a == 0
  return data

# convert array of integers to string of chars
toChar = (data) ->
  str = ""
  for h in data
    str += String.fromCharCode(h)
  return str

# 8 bit signed integer conversion
toSigned = (int) ->
  int = -(0x100 - int) if (int & 0x80)
  return int

# make array of strings an array of integers
integerfy = (array) ->
  for str,id in array
    array[id] = parseInt(str,16)
  return array

# export the parser
module.exports = parseBlePacket