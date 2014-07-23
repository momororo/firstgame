//
//  MyScene.h
//  FirstGame
//

//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <GameKit/GameKit.h>
#import <AVFoundation/AVFoundation.h>
#import "NADView.h"

@interface TitleScene : SKScene <GKGameCenterControllerDelegate,NADViewDelegate>
@property (weak, nonatomic)id delegate;
@property (nonatomic, strong) AVAudioPlayer * musicPlayer1;
@property (nonatomic, retain) NADView *nadView;


@end
