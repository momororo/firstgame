//
//  MyScene.m
//  FirstGame
//
//  Created by 新井脩司 on 2014/05/20.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import "TitleScene.h"
#import "GameView.h"
#import "AppDelegate.h"


//スタートボタン
SKSpriteNode *start;
//チュートリアルボタン
SKSpriteNode *tutorial;
//ランキングボタン
SKSpriteNode *ranking;
//チュートリアルのネクストボタン
SKSpriteNode *next;
//チュートリアルのバックボタン
SKSpriteNode *previous;
//チュートリアルの解説テキスト枠
SKLabelNode  *tutorialLabel;
//チュートリアルの背景
SKSpriteNode *tutorialBackGround;
//チュートリアルの画像
SKSpriteNode *tutorialImage;
SKSpriteNode *tutorialImage2;
SKSpriteNode *tutorialImage3;
//看板の画像
SKSpriteNode *kanban;

//チュートリアルフラグ
bool tutorialFlag;
//チュートリアルのページ
int tutorialPage;

@implementation TitleScene{

//BOOL touch;

GKLocalPlayer *localPlayer;
    
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
                
        //背景画像の設定
        SKSpriteNode *top = [SKSpriteNode spriteNodeWithImageNamed:@"top.png"];
        top.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
        top.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:top];
        
        //スタートボタンの設定
        start = [SKSpriteNode spriteNodeWithImageNamed:@"start.png"];
        start.size = CGSizeMake(start.size.width/3, start.size.height/3);
        start.position = CGPointMake(CGRectGetMaxX(self.frame)-start.size.width/2, CGRectGetMidY(self.frame));
        [self addChild:start];
        
        //遊び方ボタンの設定
        tutorial = [SKSpriteNode spriteNodeWithImageNamed:@"tutorial.png"];
        tutorial.size = CGSizeMake(tutorial.size.width/3, tutorial.size.height/3);
        tutorial.position = CGPointMake(CGRectGetMaxX(self.frame)*4/5,CGRectGetMaxY(self.frame)-tutorial.size.height/1.5);
        [self addChild:tutorial];
        
        //ランキングボタンの設定
        ranking = [SKSpriteNode spriteNodeWithImageNamed:@"ranking.png"];
        ranking.name = @"kRanking";
        ranking.size = CGSizeMake(ranking.size.width/3, ranking.size.height/3);
        ranking.position = CGPointMake(CGRectGetMaxX(self.frame)-ranking.size.width/2 ,ranking.size.height);
        [self addChild:ranking];
        
        //ハイスコアのラベルの影
        SKLabelNode *scoreLabel;
        scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Impact"];
        scoreLabel.text = @"High Score";
        scoreLabel.fontSize = 28;
        scoreLabel.fontColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        scoreLabel.position = CGPointMake(CGRectGetMaxX(self.frame)/7,CGRectGetMidY(self.frame)*3/5);
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        [self addChild:scoreLabel];
        
        //ハイスコアのラベル(青)
        SKLabelNode *scoreLabel1;
        scoreLabel1 = [SKLabelNode labelNodeWithFontNamed:@"Impact"];
        scoreLabel1.text = @"High Score";
        scoreLabel1.fontSize = 28;
        scoreLabel1.fontColor = [UIColor colorWithRed:0.1 green:0.4 blue:1 alpha:1];
        scoreLabel1.position = CGPointMake(-2,2);
        scoreLabel1.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        scoreLabel1.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        [scoreLabel addChild:scoreLabel1];
        
        //ハイスコアラベルのアンダーライン
        SKSpriteNode *line1 = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8] size:CGSizeMake(CGRectGetMidX(self.frame)*2/3, CGRectGetMidY(self.frame)/40)];
        line1.position = CGPointMake(0, -10);
        [scoreLabel addChild:line1];
        
        SKSpriteNode *line2 = [SKSpriteNode spriteNodeWithColor:[UIColor yellowColor] size:CGSizeMake(CGRectGetMidX(self.frame)*2/3, CGRectGetMidY(self.frame)/80)];
        line2.position = CGPointMake(-3, -9);
        [scoreLabel addChild:line2];
    
        
    //ハイスコア数値のラベルを看板に
        
        //ハイスコア読込
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        float score = [userDefaults floatForKey:@"score"];
        
        SKLabelNode *scoreLabelValue;
        scoreLabelValue = [SKLabelNode labelNodeWithFontNamed:@"Impact"];
        scoreLabelValue.text = [NSString stringWithFormat:@"%.1fpt",score];
        scoreLabelValue.fontSize = 28;
        scoreLabelValue.fontColor = [UIColor blackColor];
        scoreLabelValue.position = CGPointMake(CGRectGetMaxX(self.frame)/6,CGRectGetMidY(self.frame)*2/5);
        scoreLabelValue.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        scoreLabelValue.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        [self addChild:scoreLabelValue];
        
        
        //チュートリアルのページを0にする
        tutorialPage = 0;
        
        //BGMの再生
        NSError *error;
        NSURL *url1 = [[NSBundle mainBundle] URLForResource:@"titlemusic" withExtension:@"mp3"];
        self.musicPlayer1 = [[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:&error];
        self.musicPlayer1.numberOfLoops = -1;
        [self.musicPlayer1 prepareToPlay];
        [self.musicPlayer1 play];
        
        
        
        //GameCenter認証
        [self authenticateLocalPlayer];
        
        
        //ログ出力の設定
        self.nadView.isOutputLog = NO;
        

        
        
    }
    
    /**
     *  nend
     */
    //nadViewの生成
    self.nadView = [[NADView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame) - 50 , 320, 50)];
    
    //setapiKey
    [self.nadView setNendApiKey:@"729d726062b8ed26a2191936a39237d18f1c7883"];
    [self.nadView setNendSpotID:@"207219"];
    [self.nadView setDelegate:self];
    [self.nadView load];

    
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    //タップした座標を取得する
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    //スタートノードをタップした時の命令
    if ([start containsPoint:location]) {
        //チュートリアル表示時は反応しない
        if(tutorialFlag == NO){
            
            /**
             *  nend終了(viewから削除するときは加えてremoveFromSuperViewも唱えよう)
             */
            [self.nadView setDelegate:nil];
            [self.nadView removeFromSuperview];
            self.nadView = nil;
            
            if ([self.delegate respondsToSelector:@selector(sceneEscape:identifier:)]) {
                [self.delegate sceneEscape:self identifier:nil];
                
                //BGMの停止
                [self.musicPlayer1 stop];
                
                return;
                
            }
        }
    }
    
    //ランキング
    if([ranking containsPoint:location]){
        

        // Leader Board表示
        [self showGameCenter];
        
        return;
         

    }
    
    /*
     *  チュートリアルの作成ページ
     *  チュートリアルのフラグNOでかつページが0ページの時に処理が行われる
     */
    if ([tutorial containsPoint:location]) {
        
        if(tutorialFlag == NO){
            
            [self showTutorial];
            return;
            
        }
    }
    
    
    //チュートリアルのイメージ枠が表示された時に行える処理
    if ([self childNodeWithName:@"kTutorialBackGround"]) {
        CGPoint location = [touch locationInNode:tutorialBackGround];
        
        
        //ネクストボタンの動き
        if ([[tutorialBackGround childNodeWithName:@"kNext"] containsPoint:location]) {
            
            if(tutorialFlag == YES){
                
                //1ページ目から2ページに変更
                if (tutorialPage == 1) {
                    
                    [self showSecondPage];
                    return;
                    
                }
                
                //2ページ目から3ページに変更
                
                if (tutorialPage == 2) {
                    [self showThirdPage];
                    return;
                }
                
                //2ページ目から3ページに変更
                if (tutorialPage == 3) {
                    [self showFourthPage];
                    return;
                }
                
            }
            
        }
        
        //バックボタンの動き
        if([[tutorialBackGround childNodeWithName:@"kPrevious"] containsPoint:location]){
            
            if(tutorialFlag == YES){
                
                //1ページ目からの変更は処理を行わない
                if(tutorialPage == 1){
                    //処理なし
                    return;
                }
                
                //2ページ目から1ページに変更
                if(tutorialPage == 2){
                    [self showFirstPage];
                    return;
                }
                
                //3ページ目から2ページ目に変更
                if(tutorialPage == 3){
                    [self showSecondPage];
                    return;
                }
                
                //4ページ目から3ページ目に変更
                if(tutorialPage == 4){
                    [self showThirdPage];
                    return;
                }
        
            }
        
        }
    }
    
    //チュートリアルのイメージ枠を消去
    if (![tutorialBackGround containsPoint:location]) {
        if(tutorialFlag == YES){
            //チュートリアルのノードを破棄する
            [self hiddenTutorial];
            return;
            
        }
    }
}
    
    

