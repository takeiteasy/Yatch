//
//  GameScene.m
//  yatch
//
//  Created by Rory B. Bellows on 19/09/2021.
//  Copyright © 2021 Rory B. Bellows. All rights reserved.
//

#import "GameScene.h"

static unsigned int dieRoll() {
    return arc4random_uniform(6);
}

static float lerp(float a, float b, float f) {
    return a + f * (b - a);
}

static enum stateCode transitions[] = {
#define X(a) a,
    STATES
#undef X
};
static int nTransitions = sizeof(transitions) / sizeof(transitions[0]);

#define DIESCALE 4.f
#define DIESPACE 20.f
#define DIEPOSX(n) (-(offset - DIESPACE) + (DIESPACE * n) + n * inc)

static const u_int32_t dieCategory  = 0x1 << 0;
static const u_int32_t edgeCategory = 0x1 << 1;

static NSString* rndSfx(char t, int max) {
    return [NSString stringWithFormat:@"res/%c%d.caf", t, arc4random_uniform(max) ];
}

@implementation GameScene
-(void)didMoveToView:(SKView*)view {
    [[self physicsWorld] setGravity:CGVectorMake(0.f, -9.81f)];
    contactQueue = [NSMutableArray array];
    [[self physicsWorld] setContactDelegate:self];
    diceAtlas = [[Spritesheet alloc] initWithTextureNamed:@"dice"
                                                    Width:16];
    lastTimeInterval = CACurrentMediaTime();
    nextStateFlag = NO;
    
    CGSize sz = [[UIScreen mainScreen] bounds].size;
    CGSize scale = CGSizeMake(sz.width / 2.9f, sz.height / 3.f);
    CGRect rect = CGRectMake(-sz.width + scale.width, -sz.height + scale.height, sz.width + scale.width, sz.height + scale.height);
    boundaries = [SKShapeNode shapeNodeWithRect:rect];
    [boundaries setLineWidth:0];
    [boundaries setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:rect]];
    [[boundaries physicsBody] setAffectedByGravity:NO];
    [[boundaries physicsBody] setDynamic:YES];
    [[boundaries physicsBody] setRestitution:.5f];
    [[boundaries physicsBody] setCategoryBitMask:edgeCategory];
    [[boundaries physicsBody] setContactTestBitMask:dieCategory];
    [[boundaries physicsBody] setCollisionBitMask:dieCategory];
    [self addChild:boundaries];
    
    cup = [SKSpriteNode spriteNodeWithImageNamed:@"cup"];
    [cup setScale:2.5f];
    [cup setAlpha:0.f];
    [self addChild:cup];
    
    scorecard = [[Scorecard alloc] init];
    hiddenScorecard = [[Scorecard alloc] init];
    const int boxHeight = 40.f;
    int cardHeight = boxHeight * nScoreNames + ((nScoreNames + 1) * 20);
    float scorecardY = -(cardHeight / 2.f);
    int y_off = -scorecardY - boxHeight / .75f;
    scorecardCard = [SKShapeNode shapeNodeWithRect:CGRectMake(rect.origin.x, scorecardY, rect.size.width, cardHeight)
                                      cornerRadius:15.f];
    [scorecardCard setFillColor:[UIColor whiteColor]];
    [scorecardCard setAlpha:0.f];
    [self addChild:scorecardCard];
    
    nextRollBtn = [SKSpriteNode spriteNodeWithImageNamed:@"next_roll"];
    [nextRollBtn setScale:2.5f];
    [nextRollBtn setAlpha:0.f];
    [nextRollBtn setPosition:CGPointMake(-rect.origin.x / 1.5f, -scorecardY + 50.f)];
    [self addChild:nextRollBtn];
    
    scorecardBtn = [SKSpriteNode spriteNodeWithImageNamed:@"open_scorecard"];
    [scorecardBtn setScale:2.5f];
    [scorecardBtn setAlpha:0.f];
    [scorecardBtn setPosition:CGPointMake(-rect.origin.x, -scorecardY + 50.f)];
    [self addChild:scorecardBtn];
    
    for (int i = 0; i < nScoreNames * 2; ++i) {
        if (i < nScoreNames) {
            scorecardLabels[i] = [SKLabelNode labelNodeWithText:scoreNames[i]];
            [scorecardLabels[i] setPosition:CGPointMake(rect.origin.x / 2.f, y_off)];
            [scorecardLabels[i] setFontColor:[UIColor blackColor]];
            [scorecardLabels[i] setAlpha:0.f];
            [self addChild:scorecardLabels[i]];
            
            scorecardBoxes[i] = [SKShapeNode shapeNodeWithRect:CGRectMake(rect.origin.x, y_off, rect.size.width, [scorecardLabels[i] frame].size.height)];
//            [scorecardBoxes[i] setFillColor:[UIColor redColor]];
            [scorecardBoxes[i] setAlpha:0.f];
            [self addChild:scorecardBoxes[i]];
            
            y_off -= [scorecardLabels[i] frame].size.height + boxHeight / 2.f;
        } else {
            scorecardLabels[i] = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Bold"];
            [scorecardLabels[i] setPosition:CGPointMake(-rect.origin.x / 1.25f, [scorecardLabels[i - nScoreNames] position].y)];
            [scorecardLabels[i] setText:@""];
            [scorecardLabels[i] setFontColor:[UIColor blackColor]];
            [scorecardLabels[i] setAlpha:0.f];
            [self addChild:scorecardLabels[i]];

        }
    }
    scorecardLine = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(rect.size.width - boxHeight, 1)];
    [scorecardLine setPosition:CGPointMake(6.f, y_off + boxHeight / 2.5f)];
    [scorecardLine setLineWidth:0];
    [scorecardLine setFillColor:[UIColor blackColor]];
    [scorecardLine setAlpha:0.f];
    [self addChild:scorecardLine];
    
    y_off -= boxHeight;
    bonusLabel = [SKLabelNode labelNodeWithText:@"Bonus"];
    [bonusLabel setPosition:CGPointMake(rect.origin.x / 2.f, y_off)];
    [bonusLabel setFontColor:[UIColor blackColor]];
    [bonusLabel setAlpha:0.f];
    [self addChild:bonusLabel];
    bonusScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Bold"];
    [bonusScoreLabel setText:@"0"];
    [bonusScoreLabel setPosition:CGPointMake(-rect.origin.x / 1.25f, [bonusLabel position].y)];
    [bonusScoreLabel setFontColor:[UIColor blackColor]];
    [bonusScoreLabel setAlpha:0.f];
    [self addChild:bonusScoreLabel];
    
    y_off -= [bonusLabel frame].size.height + boxHeight / 2.f;
    totalLabel = [SKLabelNode labelNodeWithText:@"Total"];
    [totalLabel setPosition:CGPointMake(rect.origin.x / 2.f, y_off)];
    [totalLabel setFontColor:[UIColor blackColor]];
    [totalLabel setAlpha:0.f];
    [self addChild:totalLabel];
    totalScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Bold"];
    [totalScoreLabel setText:@"0"];
    [totalScoreLabel setPosition:CGPointMake(-rect.origin.x / 1.25f, [totalLabel position].y)];
    [totalScoreLabel setFontColor:[UIColor blackColor]];
    [totalScoreLabel setAlpha:0.f];
    [self addChild:totalScoreLabel];
    
    turnLabel = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Bold"];
    [turnLabel setText:@"Turn 1"];
    [turnLabel setPosition:CGPointMake(rect.origin.x / 1.25f, -scorecardY + 20.f)];
    [turnLabel setAlpha:0.f];
    [self addChild:turnLabel];
    
    scorecardVisible = NO;
    
    for (int i = 0; i < FIVE; ++i)
        diceSelected[i] = nil;
    nSelectedDice = turn = 0;
    state = preroll;
    [self prerollInitFunc];
}

