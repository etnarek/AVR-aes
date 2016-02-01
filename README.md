# AES pour atmega328p

Ce projet est une implémentation d'AES en AVR pour atmega328p

## Utilisation:
Pour uplauder le projet sur l'arduino:

    make push

et pour le tester:

    make test

(a condition d'avoir installer pyserial)

test/communique.py sert a communiquer avec l'arduino le plain et récupérer le cypher.
