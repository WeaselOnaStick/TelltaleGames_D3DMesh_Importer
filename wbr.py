from io import BufferedReader
import struct

# Weasel's Buffer Reader idk lol
class WBR(BufferedReader):
  """
  Collection of macros for smoothly translating RTB's MaxScript
  
  Most of the time long/short ints are unsigned
  """
  
  def readLong(self, signed = False):
    """Read long int"""
    return struct.unpack('l' if signed else 'L', self.read(4))[0]
  
  def readLongs(self, n : int, signed = False):
    """Read multiple long ints"""
    return struct.unpack(('l' if signed else 'L')*n, self.read(4*n))

  def readLongSigned(self):
    """Shorthand for readLong(signed=True)"""
    return self.readLong(True)
  
  def readShort(self, signed = False):
    """Read short int"""
    return struct.unpack('h' if signed else 'H', self.read(2))[0]

  def readByte(self):
    """Read single byte as int"""
    return int.from_bytes(self.read(1))
  
  def readBytes(self, n : int):
    """Read n bytes as ints"""
    return (int.from_bytes(self.read(1)) for i in range(n))

  def readString(self, n : int):
    return ''.join([x.decode() for x in struct.unpack('c'*n, self.read(n))])
  
  def readFloat(self):
    """Read Float"""
    return struct.unpack('f', self.read(4))[0]
  
  def readFloats(self, n : int):
    """Read multiple long ints"""
    return struct.unpack('f'*n, self.read(4*n))
  
  def seek_rel(self, offset):
    """Seek relative to current position"""
    return super().seek(offset, 1)
  
  def seek_abs(self, offset):
    """Seek relative to 0"""
    return super().seek(offset, 0)
  
  def debugNreads(self, datatype = "L", n=16, offset=0) -> None:
    checkpoint = self.tell()
    self.seek_rel(offset)
    res = []
    match datatype:
      case "L":
        func = self.readLong

    res = [str(func()) for i in range(n)]
    self.seek_abs(checkpoint)
    print("\n".join(res))