SECTIONS {
	.text	: {
		. = 0x200;
		*(.init);
		*(.text);
	}
	.memory : {
		. = 0x000000;
		*(*);
		. = ALIGN(4);
		end = .;
	}
}

