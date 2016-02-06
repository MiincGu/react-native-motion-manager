//
//  Gyroscope.m
//
//  Created by Patrick Williams in beautiful Seattle, WA.
//

#import "RCTBridge.h"
#import "RCTEventDispatcher.h"
#import "Gyroscope.h"

@implementation Gyroscope

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

- (id) init {
    self = [super init];
  
    if (self) {
        self->_motionManager = [[CMMotionManager alloc] init];
        //Gyroscope
        if([self->_motionManager isGyroAvailable])
        {
            /* Start the gyroscope if it is not active already */
            if([self->_motionManager isGyroActive] == NO)
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

RCT_EXPORT_METHOD(setGyroUpdateInterval:(double) interval) {
    [self->_motionManager setGyroUpdateInterval:interval];
}

RCT_EXPORT_METHOD(getGyroUpdateInterval:(RCTResponseSenderBlock) cb) {
    double interval = self->_motionManager.gyroUpdateInterval;
    cb(@[[NSNull null], [NSNumber numberWithDouble:interval]]);
}

RCT_EXPORT_METHOD(getGyroData:(RCTResponseSenderBlock) cb) {
    double x = self->_motionManager.gyroData.rotationRate.x;
    double y = self->_motionManager.gyroData.rotationRate.y;
    double z = self->_motionManager.gyroData.rotationRate.z;
    
    cb(@[[NSNull null], @{
             @"rotationRate": @{
                     @"x" : [NSNumber numberWithDouble:x],
                     @"y" : [NSNumber numberWithDouble:y],
                     @"z" : [NSNumber numberWithDouble:z]
                     }
             }]
       );
}

RCT_EXPORT_METHOD(startGyroUpdates) {
    [self->_motionManager startGyroUpdates];
    
    /* Receive the gyroscope data on this block */
    [self->_motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue]
                                      withHandler:^(CMGyroData *gyroData, NSError *error)
     {
         double x = gyroData.rotationRate.x;
         double y = gyroData.rotationRate.y;
         double z = gyroData.rotationRate.z;
         
         [self.bridge.eventDispatcher sendDeviceEventWithName:@"GyroData" body:@{
                                                                                 @"rotationRate": @{
                                                                                         @"x" : [NSNumber numberWithDouble:x],
                                                                                         @"y" : [NSNumber numberWithDouble:y],
                                                                                         @"z" : [NSNumber numberWithDouble:z]
                                                                                         }
                                                                                 }];
     }];
    
}

RCT_EXPORT_METHOD(stopGyroUpdates) {
    [self->_motionManager stopGyroUpdates];
}

@end
