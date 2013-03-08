//
//  Event.m
//  Sokudoku
//
//  Created by Douglas Triggs on 3/3/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import "Event.h"

@implementation Event

@synthesize character;
@synthesize timeStamp;

@synthesize weight, weightedTime;

- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:4];
    [dict setObject:character forKey:@"character"];
    [dict setObject:timeStamp forKey:@"timeStamp"];
    [dict setObject:[NSNumber numberWithFloat:weight] forKey:@"weight"];
    [dict setObject:[NSNumber numberWithFloat:weightedTime] forKey:@"weightedTime"];
    return dict;
}

- (void) fromDictionary:(NSMutableDictionary *)dict {
    character = [dict objectForKey:@"character"];
    timeStamp = [dict objectForKey:@"timeStamp"];
    weight = [[dict objectForKey:@"weight"] floatValue];
    weightedTime = [[dict objectForKey:@"weightedTime"] floatValue];
}

@end
