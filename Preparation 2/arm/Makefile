run:
	arm-linux-gnueabihf-gcc -mfpu=neon $(arg1).s libsysy.a -o $(arg1) -static
	qemu-arm ./$(arg1)