//チュートリアルの作成メソッド
-(void)showTutorial{
    
    //イメージ枠の追加
    tutorialBackGround = [SKSpriteNode spriteNodeWithImageNamed:@"image.png"];
    tutorialBackGround.name = @"kTutorialBackGround";
    tutorialBackGround.size = CGSizeMake(tutorialBackGround.size.width/1.2, tutorialBackGround.size.height/1.2);
    tutorialBackGround.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)/1.3);
    tutorialBackGround.zPosition = 10;
    [self addChild:tutorialBackGround];
    
    
    //テキスト枠の追加
    tutorialLabel = [SKLabelNode labelNodeWithFontNamed:@"SetoFont-SP"];
    tutorialLabel.fontSize = 18;
    tutorialLabel.fontColor = [SKColor blackColor];
    tutorialLabel.position = CGPointMake(0,-20);
    [tutorialBackGround addChild:tutorialLabel];

    //ネクストボタンの追加
    next = [SKSpriteNode spriteNodeWithImageNamed:@"next.png"];
    next.name = @"kNext";
    next.size = CGSizeMake(next.size.width, next.size.height);
    next.position = CGPointMake(155,70);
    [tutorialBackGround addChild:next];
    
    //バックボタンの追加
    previous = [SKSpriteNode spriteNodeWithImageNamed:@"previous.png"];
    previous.name = @"kPrevious";
    previous.size = CGSizeMake(previous.size.width, previous.size.height);
    previous.position = CGPointMake(-155,70);
    [tutorialBackGround addChild:previous];

    //1ページ目を作成
    [self showFirstPage];

    
    //チュートリアルフラグをONに変更
    tutorialFlag = YES;
}

