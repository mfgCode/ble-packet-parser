// Generated by CoffeeScript 1.4.0
var integerfy, parseBlePacket, parseData, toChar, toHex, toSigned;

parseBlePacket = function(packet, isIntegers) {
  var id, num_reports, offset, packetEvent, packetLength, packetReports, packetSubevent, r, _i, _len;
  if (!isIntegers) {
    packet = integerfy(packet);
  }
  packetEvent = packet[1];
  packetSubevent = packet[3];
  packetLength = packet[2];
  if (packetEvent === 0x3E && packetSubevent === 0x02) {
    num_reports = packet[4];
    packetReports = new Array(num_reports);
    offset = 5;
    for (id = _i = 0, _len = packetReports.length; _i < _len; id = ++_i) {
      r = packetReports[id];
      packetReports[id] = {
        eventType: packet[offset],
        addressType: packet[offset + 1],
        address: toHex(packet.slice(offset + 2, offset + 2 + 6).reverse()).join(":").toUpperCase(),
        data: parseData(packet.slice(offset + 9, offset + 9 + packet[offset + 8])),
        rssi: toSigned(packet[offset + 9 + packet[offset + 8]])
      };
      offset += 10 + packet[offset + 8];
    }
  }
  return {
    Event_Code: packet[1],
    Subevent_Code: packet[3],
    Packet_Length: packetLength,
    Reports: packetReports
  };
};

parseData = function(data) {
  var i, length, name, payload, result, type;
  result = [];
  i = 0;
  while (i < data.length) {
    length = data[i];
    type = data[i + 1];
    payload = data.slice(i + 2, i + 1 + length);
    name = "unknown";
    switch (type) {
      case 0x01:
        name = "Flags";
        payload = payload[0];
        break;
      case 0x08:
        name = "Shortened Local Name";
        payload = toChar(payload);
        break;
      case 0x09:
        name = "Full Local Name";
        payload = toChar(payload);
        break;
      case 0x16:
        name = "Service Data";
        payload = {
          uuid: parseInt(toHex(payload.slice(0, 2)).join(""), 16),
          data: payload.slice(2, payload.length).reverse()
        };
    }
    result.push({
      fieldType: type,
      fieldName: name,
      data: payload
    });
    i += length + 1;
  }
  return result;
};

toHex = function(data) {
  var a, id, _i, _len;
  for (id = _i = 0, _len = data.length; _i < _len; id = ++_i) {
    a = data[id];
    data[id] = a.toString(16);
    if (a < 16) {
      data[id] = "0" + data[id];
    }
    if (a === 0) {
      data[id] = "0" + data[id];
    }
  }
  return data;
};

toChar = function(data) {
  var h, str, _i, _len;
  str = "";
  for (_i = 0, _len = data.length; _i < _len; _i++) {
    h = data[_i];
    str += String.fromCharCode(h);
  }
  return str;
};

toSigned = function(int) {
  if (int & 0x80) {
    int = -(0x100 - int);
  }
  return int;
};

integerfy = function(array) {
  var id, str, _i, _len;
  for (id = _i = 0, _len = array.length; _i < _len; id = ++_i) {
    str = array[id];
    array[id] = parseInt(str, 16);
  }
  return array;
};

module.exports = parseBlePacket;
