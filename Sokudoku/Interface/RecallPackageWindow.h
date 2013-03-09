//
//  RememberWindowController.h
//  Sokudoku
//
//  Created by Douglas Triggs on 3/8/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MainWindow;

@interface RecallPackageWindow : NSWindowController {
@private
    NSPopUpButton *forgottenPackages;
    
    NSButton *cancelButton;
    NSButton *recallButton;
    
    MainWindow *parent;
}

@property IBOutlet NSPopUpButton *forgottenPackages;
@property IBOutlet NSButton *cancelButton;
@property IBOutlet NSButton *recallButton;

-(IBAction)cancel:(id)sender;
-(IBAction)recall:(id)sender;

@property MainWindow *parent;


@end
