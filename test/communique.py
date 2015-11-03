import serial
import codecs

ser = serial.Serial("/dev/ttyACM0", 9600)
ser.read()
while 1:
    text = input(">> ")
    text = text[:32]
    text_ascii = codecs.decode(text, "hex")
    ser.write(text_ascii)
    print(ser.readline().strip().decode("utf-8"))

