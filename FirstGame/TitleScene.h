//
//  MyScene.h
//  FirstGame
//

//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <GameKit/GameKit.h>

@interface TitleScene : SKScene <GKGameCenterControllerDelegate>
@property (weak, nonatomic)id delegate;

@end
