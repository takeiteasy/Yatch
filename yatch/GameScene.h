//
//  GameScene.h
//  yatch
//
//  Created by Rory B. Bellows on 19/09/2021.
//  Copyright © 2021 Rory B. Bellows. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Spritesheet.h"
#import "Die.h"
#import "Scorecard.h"

#define STATES \
    X(preroll) \
    X(rolling) \
    X(selecting)

enum retCode {
    ok,
    fail,
    repeat
};

typedef enum retCode(*stateFn)(CFTimeInterval);

enum stateCode {
#define X(a) a,
    STATES
#undef X
};

enum eventType {
    touchBegan,
    touchMoved,
    touchEnded,
    touchCancelled,
    motionBegan,
    motionEnded,
    motionCancelled
};

#define FIVE 5

@interface GameScene : SKScene <SKPhysicsContactDelegate> {
    Spritesheet *diceAtlas;
    Die *dice[FIVE], *diceSelected[FIVE];
    SKSpriteNode *cup, *nextRollBtn, *scorecardBtn;
    SKLabelNode *scorecardLabels[nScoreNames * 2];
    SKShapeNode *boundaries, *scorecardCard;
    Scorecard *scorecard, *hiddenScorecard;
    BOOL scorecardVisible;
    CFTimeInterval lastTimeInterval;
    enum stateCode state;
    BOOL nextStateFlag, blockActions;
    NSMutableArray *contactQueue;
    int nSelectedDice, turn;
}
#define X(a) \
-(BOOL)a##InitFunc; \
-(BOOL)a##InputFunc:(UITouch*)t withEvent:(UIEvent*)e withType:(enum eventType)tt; \
-(enum retCode)a##UpdateFunc:(CFTimeInterval)t;
STATES
#undef X
@end