//チュートリアルページの削除メソッド
-(void)hiddenTutorial{
    
    [tutorialBackGround removeFromParent];
    tutorialBackGround = nil;

    //チュートリアルのフラグをNOにする
    tutorialFlag = NO;
    
    //ページを0ページに戻す
    tutorialPage = 0;


    
}


//1ページ目の作成メソッド

-(void)showFirstPage{
    
    [tutorialImage removeFromParent];
    [previous setHidden:YES];
    
    tutorialImage = nil;
    tutorialImage = [SKSpriteNode spriteNodeWithImageNamed:@"tutorial1.jpg"];
    tutorialImage.size = CGSizeMake(tutorialImage.size.width/4.5, tutorialImage.size.height/4.5);
    tutorialImage.position = CGPointMake(0, 70);
    [tutorialBackGround addChild:tutorialImage];

    //テキストの差し替え
    tutorialLabel.text = @"画面タップでジャンプ！！";
    
    //ページを1に変更
    tutorialPage = 1;
    
    return;
    
}

//2ページ目の作成メソッド

-(void)showSecondPage{
    
    [previous setHidden:NO];

    //画像の差し替え
    [tutorialImage3 removeFromParent];
    [tutorialImage2 removeFromParent];
    [tutorialImage removeFromParent];
    tutorialImage = nil;
    tutorialImage = [SKSpriteNode spriteNodeWithImageNamed:@"tutorial2.jpg"];
    tutorialImage.size = CGSizeMake(tutorialImage.size.width/4.5, tutorialImage.size.height/4.5);
    tutorialImage.position = CGPointMake(0, 70);
    [tutorialBackGround addChild:tutorialImage];

    
    //テキストの差し替え
    tutorialLabel.text =@"ジャンプ中、タップでスマッシュ！！";
    
    //ページを2に変更
    tutorialPage = 2;
    
    return;

}

//3ページ目の作成メソッド

