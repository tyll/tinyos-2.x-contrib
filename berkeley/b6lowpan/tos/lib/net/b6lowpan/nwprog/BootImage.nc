
interface BootImage {
  command void reboot();
  command error_t boot(uint8_t img_num);
}
