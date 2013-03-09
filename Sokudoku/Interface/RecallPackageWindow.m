//
//  RememberWindowController.m
//  Sokudoku
//
//  Created by Douglas Triggs on 3/8/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import "RecallPackageWindow.h"
#import "MainWindow.h"

@implementation RecallPackageWindow
@synthesize forgottenPackages;
@synthesize cancelButton, recallButton;
@synthesize parent;

- (IBAction)cancel:(id)sender {
    [parent abortRecall];
}

- (IBAction)recall:(id)sender {
    NSString *package = [forgottenPackages titleOfSelectedItem];
    [parent doRecall:package];
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        ;
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

@end
