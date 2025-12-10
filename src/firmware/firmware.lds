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
	.stack : {
        . = ALIGN(16);
        _stack_start = .;
        . += 4096;        /* 4KB stack */
        _stack_end = .;
    }
}

