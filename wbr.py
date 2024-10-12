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

  def readLongSigned(self):
    """Shorthand for readLong(signed=True)"""
    return self.readLong(True)

  def readByte(self, signed = False):
    """Read short int"""
    return struct.unpack('h' if signed else 'H', self.read(2))[0]

  def readString(self, n : int):
    return ''.join([x.decode() for x in struct.unpack('c'*n, self.read(n))])
  
  def readFloat(self):
    """Read Float"""
    return struct.unpack('f', self.read(4))[0]
  
  def seek_rel(self, offset):
    """Seek relative to current position"""
    return super().seek(offset, 1)
  
  def seek_abs(self, offset):
    """Seek relative to 0"""
    return super().seek(offset, 0)