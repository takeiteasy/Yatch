//
//  MenuScene.m
//  yatch
//
//  Created by George Watson on 10/11/2022.
//  Copyright © 2022 Rory B. Bellows. All rights reserved.
//

#import "MenuScene.h"

@implementation MenuScene
-(void)didMoveToView:(SKView *)view {
    title = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Bold"];
    [title setText:@"Yatch!"];
    [title setFontSize:72.f];
    [title setAlpha:0.f];
    [self addChild:title];
    [title runAction:[SKAction fadeInWithDuration:1.f]];
    [title runAction:[SKAction moveByX:0.f y:200.f duration:1.f]];
    
    const float buttonHeight = 100.f;
    const float buttonWidth = buttonHeight * 1.6180339887f;
    playButton = [SKShapeNode shapeNodeWithRect:CGRectMake(-buttonWidth / 2.f, -buttonHeight / 3.5f, buttonWidth, buttonHeight)
                                   cornerRadius:3.f];
    [playButton setFillColor:[UIColor lightGrayColor]];
    [playButton setAlpha:0.f];
    [self addChild:playButton];
    [playButton runAction:[SKAction sequence:@[
        [SKAction waitForDuration:.75f],
        [SKAction fadeInWithDuration:1.f]
    ]]];
    playLabel = [SKLabelNode labelNodeWithText:@"Play"];
    [playLabel setFontSize:56.f];
    [playLabel setAlpha:0.f];
    [self addChild:playLabel];
    [playLabel runAction:[SKAction sequence:@[
        [SKAction waitForDuration:1.f],
        [SKAction fadeInWithDuration:1.f]
    ]]];
    
    highscoreLabel = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Bold"];
    [highscoreLabel setText:[NSString stringWithFormat:@"Highscore: %d", 0]];
    [highscoreLabel setPosition:CGPointMake(0.f, -200.f)];
    [highscoreLabel setAlpha:0.f];
    [self addChild:highscoreLabel];
    [highscoreLabel runAction:[SKAction sequence:@[
        [SKAction waitForDuration:1.25f],
        [SKAction fadeInWithDuration:1.f]
    ]]];
}

-(void)touchDownAtPoint:(CGPoint)pos {
}

-(void)touchMovedToPoint:(CGPoint)pos {
}

-(void)touchUpAtPoint:(CGPoint)pos {
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  for (UITouch *t in touches) {[self touchDownAtPoint:[t locationInNode:self]];}
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
  for (UITouch *t in touches) {[self touchMovedToPoint:[t locationInNode:self]];}
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  for (UITouch *t in touches) {
      if ([playButton containsPoint:[t locationInNode:self]]) {
          GameScene *scene = (GameScene*)[SKScene nodeWithFileNamed:@"GameScene"];
          [scene setScaleMode:SKSceneScaleModeAspectFill];
          [[self view] presentScene:scene
                         transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];
      } else
          [self touchUpAtPoint:[t locationInNode:self]];
  }
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}

-(void)update:(CFTimeInterval)currentTime {
}
@end
