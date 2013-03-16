//
//  Event.h
//  Sokudoku
//
//  Created by Douglas Triggs on 3/3/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject {
@private
    NSString *character;
    NSDate *timeStamp;
    
    float weight;
    float weightedTime;
}

@property(copy) NSString *character;
@property(copy) NSDate *timeStamp;
@property float weight, weightedTime;

// For loading and saving records
- (NSMutableDictionary *) toDictionary;
- (void) fromDictionary:(NSMutableDictionary *)dict;

@end
