//
//  StartupWindow.h
//  Sokudoku
//
//  Created by Douglas Triggs on 3/13/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class AppDelegate;

@interface StartupWindow : NSWindowController {
@private
    NSTextField *versionField;
    NSButton *continueButton;
    AppDelegate *parent;
}

@property IBOutlet NSTextField *versionField;
@property IBOutlet NSButton *continueButton;
@property AppDelegate *parent;

- (IBAction)done:(id)sender;

@end
