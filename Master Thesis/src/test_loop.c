void test_loop(void) {
	test_identify_boards();

	while (1) {
		measure_time();
		comm_handle_msg();
		check_uplink();
		handle_fsm();
		guard_feed();
		led_active();
	}
}
