//
//  DrillWindow.m
//  Sokudoku
//
//  Created by Douglas Triggs on 3/10/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import "DrillWindow.h"
#import "MainWindow.h"
#import "Package.h"

@implementation DrillWindow
@synthesize testString, statusString, timer;
@synthesize answerField;
@synthesize abortButton;

@synthesize parent;
@synthesize package;

@synthesize minLength, maxLength, sessionLength, weighted;

- (IBAction)abort:(id)sender {
    [parent endDrill];
}

- (IBAction)answer:(id)sender {
    [answerField setStringValue:@""];
    [self nextQuestion];
}

- (void)nextQuestion {
    time = [NSDate date];
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
}

@end
