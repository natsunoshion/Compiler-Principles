run1:
	../没有OP就不配拿奖吗/build/compiler -S $(arg1).sy -o $(arg1).s
	arm-linux-gnueabihf-gcc -mfpu=neon $(arg1).s libsysy.a -o $(arg1) -static
	qemu-arm ./$(arg1)

run2:
	../NKUF4/build/compiler -S $(arg1).sy -o $(arg1).s
	arm-linux-gnueabihf-gcc -mfpu=neon $(arg1).s libsysy.a -o $(arg1) -static
	qemu-arm ./$(arg1)

run:
	arm-linux-gnueabihf-gcc -mfpu=neon $(arg1).s libsysy.a -o $(arg1) -static
	qemu-arm ./$(arg1)
