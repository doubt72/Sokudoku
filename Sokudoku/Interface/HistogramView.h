//
//  HistogramView.h
//  Sokudoku
//
//  Created by Douglas Triggs on 3/11/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class Package;

@interface HistogramView : NSView {
@private
    Package *package;
    
    NSString *tag;
    
    BOOL top;
}

@property Package *package;
@property NSString *tag;
@property BOOL top;

@end
