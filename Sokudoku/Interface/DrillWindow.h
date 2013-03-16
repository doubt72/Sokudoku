//
//  DrillWindow.h
//  Sokudoku
//
//  Created by Douglas Triggs on 3/10/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

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
