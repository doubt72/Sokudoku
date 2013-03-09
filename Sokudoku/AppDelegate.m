//
//  AppDelegate.m
//  Sokudoku
//
//  Created by Douglas Triggs on 2/26/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import "AppDelegate.h"
#import "MainWindow.h"

@implementation AppDelegate

@synthesize mainWindow;

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    mainWindow = [[MainWindow alloc] initWithWindowNibName:@"MainWindow"];
    [mainWindow showWindow:self];
}

@end
