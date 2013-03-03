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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

@end
