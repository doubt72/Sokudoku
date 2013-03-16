//
//  History.m
//  Sokudoku
//
//  Created by Douglas Triggs on 3/3/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you
// may not use this file except in compliance with the License. You may
// obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
// implied. See the License for the specific language governing
// permissions and limitations under the License.

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

- (NSArray *)allEvents {
    return events;
}

- (id)init {
    if (self = [super init]) {
        events = [NSMutableArray arrayWithCapacity:256];
    }
    return self;
}

@end
