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

#define MAXDICE 5

@interface GameScene : SKScene <SKPhysicsContactDelegate> {
    Spritesheet *diceAtlas;
    Die *dice[MAXDICE], *diceSelected[MAXDICE];
    SKSpriteNode *cup, *nextRollBtn, *scorecardBtn;
    SKShapeNode *scorecardCard, *scorecardBoxes[nScoreNames * 2];
    SKLabelNode *scorecardLabels[nScoreNames * 2];
    SKShapeNode *boundaries;
    Scorecard *scorecard;
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
