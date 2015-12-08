import serial
import codecs
from time import sleep

ser = serial.Serial("/dev/ttyACM0", 9600)
print(ser.read().decode("utf-8"))

text = "00112233445566778899AABBCCDDEEFF\n"
text = text[:32]
text_ascii = codecs.decode(text, "hex")

ser.write(text_ascii)
ret = codecs.encode(ser.read(16), "hex").decode("utf-8").upper()
assert ret == "69C4E0D86A7B0430D8CDB78070B4C55A", "%s is not equal with 69C4E0D86A7B0430D8CDB78070B4C55A" % ret
print("Tout est OK: " + ret)
