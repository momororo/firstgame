//
//  GameScene.h
//  FirstGame
//
//  Created by 新井脩司 on 2014/05/20.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Player.h"
#import "Ground.h"
#import "Wall.h"
#import "Sensor.h"
#import "Sea.h"
#import "Fish.h"
#import "Island.h"
#import "Cloud.h"
#import "Emergency.h"
#import <GameKit/GameKit.h>
#import "NADView.h"
#import <AVFoundation/AVFoundation.h>
#import <MrdIconSDK/MrdIconSDK.h>


#define     kPlayer     @"Player"
#define     kGround     @"Ground"
#define     kWall       @"Wall"
#define     kFish       @"Fish"


@interface GameScene : SKScene <SKPhysicsContactDelegate,NADViewDelegate>

@property (weak,nonatomic)id delegate;
@property (nonatomic, retain) NADView *nadView;
@property (nonatomic, strong) AVAudioPlayer *musicPlayer1;
@property (nonatomic, strong) AVAudioPlayer *musicPlayer2;

@end
