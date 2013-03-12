//
//  HistogramView.m
//  Sokudoku
//
//  Created by Douglas Triggs on 3/11/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import "HistogramView.h"
#import "Package.h"

@implementation HistogramView
@synthesize package;
@synthesize tag;

- (BOOL) isFlipped {
    return YES;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSArray *array = [package statsForTag:tag];
    NSScrollView *scrollView = [self enclosingScrollView];
    NSSize size = [scrollView contentSize];
    float boundsX = size.width;
    float boundsY = size.height;
    float scale = 64 + boundsX / 25;
    if ([array count] * scale + scale / 6 > boundsY) {
        boundsY = [array count] * scale + scale / 6;
    }
    [self setFrameSize:NSMakeSize(boundsX, boundsY)];
    
    // Draw background
    NSRect rect = [self bounds];
    [[NSColor blackColor] set];
    [NSBezierPath fillRect:rect];
}

@end
