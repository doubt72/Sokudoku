//
//  AppDelegate.h
//  Sokudoku
//
//  Created by Douglas Triggs on 2/26/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
    
    NSPopUpButton *dataSet;
    NSSlider *minLength, *maxLength, *sessionLength;
    NSButton *weightHistory;
    NSTextField *minLengthStatus, *maxLengthStatus, *sessionLengthStatus;
    NSTextField *currentPackage;
    NSButton *beginSession;
    NSButton *loadPackage, *importPackage, *forgetPackage, *deletePackage;
    NSButton *showHistory, *showHistogram, *resetPackage, *forgetHistory;
}

@property (assign) IBOutlet NSWindow *window;

@property IBOutlet NSPopUpButton *dataSet;
@property IBOutlet NSSlider *minLength;
@property IBOutlet NSSlider *maxLength;
@property IBOutlet NSSlider *sessionLength;
@property IBOutlet NSButton *weightHistory;
@property IBOutlet NSTextField *minLengthStatus;
@property IBOutlet NSTextField *maxLengthStatus;
@property IBOutlet NSTextField *sessionLengthStatus;
@property IBOutlet NSTextField *currentPackage;
@property IBOutlet NSButton *beginSession;
@property IBOutlet NSButton *loadPackage;
@property IBOutlet NSButton *importPackage;
@property IBOutlet NSButton *forgetPackage;
@property IBOutlet NSButton *deletePackage;
@property IBOutlet NSButton *showHistory;
@property IBOutlet NSButton *showHistogram;
@property IBOutlet NSButton *resetPackage;
@property IBOutlet NSButton *forgetHistory;

@end
