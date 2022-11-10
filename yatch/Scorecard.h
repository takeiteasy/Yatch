//
//  Scorecard.h
//  yatch
//
//  Created by Rory B. Bellows on 31/10/2021.
//  Copyright © 2021 Rory B. Bellows. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

NS_ASSUME_NONNULL_BEGIN

static const int nScoreNames = 12;
static NSString* _Nonnull  scoreNames[nScoreNames] = {
    @"Aces",
    @"Duces",
    @"Threes",
    @"Fours",
    @"Fives",
    @"Sixes",
    @"Choice",
    @"Four of a kind",
    @"Full house",
    @"Small straight",
    @"Large straight",
    @"Yatch"
};

@interface Scorecard : NSObject {
    NSMapTable *scores;
}
@property BOOL bonusAchieved;
@property int scoreTotal;
@property BOOL isFull;

-(id)init;
-(int)getScore:(NSString*)name;
-(void)setScore:(NSString*)name withValue:(int)v;
-(void)reset;
@end

NS_ASSUME_NONNULL_END
