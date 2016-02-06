//
//  Magnetometer.m
//
//  Created by Patrick Williams in beautiful Seattle, WA.
//

#import "RCTBridge.h"
#import "RCTEventDispatcher.h"
#import "Magnetometer.h"

@implementation Magnetometer

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

- (id) init {
  self = [super init];
  
  if (self) {
    self->_motionManager = [[CMMotionManager alloc] init];
    //Magnetometer
    if([self->_motionManager isMagnetometerAvailable])
    {
      /* Start the Magnetometer if it is not active already */
      if([self->_motionManager isMagnetometerActive] == NO)
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

RCT_EXPORT_METHOD(setMagnetometerUpdateInterval:(double) interval) {
  [self->_motionManager setMagnetometerUpdateInterval:interval];
}

RCT_EXPORT_METHOD(getMagnetometerUpdateInterval:(RCTResponseSenderBlock) cb) {
  double interval = self->_motionManager.magnetometerUpdateInterval;
  cb(@[[NSNull null], [NSNumber numberWithDouble:interval]]);
}

RCT_EXPORT_METHOD(getMagnetometerData:(RCTResponseSenderBlock) cb) {
  double x = self->_motionManager.magnetometerData.magneticField.x;
  double y = self->_motionManager.magnetometerData.magneticField.y;
  double z = self->_motionManager.magnetometerData.magneticField.z;
  
  cb(@[[NSNull null], @{
         @"magneticField": @{
             @"x" : [NSNumber numberWithDouble:x],
             @"y" : [NSNumber numberWithDouble:y],
             @"z" : [NSNumber numberWithDouble:z]
             }
         }]
     );
}

RCT_EXPORT_METHOD(startMagnetometerUpdates) {
  [self->_motionManager startMagnetometerUpdates];
  
  /* Receive the ccelerometer data on this block */
  [self->_motionManager startMagnetometerUpdatesToQueue:[NSOperationQueue mainQueue]
                                             withHandler:^(CMMagnetometerData *magnetometerData, NSError *error)
   {
     double x = magnetometerData.magneticField.x;
     double y = magnetometerData.magneticField.y;
     double z = magnetometerData.magneticField.z;
     
     [self.bridge.eventDispatcher sendDeviceEventWithName:@"MagnetometerData" body:@{
                                                                                     @"magneticField": @{
                                                                                         @"x" : [NSNumber numberWithDouble:x],
                                                                                         @"y" : [NSNumber numberWithDouble:y],
                                                                                         @"z" : [NSNumber numberWithDouble:z]
                                                                                         }
                                                                                     }];
   }];
  
}

RCT_EXPORT_METHOD(stopMagnetometerUpdates) {
  [self->_motionManager stopMagnetometerUpdates];
}

@end
