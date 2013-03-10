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
    NSTextField *statusString;
    NSTextField *timer;

    NSTextField *answerField;
    NSButton *abortButton;

    MainWindow *parent;
    Package *package;
    
    int minLength;
    int maxLength;
    float sessionLength;
    BOOL weighted;
    
    NSDate *time;
}

@property IBOutlet NSTextField *testString;
@property IBOutlet NSTextField *statusString;
@property IBOutlet NSTextField *timer;
@property IBOutlet NSTextField *answerField;
@property IBOutlet NSButton *abortButton;

@property MainWindow *parent;
@property Package *package;

@property int minLength, maxLength;
@property float sessionLength;
@property BOOL weighted;

- (IBAction)abort:(id)sender;
- (IBAction)answer:(id)sender;

- (void)nextQuestion;

@end
