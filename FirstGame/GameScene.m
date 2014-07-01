//
//  GameScene.m
//  FirstGame
//
//  Created by 新井脩司 on 2014/05/20.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import "GameScene.h"
#import "GameView.h"

@import AVFoundation;



@implementation GameScene{
//@property (nonatomic, strong) AVAudioPlayer * musicPlayer1;

AVAudioPlayer * musicPlayer1;
    AVAudioPlayer * musicPlayer2;

    
//ゲームスタートのフラグ
BOOL gameStart;

//ゲームスタートの時間を記録する変数
NSDate *startTime;
    
//スタートのラベル
SKLabelNode *startLabel;
    
//スコアのラベル
SKLabelNode *scoreLabel;
    
//魚を食べた時の加点
int fishPoint;
    
//スコア
float score;

//飛行時間のラベル
SKLabelNode *flyingLabel;
    
//飛行開始のラベル
SKLabelNode *startFlyingLabel;
    
//パーティクル（炎）
SKEmitterNode *_particleFire;
//パーティクル（スパーク）
SKEmitterNode *_particleSpark;

//魚追加中のフラグ
BOOL fishAdd;
    
//プレイヤーと地面の接地フラグ
BOOL playerAndGroundContactFlag;
    
    
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        //メイン画面
       SKSpriteNode *haikei = [SKSpriteNode spriteNodeWithImageNamed:@"haikei.png"];
        haikei.size = CGSizeMake(haikei.size.width, haikei.size.height);
        haikei.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 10);
        [self addChild:haikei];
  

 
        
        startLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        startLabel.text = @"GAME START";
        startLabel.fontSize = 30;
        startLabel.name = @"kStartLabel";
        startLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        [self addChild:startLabel];

        
        //スコアラベル
        fishPoint = 0;
        scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        scoreLabel.text = @"SCORE = 0";
        scoreLabel.fontSize = 20;
        scoreLabel.fontColor = [UIColor redColor];
        scoreLabel.name = @"kScoreLabel";
        scoreLabel.zPosition = 50;
        scoreLabel.position = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame)-(CGRectGetMaxY(self.frame)/10));
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        [self addChild:scoreLabel];

        
        //海
        [Sea setSeaFrame:self.frame];
        [self addChild:[Sea getSea]];
        
        //波
        SKSpriteNode *nami = [SKSpriteNode spriteNodeWithImageNamed:@"nami.png"];
        nami.position = CGPointMake(CGRectGetMidX(self.frame),sea.size.height/2);
        [self addChild:nami];
        
        //背景の島
        [Island initTexture];
        [Island setIslandInitFrame:self.frame];
        NSMutableArray *islands = [Island getIslandInit];
        [self addChild:islands[0]];
        [self addChild:islands[1]];
        
        //背景の雲
        [Cloud initTexture];
        [Cloud setCloudInitFrame:self.frame];
        NSMutableArray *clouds = [Cloud getCloudInit];
        [self addChild:clouds[0]];
        [self addChild:clouds[1]];
        
        
        //透明のオブジェクトを生成(センサー)
        [Sensor setSensoFrame:self.frame];
        [self addChild:[Sensor getSensor]];
        
        //地面の設定
        [Ground initGroundTexture];
        [Ground setGroundSizeX:ground.size.width sizeY:ground.size.height];
        [self addChild:[Ground getGround]];
        
        //壁の設定(初期化)
        [Wall initWalls];
        [Wall initTexture];
        
        
        //プレイキャラの設定
        [Player initTexture];
        [Player setPlayerPositionX:CGRectGetMidX(self.frame)/2 positionY:100];
        [self addChild:[Player getPlayer]];
        
        //魚の設定
        [Fish initTexture];
        
        //接触デリゲート
        self.physicsWorld.contactDelegate = self;
        
        
    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //ゲームスタートが押されたらボタンを消去する
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    
    
    //スタートラベルがノードにあるときだけ入る処理
    if([self childNodeWithName:@"kStartLabel"]){
        if ([startLabel containsPoint:location]) {
            
            //スタートボタンがタップされたら、地面が移動する
            [Ground moveGroundToX:(-300 - (self.frame.size.width / 2)) duration:3.0];
            [Island moveIslandInit];
            [Cloud moveCloudInit];

            //スタートラベルの削除
            [startLabel removeFromParent];
            
            //ゲームスタートフラグをYESに
            gameStart = YES;
            
            
            
           //プレイヤー歩行開始
            [Player walkAction];
            
            //秒数を記録
            startTime = [NSDate date];
            
            
            //BGM再生
            NSError *error;
            NSURL *url1 = [[NSBundle mainBundle] URLForResource:@"backmusic" withExtension:@"mp3"];
            self->musicPlayer1 = [[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:&error];
            self->musicPlayer1.numberOfLoops = -1;
            [musicPlayer1 prepareToPlay];
            [self->musicPlayer1 play];
        
            return;
        }
        return;
    }
    
    
    //GameOverラベルがノードにあるときだけ入る処理
    if([self childNodeWithName:@"kGameOver"]){
        
        //
            if ([[self childNodeWithName:@"kRetryLabel"] containsPoint:location]) {
                //ゲームシーン画面に飛ぶ
                if ([_delegate respondsToSelector:@selector(sceneEscape:identifier:)]) {
                    [_delegate sceneEscape:self identifier:@"retry"];
                    [self->musicPlayer2 stop];

                }
            }
           
           if ([[self childNodeWithName:@"kTopLabel"] containsPoint:location]) {
               //ゲームシーン画面に飛ぶ
               if ([_delegate respondsToSelector:@selector(sceneEscape:identifier:)]) {
                [_delegate sceneEscape:self identifier:@"top"];
                   [self->musicPlayer2 stop];
               }
           }
        return;
    }

    
    

    //ジャンプ or スマッシュ
    [Player jumpOrSmashAction];
    //接地フラグOFF（念のため）    
    playerAndGroundContactFlag = NO;

    
}

