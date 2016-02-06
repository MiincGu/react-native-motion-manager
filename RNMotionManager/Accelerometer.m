//
//  Accelerometer.m
//
//  Created by Patrick Williams in beautiful Seattle, WA.
//

#import "RCTBridge.h"
#import "RCTEventDispatcher.h"
#import "Accelerometer.h"

@implementation Accelerometer

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

- (id) init {
  self = [super init];

  if (self) {
    self->_motionManager = [[CMMotionManager alloc] init];
    //Accelerometer
    if([self->_motionManager isAccelerometerAvailable])
    {
      /* Start the accelerometer if it is not active already */
      if([self->_motionManager isAccelerometerActive] == NO)
      {
      } else {
      }
    }
    else
    {
    }
  }
  return self;
}

RCT_EXPORT_METHOD(setAccelerometerUpdateInterval:(double) interval) {
  [self->_motionManager setAccelerometerUpdateInterval:interval];
}

RCT_EXPORT_METHOD(getAccelerometerUpdateInterval:(RCTResponseSenderBlock) cb) {
  double interval = self->_motionManager.accelerometerUpdateInterval;
  cb(@[[NSNull null], [NSNumber numberWithDouble:interval]]);
}

RCT_EXPORT_METHOD(getAccelerometerData:(RCTResponseSenderBlock) cb) {
  double x = self->_motionManager.accelerometerData.acceleration.x;
  double y = self->_motionManager.accelerometerData.acceleration.y;
  double z = self->_motionManager.accelerometerData.acceleration.z;
  
  cb(@[[NSNull null], @{
         @"acceleration": @{
             @"x" : [NSNumber numberWithDouble:x],
             @"y" : [NSNumber numberWithDouble:y],
             @"z" : [NSNumber numberWithDouble:z]
             }
         }]
     );
}

RCT_EXPORT_METHOD(startAccelerometerUpdates) {
  [self->_motionManager startAccelerometerUpdates];
  
  /* Receive the ccelerometer data on this block */
  [self->_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue]
                                    withHandler:^(CMAccelerometerData *accelerometerData, NSError *error)
   {
     double x = accelerometerData.acceleration.x;
     double y = accelerometerData.acceleration.y;
     double z = accelerometerData.acceleration.z;
     
     [self.bridge.eventDispatcher sendDeviceEventWithName:@"AccelerationData" body:@{
                                                                             @"acceleration": @{
                                                                                 @"x" : [NSNumber numberWithDouble:x],
                                                                                 @"y" : [NSNumber numberWithDouble:y],
                                                                                 @"z" : [NSNumber numberWithDouble:z]
                                                                                 }
                                                                             }];
   }];
  
}

RCT_EXPORT_METHOD(stopAccelerometerUpdates) {
  [self->_motionManager stopAccelerometerUpdates];
}

@end
