import serial
import codecs

ser = serial.Serial("/dev/ttyACM0", 9600)
print(ser.read().decode("utf-8"))

while 1:
    text = input(">> ")
    text = text[:32]
    text_ascii = codecs.decode(text, "hex")
    ser.write(text_ascii)
    print(codecs.encode(ser.read(16), "hex").decode("utf-8").upper())

