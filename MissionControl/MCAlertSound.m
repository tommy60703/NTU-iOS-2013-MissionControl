//
//  MCAlertSound.m
//  MissionControl
//
//  Created by Tommy Lin on 2013/12/23.
//  Copyright (c) 2013年 Tommy Lin. All rights reserved.
//

#import "MCAlertSound.h"

@implementation MCAlertSound

- (instancetype)init {
    if (self = [super init]) {
        NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"xperiaz_VDLVxZSw" withExtension:@"mp3"];
        self.sound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
        self.sound.volume = 1.0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop) name:@"stopAlert" object:nil];
    }
    return self;
}

- (void)fire {
    [self.sound play];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(repeat) userInfo:nil repeats:NO];
}

- (void)repeat {
    self.sound.numberOfLoops = -1;
    [self.sound play];
}

- (void)stop {
    [self.sound stop];
}

@end
