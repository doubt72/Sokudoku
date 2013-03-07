//
//  History.m
//  Sokudoku
//
//  Created by Douglas Triggs on 3/3/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import "History.h"
#import "Event.h"

@implementation History

- (void)addEvent:(Event *)event {
    [events addObject:event];
}

- (void)save:(NSString *)fileName {
    ;
}

- (void)load:(NSString *)fileName {
    ;
}

- (id)init {
    if (self = [super init]) {
        events = [NSMutableArray arrayWithCapacity:256];
    }
    return self;
}

@end
