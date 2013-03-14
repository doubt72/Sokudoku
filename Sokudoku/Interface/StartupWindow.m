//
//  StartupWindow.m
//  Sokudoku
//
//  Created by Douglas Triggs on 3/13/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import "StartupWindow.h"
#import "AppDelegate.h"

@implementation StartupWindow
@synthesize continueButton, parent;

- (IBAction)done:(id)sender {
    [parent startupFinished];
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
