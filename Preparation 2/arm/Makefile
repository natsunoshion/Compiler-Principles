run:
	arm-linux-gnueabihf-gcc -mfpu=vfp $(arg1).s libsysy.a -o $(arg1) -static
	qemu-arm ./$(arg1)
