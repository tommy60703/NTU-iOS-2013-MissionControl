//
//  MCAlertSound.h
//  MissionControl
//
//  Created by Tommy Lin on 2013/12/23.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface MCAlertSound : NSObject

@property (strong, nonatomic) AVAudioPlayer *sound;
@property (strong, nonatomic) NSTimer *timer;

- (void)fire;
- (void)repeat;
- (void)stop;

@end
