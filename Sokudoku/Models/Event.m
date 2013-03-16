//
//  Event.m
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
