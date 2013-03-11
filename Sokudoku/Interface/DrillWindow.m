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

- (void)sessionFinished:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    [parent endDrill];
}

- (void)finish {
    [testString setStringValue:@""];
    int seconds = (int)(sessionLength - timeLeft) % 60;
    int minutes = (int)((sessionLength - timeLeft) / 60);
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"Continue"];
    [alert setMessageText:@"Session Complete"];
    [alert setInformativeText:[NSString stringWithFormat:@"Drill session is complete.  %d questions finished (with %d correct) during a total session time of %.2d:%.2d.",
                               correctAnswers + incorrectAnswers,
                               correctAnswers, minutes, seconds]];
    [alert setAlertStyle:NSInformationalAlertStyle];
    [alert beginSheetModalForWindow:[self window] modalDelegate:self didEndSelector:@selector(sessionFinished:returnCode:contextInfo:) contextInfo:nil];
}

- (IBAction)answer:(id)sender {
    NSTimeInterval elapsed = [time timeIntervalSinceNow];
    timeLeft += elapsed;
    NSString *answer = [answerField stringValue];
    NSString *status;
    if ([package test:literals:answer:-elapsed]) {
        correctAnswers++;
        status = [NSString stringWithFormat:@"Answer %@ correct (in %.2f seconds)",
                            answer, -elapsed];
    } else {
        incorrectAnswers++;
        status = [NSString stringWithFormat:@"Answer %@ incorrect", answer];
    }
    [statusField setStringValue:status];
    if (timeLeft < 0) {
        [self finish];
    } else {
        [answerField setStringValue:@""];
        [self nextQuestion];
    }
}

- (NSString *)literalStrings {
    NSMutableString *rc = [[NSMutableString alloc] initWithCapacity:[literals count]];
    for (int i = 0; i < [literals count]; i++) {
        [rc appendString:[literals objectAtIndex:i]];
    }
    return [NSString stringWithString:rc];
}

- (void)nextQuestion {
    int seconds = (int)timeLeft % 60;
    int minutes = (int)(timeLeft / 60);
    [timer setStringValue:[NSString stringWithFormat:@"%.2d:%.2d", minutes, seconds]];
    literals = [package generate:minLength:maxLength:weighted:tag];
    [testString setStringValue:[self literalStrings]];

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
