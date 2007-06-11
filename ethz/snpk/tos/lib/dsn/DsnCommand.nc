interface DsnCommand<valueType> {
	event void detected(valueType * values, uint8_t n);
}
