/* Includes_BEGIN */
#include <math.h>
#include <stdlib.h>
#include <Windows.h>
/* Includes_END */

/* Externs_BEGIN */
double coxa_length = 0.052907539;
double femur_length = 0.06185;//x=0.06/ z=-0.015
double tibia_length = 0.13086;//x=0.095/ z=-0.09

double pi = 3.1415926535;
/* Externs_END */

void InverseKinematics_Start_wrapper(void)
{
/* Start_BEGIN */
/*
 * Custom Start code goes here.
 */
/* Start_END */
}

void InverseKinematics_Outputs_wrapper(const real_T *angle_offsets,
                                       const real_T *coordinates,
                                       real_T *alpha,
                                       real_T *beta,
                                       real_T *gamma,
                                       real_T *debug)
{
/* Output_BEGIN */
double x = coordinates[0];
    double y = fabs(coordinates[1]);
    double z = fabs(coordinates[2]);

    double total_length = sqrt(x*x + y*y);

    alpha[0] = atan(x, y) - angle_offsets[0]*(pi/180);
    
    double length_without_coxa = total_length - coxa_length;
    double BF = sqrt(length_without_coxa*length_without_coxa + z*z);

    double beta1 = atan2(length_without_coxa, z);
    double beta2 = acos((femur_length*femur_length + BF*BF - tibia_length*tibia_length) / (2 * femur_length * BF));

    beta[0] = 90*(pi/180) - (beta1 + beta2) - angle_offsets[1]*(pi/180);
    
    double gamma1 = acos((tibia_length*tibia_length + femur_length*femur_length - BF*BF) / (2 * tibia_length * femur_length));
    
    gamma[0] = 90*(pi/180) - gamma1 + angle_offsets[2]*(pi/180);
/* Output_END */
}

void InverseKinematics_Terminate_wrapper(void)
{
/* Terminate_BEGIN */
/*
 * Custom Terminate code goes here.
 */
/* Terminate_END */
}