SECTIONS {
	.memory : {
		. = 0x000200;
		*(.init);
		*(.text);
		*(*);
		. = ALIGN(4);
		end = .;
	}
}

