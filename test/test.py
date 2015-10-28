import serial
import codecs

ser = serial.Serial("/dev/ttyACM0", 9600)
text = "00112233445566778899AABBCCDDEEFF"
text_ascii = codecs.decode(text, "hex")
print(text_ascii)
ser.write(text_ascii)
print("send")
ret = ser.readline().strip().decode("utf-8")
print("read")
assert ret == "69C4E0D86A7B0430D8CDB78070B4C55A"
print("Tout est OK: " + ret)