//オブジェクト同士が衝突した場合に動く処理
- (void)didBeginContact:(SKPhysicsContact *)contact
{
 
    //スタートラベルがある時は処理を飛ばす
    if([self childNodeWithName:@"kStartLabel"] != nil){
        return;
    }
    
    
 
	/**********プレイヤーと地面の衝突を検知**********/
    if([ObjectBitMask playerAndGround:contact]){
        

        //地面を格納する変数
        SKNode *ground = [ObjectBitMask getGroundFromContact:contact];
        
        //接触位置 + 2 >= 地面の上面
        if( contact.contactPoint.y + 1 >= (ground.position.y) + ([ground calculateAccumulatedFrame].size.height/8) ){
            
            /**
             *  小細工
             *  フラグがONになっている状態でここの処理に来た場合、挙動が怪しいと思われるので。
             *  フラグをOFFにします。
             */
            if(playerAndGroundContactFlag == YES){
                playerAndGroundContactFlag = NO;
                return;
            }
            
                playerAndGroundContactFlag = YES;

            
            //player歩行動作
                [Player walkAction];
                
            
        }
        
        return;
        
    }
     
    
	/**********プレイヤーと地面の衝突を検知終了**********/

    

    /**********地面と飛行キャラクターの衝突を検知**********/
    if([ObjectBitMask flyingPlayerAndGround:contact]){
        
        //地面を格納する変数
        SKNode *ground = [ObjectBitMask getGroundFromContact:contact];
        
        //接触位置 + 2 >= 地面の上面
        if( contact.contactPoint.y + 1 >= (ground.position.y) + ([ground calculateAccumulatedFrame].size.height/8) ){

            
            //player歩行動作
            [Player walkAction];
            
        
        }
        
        return;
    }
     
    
    /**********地面と飛行キャラクターの衝突を検知終了**********/


    /**********プレイヤーと壁の衝突を検知**********/
       if([ObjectBitMask flyingPlayerAndWall:contact]){
           
           //壁の消滅
           [Wall removeAttackedWall:[ObjectBitMask getWallFromContact:contact]];
           //パーティクルの発生
           [self makeSparkParticle:contact.contactPoint];
           [self runAction:bombSE];


           //player歩行動作
           [Player walkAction];
           //カウントアップ
           [Player countUpFlyPoint];
           
           return;
           
       }
    
    /**********プレイヤーと壁の衝突を検知終了**********/
    
    
    /**********プレイヤーと魚の衝突を検知**************/
    if ([ObjectBitMask playerAndFish:contact]) {
        //魚の消滅
        [Fish removeEatenFish:[ObjectBitMask getFishFromContact:contact]];
        //魚加点
        fishPoint = fishPoint + 8;
        return;
    }
   
    
}


