//
//  AppDelegate.h
//  Sokudoku
//
//  Created by Douglas Triggs on 2/26/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MainWindow;

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    MainWindow *mainWindow;
}

@property MainWindow *mainWindow;

- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender;

@end
