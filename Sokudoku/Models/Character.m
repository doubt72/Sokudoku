//
//  Character.m
//  Sokudoku
//
//  Created by Douglas Triggs on 3/3/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import "Character.h"
#import "Event.h"

@implementation Character

@synthesize literal;

// Because characters are only tested in isolation when the string being tested is
// one character long, we weigh the results so that long strings affect the average
// time less than shorter strings
- (Event *)newEvent:(float)forLength :(float)time {
    float weight = 1.0 / (forLength * forLength);
    timesTested += weight;
    totalTime += time * weight;
    
    Event *event = [[Event alloc] init];
    [event setCharacter:[NSString stringWithString:literal]];
    [event setTimeStamp:[NSDate date]];
    [event setWeight:weight];
    [event setWeightedTime:time * weight];
    return event;
}

- (float)averageSpeed {
    return totalTime / timesTested;
}

- (void)addTag:(NSString *)tag {
    [tags addObject:tag];
}

- (BOOL)hasTag:(NSString *)tag {
    return [tags containsObject:tag];
}

- (void)addPronunciation:(NSString *)pronunciation {
    [pronunciations addObject:pronunciation];
}

- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setValue:literal forKey:@"literal"];
    [dict setValue:[NSArray arrayWithArray:pronunciations] forKey:@"pronunciations"];
    [dict setValue:[NSArray arrayWithArray:tags] forKey:@"tags"];
    [dict setValue:[NSNumber numberWithFloat:timesTested] forKey:@"timesTested"];
    [dict setValue:[NSNumber numberWithFloat:totalTime] forKey:@"totalTimes"];
    return dict;
}

- (void)fromDictionary:(NSMutableDictionary *)dict {
    literal = [dict objectForKey:@"literal"];
    pronunciations = [NSMutableArray arrayWithArray:[dict objectForKey:@"pronunciations"]];
    tags = [NSMutableArray arrayWithArray:[dict objectForKey:@"tags"]];
    timesTested = [[dict objectForKey:@"timesTested"] floatValue];
    totalTime = [[dict objectForKey:@"totalTimes"] floatValue];
}

- (NSArray *)appendAllPronunciations:(NSArray *)list {
    NSMutableArray *rc = [[NSMutableArray alloc] initWithCapacity:[list count] * [pronunciations count]];
    for (int i = 0; i < [list count]; i++) {
        for (int j = 0; j < [pronunciations count]; j++) {
            [rc addObject:[NSString stringWithFormat:@"%@%@",
                           [list objectAtIndex:i], [pronunciations objectAtIndex:j]]];
        }
        [rc addObject:[NSString stringWithFormat:@"%@%@",
                       [list objectAtIndex:i], literal]];
    }
    return [NSArray arrayWithArray:rc];
}

- (id)init {
    if (self = [super init]) {
        literal = nil;
        
        tags = [NSMutableArray arrayWithCapacity:1];
        pronunciations = [NSMutableArray arrayWithCapacity:1];
        
        timesTested = 0;
        totalTime = 0;
    }
    return self;
}

@end
