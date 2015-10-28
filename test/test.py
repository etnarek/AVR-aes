import serial
import codecs

text = "00112233445566778899AABBCCDDEEFF"
text_ascii = codecs.decode(text, "hex")

ser = serial.Serial("/dev/ttyACM0", 9600, timeout=1)
ser.write(text_ascii)
ret = ser.readline().strip().decode("utf-8")
ser = serial.Serial("/dev/ttyACM0", 9600)
ser.write(text_ascii)
ret = ser.readline().strip().decode("utf-8")
assert ret == "69C4E0D86A7B0430D8CDB78070B4C55A"
print("Tout est OK: " + ret)