-(void)touchDownAtPoint:(CGPoint)pos {}
-(void)touchMovedToPoint:(CGPoint)pos {}
-(void)touchUpAtPoint:(CGPoint)pos {}
-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)e {
    for (UITouch *t in touches) {
        BOOL valid = NO;
        switch (state) {
#define X(a) \
            case a: \
                valid = [self a##InputFunc:t withEvent:e withType:touchBegan]; \
                break;
            STATES
#undef X
        }
        if (!valid)
            [self touchDownAtPoint:[t locationInNode:self]];
    }
}
-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)e {
    for (UITouch *t in touches) {
        BOOL valid = NO;
        switch (state) {
#define X(a) \
            case a: \
                valid = [self a##InputFunc:t withEvent:e withType:touchMoved]; \
                break;
            STATES
#undef X
        }
        if (!valid)
            [self touchMovedToPoint:[t locationInNode:self]];
    }
}
-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)e {
    for (UITouch *t in touches) {
        BOOL valid = NO;
        switch (state) {
#define X(a) \
            case a: \
                valid = [self a##InputFunc:t withEvent:e withType:touchEnded]; \
                break;
            STATES
#undef X
        }
        if (!valid)
            [self touchUpAtPoint:[t locationInNode:self]];
    }
}
-(void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)e {
    for (UITouch *t in touches) {
        BOOL valid = NO;
        switch (state) {
#define X(a) \
            case a: \
                valid = [self a##InputFunc:t withEvent:e withType:touchCancelled]; \
                break;
            STATES
#undef X
        }
        if (!valid)
            [self touchUpAtPoint:[t locationInNode:self]];
    }
}
-(void)motionBegan:(UIEventSubtype)t withEvent:(UIEvent*)e {
    switch (state) {
#define X(a) \
        case a: \
            [self a##InputFunc:nil withEvent:e withType:motionBegan]; \
            break;
        STATES
#undef X
    }
}
-(void)motionEnded:(UIEventSubtype)t withEvent:(UIEvent*)e {
    switch (state) {
#define X(a) \
        case a: \
            [self a##InputFunc:nil withEvent:e withType:motionEnded]; \
            break;
        STATES
#undef X
    }
}
-(void)motionCancelled:(UIEventSubtype)t withEvent:(UIEvent*)e {
    switch (state) {
#define X(a) \
        case a: \
            [self a##InputFunc:nil withEvent:e withType:motionCancelled]; \
            break;
        STATES
#undef X
    }
}
#pragma end mark

-(BOOL)prerollInitFunc {
    if (![scorecard isFull])
        [cup runAction:[SKAction fadeInWithDuration:.5f]];
    return YES;
}

-(BOOL)rollingInitFunc {
    const CGSize dieSize = CGSizeMake(16.f * DIESCALE, 16.f * DIESCALE);
    for (int i = 0; i < FIVE; ++i) {
        if (dice[i])
            continue;
        dice[i] = [[Die alloc] initWithPosition:CGPointMake(0.f, 0.f)
                                    andVelocity:CGVectorMake(0.f, 0.f)
                                        andSize:dieSize
                                        andMass:1.f];
        [dice[i] setTexture:[diceAtlas getClip:i]];
        [dice[i] setSize:dieSize];
        [dice[i] setZPosition:-1.f];
        [[dice[i] physicsBody] setCollisionBitMask:edgeCategory | dieCategory];
        [[dice[i] physicsBody] setContactTestBitMask:edgeCategory | dieCategory];
        [self addChild:dice[i]];
    }
    return YES;
}

-(void)showScorecard {
    [scorecardCard runAction:[SKAction fadeInWithDuration:.5f]];
    [scorecardLine runAction:[SKAction fadeInWithDuration:.5f]];
    [turnLabel runAction:[SKAction fadeInWithDuration:.5f]];
    [bonusLabel runAction:[SKAction fadeInWithDuration:.5f]];
    [bonusScoreLabel runAction:[SKAction fadeInWithDuration:.5f]];
    [totalLabel runAction:[SKAction fadeInWithDuration:.5f]];
    [totalScoreLabel runAction:[SKAction fadeInWithDuration:.5f]];
    for (int i = 0; i < nScoreNames * 2; i++)
        [scorecardLabels[i] runAction:[SKAction fadeInWithDuration:.5f]];
    scorecardVisible = YES;
}

-(void)hideScorecard {
    [scorecardCard runAction:[SKAction fadeOutWithDuration:.5f]];
    [scorecardLine runAction:[SKAction fadeOutWithDuration:.5f]];
    [turnLabel runAction:[SKAction fadeOutWithDuration:.5f]];
    [bonusLabel runAction:[SKAction fadeOutWithDuration:.5f]];
    [bonusScoreLabel runAction:[SKAction fadeOutWithDuration:.5f]];
    [totalLabel runAction:[SKAction fadeOutWithDuration:.5f]];
    [totalScoreLabel runAction:[SKAction fadeOutWithDuration:.5f]];
    for (int i = 0; i < nScoreNames * 2; i++)
        [scorecardLabels[i] runAction:[SKAction fadeOutWithDuration:.5f]];
    scorecardVisible = NO;
}

-(BOOL)selectingInitFunc {
    [cup setPosition:CGPointMake(0.f, 0.f)];
    if (turn < 2)
        [nextRollBtn runAction:[SKAction fadeInWithDuration:.5f]];
    [scorecardBtn runAction:[SKAction fadeInWithDuration:.5f]];
    [self updateScorecard];
    [self showScorecard];
    return YES;
}

-(void)startCupShake {
    static float dx = 60.f, dy = 50.f;
    static int nShakes = 10;
    NSMutableArray *actions = [NSMutableArray array];
    for (int i = 0; i < nShakes; ++i) {
        SKAction *action = [SKAction moveByX:(float)(arc4random_uniform((int)dx) - dx / 2.f)
                                           y:(float)(arc4random_uniform((int)dy) - dy / 2.f)
                                    duration:.02f];
        [action setTimingMode:SKActionTimingEaseOut];
        [actions addObject:action];
        [actions addObject:[action reversedAction]];
    }
    [cup runAction:[SKAction repeatActionForever:[SKAction sequence:actions]]
           withKey:@"cupShake"];
}

-(void)stopCupShake {
    [cup removeActionForKey:@"cupShake"];
    [cup removeActionForKey:@"cupNoise"];
    [cup runAction:[SKAction sequence:@[
        [SKAction moveTo:CGPointMake(0.f, 0.f)
                duration:.02f],
        [SKAction rotateByAngle:M_PI
                       duration:.5f],
        [SKAction waitForDuration:.3f]
    ]] completion:^{
        [self->cup runAction:[SKAction fadeOutWithDuration:1.f]];
        [self->cup runAction:[SKAction moveByX:0.f
                                             y:500.f
                                      duration:.5f]];
        self->nextStateFlag = YES;
        self->blockActions = NO;
    }];
}

-(NSArray*)sortedDice {
    return [[NSMutableArray arrayWithObjects:dice
                                       count:FIVE] sortedArrayUsingDescriptors: @[[[NSSortDescriptor alloc] initWithKey:@"value"
                                                                                                              ascending:YES]]];
}

-(int)calcScore:(int)hand {
    int score = 0;
    switch (hand) {
#define SUMOF(n) \
        case n: \
            for (int i = 0; i < FIVE; i++) \
                if ([dice[i] value] == (n + 1)) \
                    score += (n + 1); \
            break;
        SUMOF(0) // Aces
        SUMOF(1) // Duces
        SUMOF(2) // Threes
        SUMOF(3) // Fours
        SUMOF(4) // Fives
        SUMOF(5) // Sixes
        case 6: // Choice
            for (int i = 0; i < FIVE; i++)
                score += [dice[i] value];
            break;
        case 7: // Four of a kind
            for (int i = 0; i < FIVE; i++) {
                int v = [dice[i] value], n = 1, o = 0;
                for (int j = 0; j < FIVE; j++) {
                    if (i == j)
                        break;
                    if ([dice[j] value] == v)
                        n++;
                    else
                        o = [dice[j] value];
                }
                if (n >= 4) {
                    score = (n * v) + o;
                    break;
                }
            }
            break;
        case 8: { // Full house
            NSMutableDictionary *d = [NSMutableDictionary dictionary];
            for (int i = 0; i < FIVE; i++) {
                NSString *key = [@([dice[i] value]) stringValue];
                if ([d objectForKey:key])
                    d[key] = @([d[key] intValue] + 1);
                else
                    d[key] = @1;
            }
            switch ([[d allKeys] count]) {
                case 1:
                    for (int i = 0; i < FIVE; i++)
                        score += [dice[i] value];
                    break;
                case 2: {
                    BOOL y = YES;
                    for (id key in d) {
                        int v = [[d objectForKey:key] intValue];
                        if (v == 4 || v == 1) {
                            y = NO;
                            break;
                        }
                    }
                    if (y)
                        for (int i = 0; i < FIVE; i++)
                            score += [dice[i] value];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 9: { // Small straight
            NSArray *sorted = [self sortedDice];
            BOOL y = YES;
            for (int i = 0, j = 1; i < FIVE; i++, j++)
                if ([(Die*)sorted[i] value] != j) {
                    y = NO;
                    break;
                }
            if (y)
                score = 15;
            break;
        }
        case 10: { // Large straight
            NSArray *sorted = [self sortedDice];
            BOOL y = YES;
            for (int i = 0, j = 2; i < FIVE; i++, j++)
                if ([(Die*)sorted[i] value] != j) {
                    y = NO;
                    break;
                }
            if (y)
                score = 30;
            break;
        }
        case 11: { // Yatch
            int v = [dice[0] value];
            BOOL y = YES;
            for (int i = 1; i < FIVE; i++)
                if ([dice[i] value] != v) {
                    y = NO;
                    break;
                }
            if (y)
                score = 50;
            break;
        }
        default:
            abort();
    }
    return score;
}

-(void)updateScorecard {
    for (int i = 0; i < nScoreNames; ++i) {
        int v = [scorecard getScore:[scorecardLabels[i] text]];
        if (v > -1) {
            [scorecardLabels[nScoreNames + i] setFontColor:[UIColor blackColor]];
            [scorecardLabels[nScoreNames + i] setText:[NSString stringWithFormat:@"%d", v]];
        } else {
            v = [self calcScore:i];
            [hiddenScorecard setScore:scoreNames[i] withValue:v];
            [scorecardLabels[nScoreNames + i] setFontColor:[UIColor grayColor]];
            [scorecardLabels[nScoreNames + i] setText:[NSString stringWithFormat:@"%d", v]];
        }
    }
}

-(BOOL)prerollInputFunc:(UITouch*)t withEvent:(UIEvent*)e withType:(enum eventType)tt {
    switch ([e subtype]) {
        case UIEventSubtypeMotionShake:
            switch (tt) {
                case touchBegan:
                case touchMoved:
                case touchEnded:
                case touchCancelled:
                case motionCancelled:
                    break;
                case motionBegan: {
                    if ([scorecard isFull] || blockActions)
                        break;
                    blockActions = YES;
                    [self startCupShake];
                    break;
                }
                case motionEnded:
                    if (![scorecard isFull] && !blockActions)
                        [self stopCupShake];
                    break;
            }
            break;
        default:
            switch (tt) {
                case touchBegan:
                    if (blockActions) {
                        if (![scorecard isFull])
                            break;
                        // go back to menu
                        break;
                    }
                    if ([cup containsPoint:[t locationInNode:self]]) {
                        blockActions = YES;
                        [self startCupShake];
                        [self runAction:[SKAction waitForDuration:1.f] completion:^{
                            [self stopCupShake];
                        }];
                    }
                    break;
                case touchMoved:
                case touchEnded:
                case touchCancelled:
                case motionBegan:
                case motionEnded:
                case motionCancelled:
                    break;
            }
            break;
    }
    return NO;
}

-(BOOL)rollingInputFunc:(UITouch*)t withEvent:(UIEvent*)e withType:(enum eventType)tt {
    return NO;
}

-(BOOL)selectingInputFunc:(UITouch*)t withEvent:(UIEvent*)e withType:(enum eventType)tt {
    switch (tt) {
        case touchBegan:
        case touchMoved:
        case touchCancelled:
        case motionBegan:
        case motionEnded:
        case motionCancelled:
            break;
        case touchEnded:
            if ([scorecardBtn containsPoint:[t locationInNode:self]]) {
                if (scorecardVisible)
                    [self hideScorecard];
                else
                    [self showScorecard];
                break;
            }
            
            if ([nextRollBtn containsPoint:[t locationInNode:self]]) {
                if (turn >= 2 || nSelectedDice == FIVE)
                    break;
                if (scorecardVisible)
                    [self hideScorecard];
                [nextRollBtn runAction:[SKAction fadeOutWithDuration:.5f]];
                for (int i = 0; i < FIVE; i++) {
                    if (![dice[i] selected]) {
                        [dice[i] runAction:[SKAction fadeOutWithDuration:.5f] completion:^{
                            self->dice[i].physicsBody = nil;
                            [self->dice[i] removeFromParent];
                            self->dice[i] = nil;
                        }];
                    }
                }
                [cup setPosition:CGPointMake(0, 0)];
                [cup setZRotation:0];
                [hiddenScorecard reset];
                [scorecardBtn runAction:[SKAction fadeOutWithDuration:.5f] completion:^{
                    self->turn++;
                    [self->turnLabel setText:[NSString stringWithFormat:@"Turn %d", self->turn + 1]];
                    self->nextStateFlag = YES;
                }];
                break;
            }
            
            for (int i = 0; i < FIVE; ++i) {
                if (![dice[i] containsPoint:[t locationInNode:self]])
                    continue;
                static const float speed = .1f;
                if ([dice[i] selected]) {
                    [dice[i] runAction:[SKAction scaleToSize:CGSizeMake(16.f * DIESCALE, 16.f * DIESCALE)
                                                    duration:speed]];
                    [dice[i] enable];
                    [dice[i] setSelected:NO];
                    for (int j = 0; j < FIVE; ++j)
                        if (diceSelected[j] == dice[i]) {
                            diceSelected[j] = nil;
                            break;
                        }
                    nSelectedDice--;
                } else {
                    [dice[i] setSelected:YES];
                    static const float offset = (16.f * DIESCALE * 2.5f + (4 * DIESPACE));
                    static const float inc = offset / 2.5f;
                    
                    int j = 0;
                    for (; j < FIVE; ++j)
                        if (!diceSelected[j]) {
                            diceSelected[j] = dice[i];
                            break;
                        }
                    [dice[i] runAction:[SKAction moveTo:CGPointMake(DIEPOSX(j), [[UIScreen mainScreen] bounds].size.height / 1.5f)
                                               duration:speed]];
                    [dice[i] runAction:[SKAction scaleBy:1.5f
                                                duration:speed]];
                    [dice[i] runAction:[SKAction rotateByAngle:-[dice[i] zRotation]
                                                      duration:speed]];
                    [dice[i] disable];
                    nSelectedDice++;
                }
                break;
            }
            
            for (int i = 0; i < nScoreNames; i++) {
                if (![scorecardBoxes[i] containsPoint:[t locationInNode:self]])
                    continue;
                NSString *name = scoreNames[i];
                if ([scorecard getScore:name] != -1)
                    continue;
                int v = [hiddenScorecard getScore:name];
                [scorecard setScore:name withValue:v];
                turn = 0;
                [turnLabel setText:[NSString stringWithFormat:@"Turn %d", turn + 1]];
                [totalScoreLabel setText:[NSString stringWithFormat:@"%d", [scorecard scoreTotal]]];
                if ([scorecard bonusAchieved])
                    [bonusScoreLabel setText:@"35"];
                for (int i = 0; i < FIVE; i++)
                    diceSelected[i] = nil;
                nSelectedDice = 0;
                for (int i = 0; i < FIVE; i++) {
                    [dice[i] runAction:[SKAction fadeOutWithDuration:.5f] completion:^{
                        self->dice[i].physicsBody = nil;
                        [self->dice[i] removeFromParent];
                        self->dice[i] = nil;
                    }];
                }
                if (![scorecard isFull])
                    [self hideScorecard];
                else {
                    blockActions = YES;
                    [turnLabel setText:@"Final score!"];
                    [self updateScorecard];
                }
                [cup setPosition:CGPointMake(0, 0)];
                [cup setZRotation:0];
                [nextRollBtn runAction:[SKAction fadeOutWithDuration:.5f]];
                [scorecardBtn runAction:[SKAction fadeOutWithDuration:.5f] completion:^{
                    self->nextStateFlag = YES;
                }];
            }
            break;
    }
    return NO;
}

-(enum retCode)prerollUpdateFunc:(CFTimeInterval)t {
    static float tickDelayA = 0.f;
    static float tickDelayB = 0.f;
    static float tickCounterA = 0.f;
    static float tickCounterB = 0.f;
    
    if (blockActions) {
        if (tickCounterA >= tickDelayA) {
            [self runAction:[SKAction playSoundFileNamed:rndSfx('c', 3)
                                       waitForCompletion:NO]];
            tickDelayA = ((float)arc4random() / UINT32_MAX) * .25f;
            tickCounterA = 0.f;
        }
        if (tickCounterB >= tickDelayB) {
            [self runAction:[SKAction playSoundFileNamed:rndSfx('d', 7)
                                       waitForCompletion:NO]];
            tickDelayB = ((float)arc4random() / UINT32_MAX) * .15f;
            tickCounterB = 0.f;
        }
        tickCounterA += t;
        tickCounterB += t;
    }
    
    enum retCode ret = repeat;
    if (nextStateFlag) {
        tickDelayA = tickCounterA = tickDelayB = tickCounterB = 0.f;
        ret = ok;
        nextStateFlag = NO;
    }
    return ret;
}

-(enum retCode)rollingUpdateFunc:(CFTimeInterval)t {
    static float maxTime = 2.f;
    static float tickCounter = 0.f;
    static float delayCounter = 0.f;
    static float tickDelay = 0.f;
    
    if (delayCounter > tickDelay) {
        for (int i = 0; i < FIVE; ++i)
            if (![dice[i] selected])
                [dice[i] setTexture:[diceAtlas getClip:6 + dieRoll()]];
        tickDelay = lerp(0.f, .25f, tickCounter / maxTime);
        delayCounter = 0.f;
    }
    
    if (tickCounter >= maxTime) {
        for (int i = 0; i < FIVE; ++i) {
            if ([dice[i] selected])
                continue;
            int v = dieRoll();
            [dice[i] setTexture:[diceAtlas getClip:v]];
            [dice[i] setValue:v + 1];
        }
        tickCounter = delayCounter = tickDelay = 0.f;
        return ok;
    }
    
    tickCounter += t;
    delayCounter += t;
    
    for (SKPhysicsContact* contact in [contactQueue copy]) {
        [self handleContact:contact];
        [contactQueue removeObject:contact];
    }
    return repeat;
}

-(enum retCode)selectingUpdateFunc:(CFTimeInterval)t {
    enum retCode ret = repeat;
    if (nextStateFlag) {
        ret = ok;
        nextStateFlag = NO;
    }
    return ret;
}

-(void)update:(CFTimeInterval)currentTime {
    CFTimeInterval delta = currentTime - lastTimeInterval;
    lastTimeInterval = currentTime;
    
    enum retCode ret = fail;
    switch (state) {
#define X(a) \
        case a: \
            ret = [self a##UpdateFunc:delta]; \
            break;
        STATES
#undef X
        default: // unknown state, abort
            abort();
    }
    switch (ret) {
        case repeat: // do nothing, repeat
            break;
        case ok: { // state finished, find next
            BOOL found = NO;
            int i = 0;
            for (; i < nTransitions; ++i)
                if (state == transitions[i]) {
                    found = YES;
                    break;
                }
            if (!found) // No new state found
                abort();
            switch (state = transitions[i + 1 == nTransitions ? 0 : i + 1]) {
#define X(a) \
                case a: \
                    if (![self a##InitFunc]) \
                        abort(); \
                        break;
                STATES
#undef X
            }
            break;
        }
        case fail: // error, abort
        default:
            abort();
    }
}

-(void)didBeginContact:(SKPhysicsContact*)contact {
    [contactQueue addObject:contact];
}

-(void)handleContact:(SKPhysicsContact*)contact {
    if ([[contact bodyA] categoryBitMask] == dieCategory &&
        [[contact bodyB] categoryBitMask] == dieCategory)
        [self runAction:[SKAction playSoundFileNamed:rndSfx('d', 7) waitForCompletion:NO]];
    else if (([[contact bodyA] categoryBitMask] == edgeCategory &&
              [[contact bodyB] categoryBitMask] == dieCategory) ||
             ([[contact bodyA] categoryBitMask] == dieCategory &&
              [[contact bodyB] categoryBitMask] == edgeCategory))
        [self runAction:[SKAction playSoundFileNamed:rndSfx('e', 7) waitForCompletion:NO]];
}
@end
