#include <unistd.h>
#include "matrix_hal/everloop.h"
#include "matrix_hal/everloop_image.h"
#include "matrix_hal/gpio_control.h"
#include "matrix_hal/imu_data.h"
#include "matrix_hal/imu_sensor.h"
#include "matrix_hal/matrixio_bus.h"

namespace hal = matrix_hal;
#define INPUT 0
#define OUTPUT 1
#define PIN_0 0
#define PIN_1 1
#define US_INTERVAL 104 // 9600 bps

#define CLK_FRQ 200000000

bool gpioout(hal::MatrixIOBus *bus, uint16_t write_data) {
//bool gpioout(uint16_t write_data) {
  //hal::MatrixIOBus bus;
  //if (!bus.Init()) return false;
  if (bus == NULL) return  false;

  hal::GPIOControl gpio;
  gpio.Setup(bus);
  unsigned char outputPinList[16] = {0, 2, 4, 6, 8, 10, 12, 14, 1, 3, 5, 7, 9, 11, 13, 15};

  gpio.SetMode(outputPinList, sizeof(outputPinList), OUTPUT);

  // start bit
  gpio.SetGPIOValues(outputPinList, sizeof(outputPinList), 0);
  usleep(US_INTERVAL);

  // Send 9bit angle data LSB -> MSB
  unsigned cnt = 0;
  while (cnt < 9) {
    gpio.SetGPIOValues(outputPinList, sizeof(outputPinList), (write_data>>cnt)&0x1);
    usleep(US_INTERVAL);
    cnt ++;
  }

  // stop bit
  gpio.SetGPIOValues(outputPinList, sizeof(outputPinList), 1);

  return true;
}