//オブジェクト同士が離れた際の処理
- (void)didEndContact:(SKPhysicsContact *)contact
{
    
    /**********プレイヤーと地面が離れるのを検知**********/
    if([ObjectBitMask playerAndGround:contact]){
        //接地フラグOFF

        playerAndGroundContactFlag = NO;
        [Player setJumpFlagOff];
        return;
    }
    /**********プレイヤーと地面が離れるのを検知終了**********/

    /**********フライングプレイヤーと地面が離れるのを検知**********/
    if([ObjectBitMask flyingPlayerAndGround:contact]){


        playerAndGroundContactFlag = NO;

        return;
    }
    /**********フライングプレイヤーと地面が離れるのを検知終了**********/

    
    /**********センサーと地面が離れるのを検知**********/
    if([ObjectBitMask sensorAndGround:contact]){
        
        
    //スコア200までは壁が出ず
        if(score < 20){
            //nextGroundの生成
                [Ground setNextGroundPositionX:self.frame.size.width];
                [self addChild:[Ground getNextGround]];
                
                
                //nextGroundの動作
                [Ground moveNextGroundDuration:4.0];
            
            return;

        }
        
    //スコアが1000までは壁が3分の1の確率で出る
        if(score < 1000){
            //nextGroundの生成
            [Ground setNextGroundPositionX:self.frame.size.width];
            [self addChild:[Ground getNextGround]];
            
            
            //nextGroundの動作
            [Ground moveNextGroundDuration:3.8];
            
            
            if(arc4random_uniform(3) == 0){
                //nextGroundを基に壁を生成
                [Wall setWallFromNextGround:[Ground getNextGround]];
                [self addChild:[Wall getWall]];
            
                //wallの動作
                [Wall moveWallDuration:3.8];
            
                return;
            }
        }

        
    //スコアが1000以上は常に壁が出てスコアに応じて速度アップ
        
        if (score >= 1000) {

            //nextGroundの生成
            [Ground setNextGroundPositionX:self.frame.size.width];
            [self addChild:[Ground getNextGround]];
            
            
            //速度可変用の変数
            float duration = 3.5 - (score / 2500) ;
 

            //nextGroundの動作
            [Ground moveNextGroundDuration:duration];
            

            if(arc4random_uniform(2) == 0){
                
                
                //nextGroundを基に壁を生成
                [Wall setWallFromNextGround:[Ground getNextGround]];
                [self addChild:[Wall getWall]];
                
                
                //wallの動作
                [Wall moveWallDuration:duration];
                
                return;
            
            }
        
        }
    }
    
    
    /**********センサーと地面が離れるのを検知終了**********/


    
}

//1フレーム毎に動作するメソッド
-(void)didSimulatePhysics{
    
    if(gameStart == NO){
        return;
    }
    
    
//SCOREの更新
    if(gameStart == YES){
        
    score = [[NSDate date] timeIntervalSinceDate:startTime] * 2 + fishPoint;
    scoreLabel.text = [NSString stringWithFormat:@"SCORE = %.1f",score];
 
    }
    
//プレイヤーをスタート地点まで戻す処理
    if(playerAndGroundContactFlag == YES){
        
    
        if([Player getPlayer].position.x < CGRectGetMidX(self.frame)/2){
            [Player getPlayer].physicsBody.velocity = CGVectorMake(15, 0);
        }
    }
    
//FlyinFlagがYesの際に行う処理
    if([Player getFlyFlag]  == YES){
        
        //フライングラベルを生成
        if([Player getFlyPoint] == 500){
            
            //フライングスタートのラベルを生成
            startFlyingLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
            startFlyingLabel.text = [NSString stringWithFormat:@"I can fly!!"];
            startFlyingLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
            [self addChild:startFlyingLabel];
            
            //飛行時間の表示
            flyingLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
            flyingLabel.text = [NSString stringWithFormat:@"%d",[Player getFlyPoint]];
            flyingLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)/2);
            [self addChild:flyingLabel];
        }
        
        //フライングスタートラベルの削除
        if([Player getFlyPoint] == 400){
            [startFlyingLabel removeFromParent];
        }
        
        //飛行時間のカウントダウン
        [Player countDownFlyPoint];
        
        //時間の更新
        flyingLabel.text = [NSString stringWithFormat:@"%d",[Player getFlyPoint]];
        
        if([Player getFlyFlag] == NO){
            [flyingLabel removeFromParent];
        }
        
        if([Player getFlyPoint] % 50 == 0){
            //魚の生成
            [Fish setFishPositionX:CGRectGetMaxX(self.frame) PositionY:CGRectGetMinY(self.frame)];
            
            //魚の追加処理開始
            fishAdd = YES;

            //魚の配列をget
            NSMutableArray * fishes = [Fish getFishes];
            //魚の数量をget
            int fishQuantity = [Fish getFishQuantity];
            //魚の配列をノードに追加する
            for(int tmp = 0;tmp < fishQuantity ; tmp++){
                [self addChild:fishes[fishes.count - tmp - 1]];

            }
            
            //魚を動かす
            [Fish moveFish];
            
            //魚の追加処理終了
            fishAdd = NO;
        }
        
        
    }

    
