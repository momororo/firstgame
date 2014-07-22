//
//  ViewController.m
//  FirstGame
//
//  Created by 新井脩司 on 2014/05/20.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import "ViewController.h"
#import "GameView.h"

@implementation ViewController{
    __weak GameView* _gameView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //ゲームセンターの認証
    //[self authenticateLocalPlayer];
    
    _gameView = (GameView *)self.view;
     //Present the scene.
    

}

/**
 * GameCenterにログインしているか確認処理
 * ログインしていなければログイン画面を表示
 */
/*
- (void)authenticateLocalPlayer
{
    GKLocalPlayer* player = [GKLocalPlayer localPlayer];
    player.authenticateHandler = ^(UIViewController* ui, NSError* error )
    {
        if( nil != ui )
        {
            [self presentViewController:ui animated:YES completion:nil];
        }
        
    };
}

*/
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
