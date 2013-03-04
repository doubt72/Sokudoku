//
//  AppDelegate.m
//  Sokudoku
//
//  Created by Douglas Triggs on 2/26/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import "AppDelegate.h"
#import "Settings.h"

@implementation AppDelegate
@synthesize dataSet;
@synthesize minLength, maxLength, sessionLength;
@synthesize weightHistory;
@synthesize minLengthStatus, maxLengthStatus, sessionLengthStatus;
@synthesize currentPackage;
@synthesize beginSession;
@synthesize loadPackage, importPackage, forgetPackage, deletePackage;
@synthesize showHistory, showHistogram, resetPackage, forgetHistory;

- (IBAction)updateMaxLength:(id)sender {
    int max = [maxLength intValue];
    int min = [minLength intValue];
    if (max < min) {
        [minLength setIntegerValue:max];
        [minLengthStatus setStringValue:[NSString stringWithFormat:@"%d", max]];
        [settings setMinLength:max];
    }
    [maxLengthStatus setStringValue:[NSString stringWithFormat:@"%d", max]];
    [settings setMaxLength:max];
}

- (IBAction)updateMinLength:(id)sender {
    int max = [maxLength intValue];
    int min = [minLength intValue];
    if (max < min) {
        [maxLength setIntegerValue:min];
        [maxLengthStatus setStringValue:[NSString stringWithFormat:@"%d", min]];
        [settings setMaxLength:min];
    }
    [minLengthStatus setStringValue:[NSString stringWithFormat:@"%d", min]];
    [settings setMinLength:min];
}

- (IBAction)updateSessionLength:(id)sender {
    int length = [sessionLength intValue];
    [sessionLengthStatus setStringValue:[NSString stringWithFormat:@"%d", length]];
    [settings setSessionLength:length];
}

- (IBAction)updateWeightHistory:(id)sender {
    NSInteger state = [weightHistory state];
    if (state == NSOnState) {
        [settings enableAdaptiveDrill];
    } else {
        [settings disableAdaptiveDrill];
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    settings = [[Settings alloc] init];
    NSString *name = [settings currentPackageName];
    if (name == nil) {
        [currentPackage setStringValue:@"no package loaded"];
        // TODO: trigger package load
    } else {
        [currentPackage setStringValue:name];
        // TODO: set package dataset options
    }
    [minLength setIntValue:[settings minLength]];
    [maxLength setIntValue:[settings maxLength]];
    [sessionLength setIntValue:[settings sessionLength]];
    [minLengthStatus setIntValue:[settings minLength]];
    [maxLengthStatus setIntValue:[settings maxLength]];
    [sessionLengthStatus setIntValue:[settings sessionLength]];
    if ([settings adaptiveDrillEnabled]) {
        [weightHistory setState:NSOnState];
    } else {
        [weightHistory setState:NSOffState];
    }
}

@end
