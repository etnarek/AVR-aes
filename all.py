import serial
import codecs

text = "00112233445566778899AABBCCDDEEFF"
text_ascii = codecs.decode(text, "hex")

ser = serial.Serial("/dev/ttyACM0", 9600)
print(ser.readline().strip())
ser.write(text_ascii)
while 1:
    print(ser.readline().strip())
