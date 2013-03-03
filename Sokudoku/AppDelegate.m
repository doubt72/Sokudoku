//
//  AppDelegate.m
//  Sokudoku
//
//  Created by Douglas Triggs on 2/26/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import "AppDelegate.h"

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
    }
    [maxLengthStatus setStringValue:[NSString stringWithFormat:@"%d", max]];
}

- (IBAction)updateMinLength:(id)sender{
    int max = [maxLength intValue];
    int min = [minLength intValue];
    if (max < min) {
        [maxLength setIntegerValue:min];
        [maxLengthStatus setStringValue:[NSString stringWithFormat:@"%d", min]];
    }
    [minLengthStatus setStringValue:[NSString stringWithFormat:@"%d", min]];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Default Settings if no config file found

    [currentPackage setStringValue:@"No Package Loaded"];
    [dataSet removeAllItems];
    [dataSet addItemWithTitle:@"All Characters"];
    [minLength setIntegerValue:2];
    [minLengthStatus setStringValue:@"2"];
    [maxLength setIntegerValue:5];
    [maxLengthStatus setStringValue:@"5"];
    [sessionLength setIntegerValue:5];
    [sessionLengthStatus setStringValue:@"5"];
}

@end
