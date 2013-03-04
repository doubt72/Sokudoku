//
//  Event.h
//  Sokudoku
//
//  Created by Douglas Triggs on 3/3/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Character;

@interface Event : NSObject {
@private
    Character *character;
    NSDate *timeStamp;
    
    float weight;
    float weightedTime;
}

@property(copy) Character *character;
@property(copy) NSDate *timeStamp;
@property float weight, weightedTime;

@end
