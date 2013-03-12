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
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[events count]];
    for (int i = 0; i < [events count]; i++) {
        [array addObject:[[events objectAtIndex:i] toDictionary]];
    }
    [array writeToFile:fileName atomically:YES];
}

- (void)load:(NSString *)fileName {
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:fileName];
    [events removeAllObjects];
    for (int i = 0; i < [array count]; i++) {
        Event *event = [[Event alloc] init];
        [event fromDictionary:[array objectAtIndex:i]];
        [events addObject:event];
    }
}

- (void)clear {
    [events removeAllObjects];
}

- (id)init {
    if (self = [super init]) {
        events = [NSMutableArray arrayWithCapacity:256];
    }
    return self;
}

@end
