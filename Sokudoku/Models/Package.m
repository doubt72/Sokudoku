//
//  Package.m
//  Sokudoku
//
//  Created by Douglas Triggs on 3/3/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import "Package.h"
#import "History.h"
#import "Character.h"
#import "Event.h"

@implementation Package

@synthesize name;

- (void)addCharacter:(Character *)character {
    [characters addObject:character];
}

- (void)addTag:(NSString *)tag :(NSString *)description {
    [tags addObject:tag];
    [tagDescriptions addObject:description];
}

- (void)newEvent:(NSArray *)chars :(float)totalTime {
    unsigned long int length = [chars count];
    for (int i = 0; i < length; i++) {
        Character *character = [chars objectAtIndex:i];
        Event *event = [character newEvent:length:totalTime];
        [history addEvent:event];
    }
}

- (id)init {
    if (self = [super init]) {
        history = [[History alloc] init];
        
        characters = [NSMutableArray arrayWithCapacity:10];
        tags = [NSMutableArray arrayWithCapacity:1];
        tagDescriptions = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

@end
