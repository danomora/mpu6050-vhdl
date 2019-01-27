//Obtaining pitch and roll angles from mpu6050

#include "stdio.h"
#include "math.h"

short int gx = 0;
short int gy = 0;
short int gz = 0;
short int ax = 0;
short int ay = 0;
short int az = 0;

short int adata[3];
short int gdata[3];


volatile unsigned int * i2c = (unsigned int *) 0x81020; //// memory address , change it to yours

float pitch;
float roll;

#define ACCELEROMETER_SENSITIVITY 32768.0
#define GYROSCOPE_SENSITIVITY 131.0
#define M_PI 3.14159265359
#define dt 0.01							// 10 ms sample rate!


void ComplementaryFilter(short accData[3], short gyrData[3], float *pitch, float *roll)
{
    float pitchAcc, rollAcc;

    // Integrate the gyroscope data -> int(angularSpeed) = angle
    *pitch += ((float)gyrData[0] / GYROSCOPE_SENSITIVITY) * dt; // Angle around the X-axis
    *roll -= ((float)gyrData[1] / GYROSCOPE_SENSITIVITY) * dt;    // Angle around the Y-axis

    // Compensate for drift with accelerometer data if !bullshit
    // Sensitivity = -2 to 2 G at 16Bit -> 2G = 32768 && 0.5G = 8192
    int forceMagnitudeApprox = abs(accData[0]) + abs(accData[1]) + abs(accData[2]);
  if (forceMagnitudeApprox > 8192 && forceMagnitudeApprox < 32768)
   {
	// Turning around the X axis results in a vector on the Y-axis
        pitchAcc = atan2f((float)accData[1], sqrt(pow((float)accData[0], 2) + pow((float)accData[2], 2))) * 180 / M_PI;
        *pitch = *pitch * 0.96 + pitchAcc * 0.04;

	// Turning around the Y axis results in a vector on the X-axis
        rollAcc = atan2f(-(float)accData[0], sqrt(pow((float)accData[1], 2) + pow((float)accData[2], 2))) * 180 / M_PI;
        *roll = *roll * 0.96 + rollAcc * 0.04;
    }
}

int main()
{
	*(i2c)=1;  // enable
	while (1){
		gx = *(i2c+1); // gyro x
		gy = *(i2c+2); // gyro y
		gz = *(i2c+3); // gyro z
		ax = *(i2c+4); // acc x
		ay = *(i2c+5); // acc y
		az = *(i2c+6); // acc z
		gdata[0]=gx;
		gdata[1]=gy;
		gdata[2]=gz;
		adata[0]=ax;
		adata[1]=ay;
		adata[2]=az;
		ComplementaryFilter(adata, gdata, &pitch, &roll);
		printf("Pitch %.2f\n", pitch);
		printf("Roll %.2f\n", roll);
		usleep(9800);
	}

  return 0;
}
