
/*
 * Include Files
 *
 */
#if defined(MATLAB_MEX_FILE)
#include "tmwtypes.h"
#include "simstruc_types.h"
#else
#define SIMPLIFIED_RTWTYPES_COMPATIBILITY
#include "rtwtypes.h"
#undef SIMPLIFIED_RTWTYPES_COMPATIBILITY
#endif



/* %%%-SFUNWIZ_wrapper_includes_Changes_BEGIN --- EDIT HERE TO _END */
#include <math.h>
/* %%%-SFUNWIZ_wrapper_includes_Changes_END --- EDIT HERE TO _BEGIN */
#define u_width 1
#define u_1_width 1
#define u_2_width 1
#define u_3_width 1
#define u_4_width 1
#define u_5_width 1
#define y_width 1

/*
 * Create external references here.  
 *
 */
/* %%%-SFUNWIZ_wrapper_externs_Changes_BEGIN --- EDIT HERE TO _END */
/* extern double func(double a); */
/* %%%-SFUNWIZ_wrapper_externs_Changes_END --- EDIT HERE TO _BEGIN */

/*
 * Output function
 *
 */
void TrackReward_Outputs_wrapper(const real_T *r,
			const real_T *pitch_diff,
			const real_T *yaw_diff,
			const real_T *enemy_pitch_diff,
			const real_T *enemy_yaw_diff,
			const real_T *enemy_hp,
			real_T *reward,
			const real_T *xD)
{
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_BEGIN --- EDIT HERE TO _END */
/* 此示例将输出设置为等于输入
 y0[0] = u0[0]; 
 对于复信号，使用: y0[0].re = u0[0].re; 
 y0[0].im = u0[0].im;
 y1[0].re = u1[0].re;
 y1[0].im = u1[0].im;
 */

reward[0] = -0.2;
 
 // full reward
//  if(r[0] <= 1000){
//      reward[0] = 500;
//  }
//  else{
//      reward[0] = -0.2 + (xD[0] - r[0]) * 1
//          + (abs(xD[1]) - abs(pitch_diff[0]) + abs(xD[2]) - abs(yaw_diff[0])) * 100;
//          //- (abs(xD[3]) - abs(enemy_pitch_diff[0]) + abs(xD[4]) - abs(enemy_yaw_diff[0])) * 100;
//  }

 // only yaw angle
//  if(abs(yaw_diff[0]) <= 1e-10){
//      reward[0] = 50;
//  }
//  else{
//      reward[0] = -0.2 + (abs(xD[2]) - abs(yaw_diff[0])) * 100;
//  }

 //only hp
 if(xD[5] - enemy_hp[0] > 0){
     reward[0] = 50;
 }
 else{
     reward[0] = -0.2 + (abs(xD[1]) - abs(pitch_diff[0]) + abs(xD[2]) - abs(yaw_diff[0])) * 200;
 }
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_END --- EDIT HERE TO _BEGIN */
}

/*
 * Updates function
 *
 */
void TrackReward_Update_wrapper(const real_T *r,
			const real_T *pitch_diff,
			const real_T *yaw_diff,
			const real_T *enemy_pitch_diff,
			const real_T *enemy_yaw_diff,
			const real_T *enemy_hp,
			real_T *reward,
			real_T *xD)
{
/* %%%-SFUNWIZ_wrapper_Update_Changes_BEGIN --- EDIT HERE TO _END */
xD[0] = r[0];
    xD[1] = pitch_diff[0];
    xD[2] = yaw_diff[0];
    xD[3] = enemy_pitch_diff[0];
    xD[4] = enemy_yaw_diff[0];
    xD[5] = enemy_hp[0];
/* %%%-SFUNWIZ_wrapper_Update_Changes_END --- EDIT HERE TO _BEGIN */
}