//プレイヤーが画面外に落ちた時にゲームオーバーとする処理
    if([self convertPoint:[Player getPlayerPosition] toNode:self].y < -(self.size.height) ||[self convertPoint:[Player getPlayerPosition] toNode:self].x < (-(self.size.width)/2)){

        //ゲームスタートのフラグをオフにする
        gameStart = NO;
        
        //ゲームオーバー
        
        SKLabelNode *endLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        endLabel.text = @"GAME OVER";
        endLabel.fontSize = 30;
        endLabel.name = @"kGameOver";
        endLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                        CGRectGetMidY(self.frame));
        
        //ラベル追加
        [self addChild:endLabel];
        
        //キャラクターの削除
        [[Player getPlayer] removeFromParent];
        
        
        //アクションを削除
        [[Ground getNextGround] removeAllActions];
        [[Wall getWall] removeAllActions];
        
        
        //BGMの停止
        [self->musicPlayer1 stop];
        
        //ゲームオーバー用のBGM
        NSError *error;
        NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"gameover" withExtension:@"mp3"];
        self->musicPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:url2 error:&error];
        self->musicPlayer2.numberOfLoops = -1;
        [musicPlayer2 prepareToPlay];
        [self->musicPlayer2 play];
        
        
    //ハイスコア登録処理
        //ハイスコア読込
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //スコアの比較
        if(score > [userDefaults floatForKey:@"score"]){
            //ハイスコアの場合userDefaultに設定
            [userDefaults setFloat:score forKey:@"score"];
            
        }
        
        
        //リトライボタンの追加
        SKLabelNode *retryLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        retryLabel.text = @"RETRY";
        retryLabel.fontSize = 20;
        retryLabel.name = @"kRetryLabel";
        //位置調整がうまくいかず。。。。
        retryLabel.position = CGPointMake(CGRectGetMinX(self.frame),
                                          CGRectGetMinY(self.frame));
        retryLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        [self addChild:retryLabel];
        
        
        
        
        //トップ画面の追加
        SKLabelNode *topLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        topLabel.text = @"TOP";
        topLabel.fontSize = 20;
        topLabel.name = @"kTopLabel";
        //位置調整がうまくいかず。。。。
        topLabel.position = CGPointMake(CGRectGetMaxX(self.frame),
                                        CGRectGetMinY(self.frame));
        topLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
        
        [self addChild:topLabel];

        
    }
    
  
    //アクションを終えたオブジェクトを削除していく
    [Ground removeOldNextGround];
    [Wall removeOldWall];
    
    if([Island removeIsland] == YES){
        //背景画像の更新
        [Island setIslandFrame:self.frame];
        [self addChild:[Island getIslands]];
        [Island moveIsland];
        
    }
    
    if ([Cloud removeCloud] == YES) {
        //背景画像の更新
        [Cloud setCloudFrame:self.frame];
        [self addChild:[Cloud getClouds]];
        [Cloud moveCloud];
    }
    
    
    //画面外のオブジェクトを削除していく
    if (fishAdd == NO) {
        [Fish removeFish];
    }
   


}



/***************** パーティクルの設定 *******************/
//炎パーティクルの作成
-(void)makeFireParticle:(CGPoint)point{
    if (_particleFire == nil) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"Fire" ofType:@"sks"];
        _particleFire = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        _particleFire.numParticlesToEmit = 50;
        [self addChild:_particleFire];
    }else{
        [_particleFire resetSimulation];
    }
    _particleFire.position = point;
}

//スパークパーティクルの作成
-(void)makeSparkParticle:(CGPoint)point{
    if (_particleSpark == nil) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"Spark" ofType:@"sks"];
        _particleSpark = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        _particleSpark.numParticlesToEmit = 50;
        [self addChild:_particleSpark];
    }else{
        [_particleSpark resetSimulation];
    }
    _particleSpark.position = point;
}



@end