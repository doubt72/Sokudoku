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
@synthesize versionField, continueButton, parent;

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
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
	NSString *version = [info objectForKey:@"CFBundleShortVersionString"];
    [versionField setStringValue:[NSString stringWithFormat:@"version %@", version]];
}

@end