-(void)showThirdPage{
    
    [next setHidden:NO];
    
    //画像の差し替え
    [tutorialImage removeFromParent];
    tutorialImage = nil;
    tutorialImage = [SKSpriteNode spriteNodeWithImageNamed:@"tutorial3_1.jpg"];
    tutorialImage.size = CGSizeMake(tutorialImage.size.width/4.5, tutorialImage.size.height/4.5);
    tutorialImage.position = CGPointMake(-80, 70);
    [tutorialBackGround addChild:tutorialImage];
    
    tutorialImage2 = [SKSpriteNode spriteNodeWithImageNamed:@"tutorial3_2.jpg"];
    tutorialImage2.size = CGSizeMake(tutorialImage2.size.width/4, tutorialImage2.size.height/4);
    tutorialImage2.position = CGPointMake(80, 70);
    [tutorialBackGround addChild:tutorialImage2];
    
    tutorialImage3 = [SKSpriteNode spriteNodeWithImageNamed:@"yajirusi.png"];
    tutorialImage3.size = CGSizeMake(tutorialImage3.size.width/10, tutorialImage3.size.width/10);
    tutorialImage3.position = CGPointMake(0, 70);
    [tutorialBackGround addChild:tutorialImage3];
    
    
    
    //テキストの差し替え
    tutorialLabel.text =@"スマッシュで氷のカベをこわせ！！";
    
    //ページを2に変更
    tutorialPage = 3;
    
    return;
    
}

//4ページ目作成

-(void)showFourthPage{
    
    [next setHidden:YES];
    
    //画像の差し替え
    [tutorialImage removeFromParent];
    [tutorialImage2 removeFromParent];
    [tutorialImage3 removeFromParent];
    
    tutorialImage = nil;
    tutorialImage = [SKSpriteNode spriteNodeWithImageNamed:@"tutorial4.PNG"];
    tutorialImage.size = CGSizeMake(tutorialImage.size.width/4.5, tutorialImage.size.height/4.5);
    tutorialImage.position = CGPointMake(0, 70);
    [tutorialBackGround addChild:tutorialImage];
    
    //テキストの差し替え
    tutorialLabel.text =@"氷のカベを５つこわすと･･･空が飛べる！！";
    
    //ページを2に変更
    tutorialPage = 4;
    
    return;
    
}














-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

/**********************************************************************************************
 *********************************   ゲームセンター認証設定   *************************************
 **********************************************************************************************/


//GameCenter認証
-(void)authenticateLocalPlayer{
    __weak typeof (self) weakSelf = self;
    
    localPlayer = [GKLocalPlayer localPlayer];
    __weak GKLocalPlayer *weakPlayer = localPlayer;
    
    weakPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error)
    {
        if (viewController != nil) // LOGIN
        {
            [weakSelf showAuthenticationDialogWhenReasonable:viewController];
            NSLog(@"ログイン試行");
        }
        else if (weakPlayer.isAuthenticated) // LOGIN済
        {
            [weakSelf authenticatedPlayer:weakPlayer];
            NSLog(@"ログイン成功");

        }
        else
        {
            [weakSelf disableGameCenter];
            NSLog(@"ログイン失敗");

        }
    };
    
}

// GameCenter認証画面
-(void)showAuthenticationDialogWhenReasonable:(UIViewController *)controller
{
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:controller animated:YES completion:nil];
}

// GameCenter認証OK
-(void)authenticatedPlayer:(GKLocalPlayer *)player
{
    player = localPlayer;
    AppDelegate *appDelegete = [[UIApplication sharedApplication] delegate];
    appDelegete.localPlayer = localPlayer;
}

// GameCenter認証NG
-(void)disableGameCenter
{
    
}

// Leader Boardの表示
-(void)showGameCenter{
    
    
    GKGameCenterViewController* gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil)
    {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
        
        UIViewController *vc = self.view.window.rootViewController;
        [vc presentViewController: gameCenterController animated: YES completion:nil];
    }
    
}

// Leader Boardが閉じたとき呼ばれる
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] dismissViewControllerAnimated:YES completion:nil];
}

//広告受信成功後、viewに追加
-(void)nadViewDidFinishLoad:(NADView *)adView{
    //デバッグ用、後で消す
    [self.view addSubview:adView];
}

//広告受信失敗(あとで消す)
-(void)nadViewDidFailToReceiveAd:(NADView *)adView{
}


@end