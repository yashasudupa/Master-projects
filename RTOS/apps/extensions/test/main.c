
#include <kernel/kernel.h>
#include <libs/printfx.h>


Time_t now;

OS_DECLARE_TASK(Task1, 200, 120);
OS_DECLARE_TASK(Task2, 210, 160);
OS_DECLARE_TASK(Task3, 220, 140);
OS_DECLARE_TASK(Task4, 230, 120);

OS_TASKENTRY(Task1) {
	while (1) {
		printfx("\v\nI'm task 1\n");
	}
}

OS_TASKENTRY(Task2) {
	while (1) {
		printfx("\v\nI'm task 2\n");
	}
}

OS_TASKENTRY(Task3) {
	while (1) {
		printfx("\v\nI'm task 3\n");
	}
}

OS_TASKENTRY(Task4) {
	while (1) {
		printfx("\v\nI'm task 4\n");
	}
}


