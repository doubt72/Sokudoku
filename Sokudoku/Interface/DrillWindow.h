//
//  DrillWindow.h
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

#import <Cocoa/Cocoa.h>
@class MainWindow;
@class Package;

@interface DrillWindow : NSWindowController {
@private
    NSTextField *testString;
    NSTextField *statusField;
    NSTextField *timer;

    NSTextField *answerField;
    NSButton *abortButton;

    MainWindow *parent;
    Package *package;

    int minLength;
    int maxLength;
    float sessionLength;
    float timeLeft;
    BOOL weighted;
    NSString *tag;
    
    int correctAnswers;
    int incorrectAnswers;
    
    NSArray *literals;

    NSDate *time;
}

@property IBOutlet NSTextField *testString;
@property IBOutlet NSTextField *statusField;
@property IBOutlet NSTextField *timer;
@property IBOutlet NSTextField *answerField;
@property IBOutlet NSButton *abortButton;

@property MainWindow *parent;
@property Package *package;

@property int minLength, maxLength;
@property float sessionLength, timeLeft;
@property BOOL weighted;
@property NSString *tag;

- (IBAction)abort:(id)sender;
- (IBAction)answer:(id)sender;

// Set up next question
- (void)nextQuestion;

@end
