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
@synthesize testString, statusField, timer;
@synthesize answerField;
@synthesize abortButton;

@synthesize parent;
@synthesize package;

@synthesize minLength, maxLength, sessionLength, timeLeft, weighted;
@synthesize tag;

- (IBAction)abort:(id)sender {
    [parent endDrill];
}

- (void)finish {
    // TODO: Dialog box, yadda yadda.
    [parent endDrill];
}

- (IBAction)answer:(id)sender {
    NSTimeInterval elapsed = [time timeIntervalSinceNow];
    timeLeft += elapsed;
    NSString *answer = [answerField stringValue];
    NSString *status;
    if ([package test:[testString stringValue]:answer]) {
        status = [NSString stringWithFormat:@"Answer %@ correct (in %.2f seconds)",
                            answer, -elapsed];
    } else {
        status = [NSString stringWithFormat:@"Answer %@ incorrect", answer];
    }
    [statusField setStringValue:status];
    if (timeLeft < 0) {
        [self finish];
    }
    
    [answerField setStringValue:@""];
    [self nextQuestion];
}

- (void)nextQuestion {
    int seconds = (int)timeLeft % 60;
    int minutes = (int)(timeLeft / 60);
    [timer setStringValue:[NSString stringWithFormat:@"%.2d:%.2d", minutes, seconds]];
    [testString setStringValue:[package generate:minLength :maxLength :weighted :tag]];

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
    correctAnswers = 0;
    incorrectAnswers = 0;
}

@end
