//
//  History.m
//  Sokudoku
//
//  Created by Douglas Triggs on 3/3/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import "History.h"

@implementation History

- (void)addEvent:(Event *)event {
    [events addObject:event];
}

@end
