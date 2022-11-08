//
//  GameViewController.m
//  yatch
//
//  Created by Rory B. Bellows on 19/09/2021.
//  Copyright © 2021 Rory B. Bellows. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@implementation GameViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [self becomeFirstResponder];

    // Load the SKScene from 'GameScene.sks'
    GameScene *scene = (GameScene*)[SKScene nodeWithFileNamed:@"GameScene"];
    
    // Set the scale mode to scale to fit the window
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    SKView *skView = (SKView*)self.view;
    
    // Present the scene
    [skView presentScene:scene];
    
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
}

- (BOOL)canBecomeFirstResponder{
    return true;
}

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent*)event{
    [[(SKView*)[self view] scene] motionBegan:motion withEvent:event];
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent*)event{
    [[(SKView*)[self view] scene] motionEnded:motion withEvent:event];
}

-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent*)event{
    [[(SKView*)[self view] scene] motionCancelled:motion withEvent:event];
}

-(BOOL)shouldAutorotate {
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

@end
