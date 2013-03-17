//
//  DrillWindow.m
//  Sokudoku
//
//  Created by Douglas Triggs on 3/10/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you
// may not use this file except in compliance with the License. You may
// obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
// implied. See the License for the specific language governing
// permissions and limitations under the License.

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

    // Alert for end of session:

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
    // Elapsed time is negative (time relative to "now")
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

// Generate string from array of literals:
//
// Keeping the characters in an array makes it easier to keep track of which
// characters are being drilled (especially since compound characters are possible,
// in which case keeping them straight is particularly difficult).
- (NSString *)literalStrings {
    NSMutableString *rc = [[NSMutableString alloc] initWithCapacity:[literals count]];
    for (int i = 0; i < [literals count]; i++) {
        [rc appendString:[literals objectAtIndex:i]];
    }
    return [NSString stringWithString:rc];
}

- (BOOL)compare {
    if ([literals count] != [lastQuestion count]) {
        return NO;
    }
    for (int i = 0; i < [literals count]; i++) {
        if ([[literals objectAtIndex:i] compare:[lastQuestion objectAtIndex:i]] !=
            NSOrderedSame) {
            return NO;
        }
    }
    return YES;
}

// Set up next question
- (void)nextQuestion {
    int seconds = (int)timeLeft % 60;
    int minutes = (int)(timeLeft / 60);
    [timer setStringValue:[NSString stringWithFormat:@"%.2d:%.2d", minutes, seconds]];
    lastQuestion = literals;
    while ([self compare]) {
        literals = [package generate:minLength:maxLength:weighted:tag];
    }
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
    lastQuestion = [NSArray arrayWithObject:@""];
}

@end
