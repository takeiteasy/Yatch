//
//  Scorecard.m
//  yatch
//
//  Created by Rory B. Bellows on 31/10/2021.
//  Copyright © 2021 Rory B. Bellows. All rights reserved.
//

#import "Scorecard.h"

@implementation Scorecard
-(id)init {
    if (self == [super init]) {
        scores = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn
                                       valueOptions:NSMapTableStrongMemory];
        [self reset];
    }
    return self;
    
}
-(int)getScore:(NSString*)name {
    return [[scores objectForKey:name] intValue];
}

-(void)setScore:(NSString*)name withValue:(int)v {
    [scores setObject:[NSNumber numberWithInt:v] forKey:name];
    _scoreTotal = 0;
    for (int i = 0; i < nScoreNames; i++) {
        int v = [[scores objectForKey:scoreNames[i]] intValue];
        if (v != -1)
            _scoreTotal += v;
    }
}

-(void)reset {
    for (int i = 0; i < nScoreNames; ++i)
        [scores setObject:@-1 forKey:scoreNames[i]];
    _bonusAchieved = NO;
    _scoreTotal = 0;
}
@end
