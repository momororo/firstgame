//
//  GameScene.m
//  FirstGame
//
//  Created by 新井脩司 on 2014/05/20.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import "GameScene.h"
#import "GameView.h"

@implementation GameScene{


//AVAudioPlayer * musicPlayer1;

//AVAudioPlayer * musicPlayer2;

    
//ゲームスタートのフラグ
BOOL gameStart;

//ゲームスタートの時間を記録する変数
NSDate *startTime;
    
//スタートのラベル
SKLabelNode *startLabel;
    
//スコアノード
SKSpriteNode *scoreNode;
    
//スコアラベル
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
    
//フライポイントの配列
NSMutableArray *flyPoints;
    
//フライング開始時間
NSDate *flyingStartDate;
    
//フライング時間のフラグ
int flyingCountTime;
    
//フライング開始のフラグ
BOOL flyingStartFlag;
    
//エンド画面のノード
SKSpriteNode *endNode;

//飛行時間のノード
SKSpriteNode *flyingNode;
    
//アスタ関係
MrdIconLoader *iconLoader;
MrdIconCell *iconCell1;
MrdIconCell *iconCell2;
MrdIconCell *iconCell3;
MrdIconCell *iconCell4;
    
    
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
    
        //メイン画面
       SKSpriteNode *haikei = [SKSpriteNode spriteNodeWithImageNamed:@"haikei.png"];
        haikei.size = CGSizeMake(haikei.size.width, haikei.size.height);
        haikei.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:haikei];
        
        //スタートラベル
        startLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        startLabel.text = @"GAME START";
        startLabel.fontSize = 30;
        startLabel.zPosition = 50;
        startLabel.fontColor = [SKColor blackColor];
        startLabel.name = @"kStartLabel";
        startLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        [self addChild:startLabel];
        
        //スコア表示看板
        scoreNode = [SKSpriteNode spriteNodeWithImageNamed:@"score.png"];
        scoreNode.size = CGSizeMake(self.frame.size.width, scoreNode.size.height);
        //scoreNode.position = CGPointMake(CGRectGetMaxX(self.frame)-(scoreNode.size.width/2), scoreNode.size.height/3);
        scoreNode.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMaxY(self.frame)*11/12);
        scoreNode.zPosition = 50;
        
        [self addChild:scoreNode];
        
        //スコア(点数)ラベル
        fishPoint = 0;
        scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Impact"];
        scoreLabel.text = @"0";
        scoreLabel.fontSize = 30;
        scoreLabel.fontColor = [UIColor blackColor];
        scoreLabel.name = @"kScoreLabel";
        //scoreLabel.zPosition = 50;
        scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
        scoreLabel.position = CGPointMake(200,0);
        [scoreNode addChild:scoreLabel];
        
        //スコアのPT表示専用ラベル
        SKLabelNode *ptLabel = [SKLabelNode labelNodeWithFontNamed:@"Impact"];
        ptLabel.text = @"PT";
        ptLabel.fontSize = 30;
        ptLabel.fontColor = [UIColor blackColor];
        ptLabel.position = CGPointMake(240,0);
        ptLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        [scoreNode addChild:ptLabel];
        
        //海
        [Sea initTexture];
        [Sea setSeasInitFrame:self.frame];
        NSMutableArray *seas = [Sea getSeaInit];
        [self addChild:seas[0]];
        [self addChild:seas[1]];
    
        //背景の島
        [Island initTexture];
        [Island setIslandInitFrame:self.frame];
        NSMutableArray *islands = [Island getIslandInit];
        [self addChild:islands[0]];
        [self addChild:islands[1]];
        [self addChild:islands[2]];
        
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
        [Ground setGroundFrame:self.frame];
        [self addChild:[Ground getNextGround]];
        
        //壁の設定(初期化)
        [Wall initWalls];
        [Wall initTexture];
        
        //プレイキャラの設定
        [Player initTexture];
        [Player setPlayerPositionX:CGRectGetMidX(self.frame)/2 positionY:100];
        [self addChild:[Player getPlayer]];
        
        //魚の設定
        [Fish initTexture];
        
        //フライングのスタートフラグをNOにしておく
        flyingStartFlag = NO;
        
        //接触デリゲート
        self.physicsWorld.contactDelegate = self;
        
        
        
        /**
         *  nend
         */
        //nadViewの生成
        self.nadView = [[NADView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        
        //ログ出力の設定
        self.nadView.isOutputLog = NO;
        
        //setapiKey
        [self.nadView setNendApiKey:@"729d726062b8ed26a2191936a39237d18f1c7883"];
        [self.nadView setNendSpotID:@"207219"];
        [self.nadView setDelegate:self];
        [self.nadView load];
        

        /**
         *  アスタ
         */
        iconLoader = [[MrdIconLoader alloc]init];
        
        
        //アイコン1つめ
        CGRect frame1 = CGRectMake(25, 185, 75, 75);
        iconCell1 = [[MrdIconCell alloc]initWithFrame:frame1];
        iconCell1.titleTextColor =[UIColor blackColor];
        
        //アイコンの設定項目(必要なら他のアイコンにもコピペして使ってね)
        /*
        iconCell1.iconFrame = CGRectMake(0, 0, 0, 0);
        iconCell1.titleFrame = CGRectMake(0, 0, 0, 0);//タイトルいらないなら"CGRectNull"
        iconCell1.titleTextColor = ;
        iconCell1.titleShadowColor = ;
        iconCell1.titleFont = ;
        */
        
        //アイコン2つめ
        CGRect frame2 = CGRectMake(105, 225, 75, 75);
        iconCell2 = [[MrdIconCell alloc]initWithFrame:frame2];
        iconCell2.titleTextColor =[UIColor blackColor];
        
        //アイコン3つめ
        CGRect frame3 = CGRectMake(405, 225, 75, 75);
        iconCell3 = [[MrdIconCell alloc]initWithFrame:frame3];
        iconCell3.titleTextColor =[UIColor blackColor];
        
        //アイコン4つめ
        CGRect frame4 = CGRectMake(485, 185, 75, 75);
        iconCell4 = [[MrdIconCell alloc]initWithFrame:frame4];
        iconCell4.titleTextColor =[UIColor blackColor];
        
        //アイコンの追加
        [iconLoader addIconCell:iconCell1];
        [iconLoader addIconCell:iconCell2];
        [iconLoader addIconCell:iconCell3];
        [iconLoader addIconCell:iconCell4];

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
            [Ground moveGroundToX:(-1500 - (self.frame.size.width / 2)) duration:5.7];
            [Island moveIslandInit];
            [Cloud moveCloudInit];
            [Sea moveSeaInit];

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
            self.musicPlayer1 = [[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:&error];
            self.musicPlayer1.numberOfLoops = -1;
            [_musicPlayer1 prepareToPlay];
            [self.musicPlayer1 play];
        
            return;
        }
        return;
    }
    
    
    //GameOverラベルがノードにあるときだけ入る処理
    if([self childNodeWithName:@"kEndNode"]){
        
        /**
         *  エンドノード内でのポジションを再取得する
         *  selfからlocationを取得するとself内でのポジションが取得される。
         *  endNodeからlocationを取得するとendNode内でのポジションが取得される
         *  エンドノード内のノードがタッチされたか判定するには
         *  セルフのポジションを取得してendNode内がタッチされたか判定した後
         *  endNode内でのポジションを取得し、Retryボタンのポジションと合致するか判定する。
         *
         */
        CGPoint location = [touch locationInNode:endNode];

        
        //
            if ([[endNode childNodeWithName:@"kRetryLabel"] containsPoint:location]) {
                
                /**
                 *  nend終了(viewから削除するときは加えてremoveFromSuperViewも唱えよう)
                 */
                [self.nadView setDelegate:nil];
                [self.nadView removeFromSuperview];
                self.nadView = nil;
                
                
                //アスタ終了
                [iconLoader removeIconCell:iconCell1];
                [iconLoader removeIconCell:iconCell2];
                [iconLoader removeIconCell:iconCell3];
                [iconLoader removeIconCell:iconCell4];
                [iconCell1 removeFromSuperview];
                [iconCell2 removeFromSuperview];
                [iconCell3 removeFromSuperview];
                [iconCell4 removeFromSuperview];

                
                //ゲームシーン画面に飛ぶ
                if ([_delegate respondsToSelector:@selector(sceneEscape:identifier:)]) {
                    
                    //ゲームオーバーBGMを止める
                    [self.musicPlayer2 stop];
                    
                    [_delegate sceneEscape:self identifier:@"retry"];
                    

                }
            }
           
           if ([[endNode childNodeWithName:@"kTopLabel"] containsPoint:location]) {
               
               
               /**
                *  nend終了(viewから削除するときは加えてremoveFromSuperViewも唱えよう)
                */
               [self.nadView setDelegate:nil];
               [self.nadView removeFromSuperview];
               self.nadView = nil;
               
               //アスタ終了
               [iconLoader removeIconCell:iconCell1];
               [iconLoader removeIconCell:iconCell2];
               [iconLoader removeIconCell:iconCell3];
               [iconLoader removeIconCell:iconCell4];
               [iconCell1 removeFromSuperview];
               [iconCell2 removeFromSuperview];
               [iconCell3 removeFromSuperview];
               [iconCell4 removeFromSuperview];


               //ゲームシーン画面に飛ぶ
               if ([_delegate respondsToSelector:@selector(sceneEscape:identifier:)]) {
                   
                   //ゲームオーバーBGMを止める
                   [self.musicPlayer2 stop];
                   [_delegate sceneEscape:self identifier:@"top"];
                
               }
           }
        return;
    }

    
    

    //ジャンプ or スマッシュ
    [Player jumpOrSmashAction];
/*
    //接地フラグOFF（念のため）
    playerAndGroundContactFlag = NO;
    NSLog(@"フラグOFF(ジャンプ)");
*/

    
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
/*            if(playerAndGroundContactFlag == YES){
                playerAndGroundContactFlag = NO;
                NSLog(@"フラグOFF(小細工)");
                return;
            }
            
                playerAndGroundContactFlag = YES;
                NSLog(@"フラグON(コンタクト)");
*/


            
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
           
        //フライポイントの配列に追加
           //配列が未作成か確認
           if(flyPoints == nil){
               flyPoints = [NSMutableArray new];
           }
           
           //ノードを作成
           SKSpriteNode *flyPoint = [SKSpriteNode spriteNodeWithImageNamed:@"flyPoint"];
           flyPoint.size          = CGSizeMake(flyPoint.size.width/3.5 ,
                                               flyPoint.size.height/3.5);

           flyPoint.zPosition     = 100;
           
           //ポジションを配列の個数を基準に決定
           if(flyPoints.count == 0){
               //配列に何もないので初期位置を設定
               flyPoint.position = CGPointMake(CGRectGetMaxX(self.frame)/20,
                                               CGRectGetMinY(self.frame) + self.frame.size.height/18);
           }else{
               //一つ前のフライポイントを基準にして位置を決定
               SKSpriteNode *preFlyPoint = flyPoints[flyPoints.count - 1];
               flyPoint.position      = CGPointMake(preFlyPoint.position.x + (preFlyPoint.size.width),
                                        preFlyPoint.position.y);
           }
           
           //ノードに追加
           [self addChild:flyPoint];
           
           //配列に追加
           [flyPoints addObject:flyPoint];
           
           //配列が5つになった際にフラグをYESにしておく
           if(flyPoints.count == 5){
               flyingStartFlag = YES;
           }

           
           
           
           
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
/*
        //接地フラグOFF
        playerAndGroundContactFlag = NO;
        NSLog(@"フラグOFF(コンタクト)");
*/
        [Player setJumpFlagOff];
        return;
    }

    /**********プレイヤーと地面が離れるのを検知終了**********/

    /**********フライングプレイヤーと地面が離れるのを検知**********/
    if([ObjectBitMask flyingPlayerAndGround:contact]){

/*
        playerAndGroundContactFlag = NO;
*/
        return;
    }
    /**********フライングプレイヤーと地面が離れるのを検知終了**********/


    
}

//1フレーム毎に動作するメソッド
-(void)didSimulatePhysics{
    
    if(gameStart == NO){
        return;
    }
    
    
//SCOREの更新
    if(gameStart == YES){
        
        score = [[NSDate date] timeIntervalSinceDate:startTime] * 2 + fishPoint;
        //元の文↓
        //scoreLabel.text = [NSString stringWithFormat:@"SCORE = %.1f",score];
        scoreLabel.text = [NSString stringWithFormat:@"%.1f",score];

    }
    
    
//プレイヤーをスタート地点まで戻す処理（糞処理）
    NSArray *array = [[Player getPlayer].physicsBody allContactedBodies];
    //プレイヤーと接触しているオブジェクトが0かどうか確認
    if(array.count != 0){
        //プレイヤーと接触しているオブジェクト群をループ
        for(SKPhysicsBody *body in array){
            //地面かどうか判定
            if(body.categoryBitMask == groundCategory){
                //スタート地点のx座標とズレがあるか判定
                if([Player getPlayer].position.x < CGRectGetMidX(self.frame)/2){
                    if( [Player getPlayer].position.y + 1 >= (body.node.position.y) + ([body.node calculateAccumulatedFrame].size.height/8) ){
                        
                        //スタート地点まで押し戻す
                        [Player getPlayer].physicsBody.velocity = CGVectorMake(35, 0);
                    }
                }
            }
        }
    }

    
//壁の生成
    //壁が規定のx座標から下回っているか判定する
    if([Ground judgeXpointer:(CGRectGetMidX(self.frame) * 1.5)]){
        
            //スコア20までは壁が出ず
            if(score < 20){
                //nextGroundの生成
                [Ground setNextGroundPositionX:self.frame.size.width];
                [self addChild:[Ground getNextGround]];
                
                //nextGroundの動作
                [Ground moveNextGroundDuration:5.7];
                
                return;
                
            }
            
            //スコアが1000までは壁が3分の1の確率で出る
            if(score >=20 && score < 1000){
                
                //nextGroundの生成
                [Ground setNextGroundPositionX:self.frame.size.width + arc4random_uniform(10)];
                [self addChild:[Ground getNextGround]];
                
                //速度の設定
                float duration = 5.5;
                
                //nextGroundの動作
                [Ground moveNextGroundDuration: duration];
                
                NSLog(@"1000:%f",duration);
                
                
                if(arc4random_uniform(3) == 0){
                    //nextGroundを基に壁を生成
                    [Wall setWallFromNextGround:[Ground getNextGround]];
                    [self addChild:[Wall getWall]];
                    
                    //wallの動作
                    [Wall moveWallDuration:duration];
                    
                    return;
                }
            }
            
            
            //スコアが1000以上は常に壁が出てスコアに応じて速度アップ
            
            if (score >= 1000) {
                
                //nextGroundの生成
                [Ground setNextGroundPositionX:self.frame.size.width + arc4random_uniform(15)];
                [self addChild:[Ground getNextGround]];
                
                
                //速度可変用の変数
                float duration = 5.3 - (score / 3500) ;
                
                if (score >= 11000){
                    duration = 2.0;
                }
                
                
                //nextGroundの動作
                [Ground moveNextGroundDuration:duration];
                
                
                if(arc4random_uniform(2) == 0){
                    
                    
                    if (score < 5000) {
                        //nextGroundを基に壁を生成
                        [Wall setWallFromNextGround:[Ground getNextGround]];
                        [self addChild:[Wall getWall]];
                        
                    }else{
                    
                        //nextGroundを基に壁を生成
                        [Wall set2WallFromNextGround:[Ground getNextGround]];
                        [self addChild:[Wall getWall]];

                    }
                    
                    //wallの動作
                    [Wall moveWallDuration:duration];
                    
                    return;
                    
                }
                
            }
        }
        
    
    
//FlyinFlagがYesの際に行う処理
    if([Player getFlyFlag]  == YES){
        
        //フライングラベルを生成
        if(flyingStartFlag == YES){
            
            //フライングスタートのラベルを生成
            startFlyingLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
            startFlyingLabel.fontColor = [SKColor blackColor];
            startFlyingLabel.zPosition = 50;
            startFlyingLabel.text = [NSString stringWithFormat:@"I can fly!!"];
            startFlyingLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
            [self addChild:startFlyingLabel];
            
            //飛行時間表示のノード
            flyingNode = [SKSpriteNode spriteNodeWithImageNamed:@"raptime.png"];
            flyingNode.size = CGSizeMake(flyingNode.size.width/2, flyingNode.size.height/2);
            flyingNode.position = CGPointMake(CGRectGetMidX(self.frame), -(flyingNode.size.height/2));
            flyingNode.zPosition = 50;
            [self addChild:flyingNode];


            //飛行時間の表示ラベル
            flyingLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
            flyingLabel.fontColor = [SKColor blackColor];
            [flyingNode addChild:flyingLabel];

            
            //フライング開始時間の設定
            flyingStartDate = [NSDate date];
            
            //フライング時間のフラグの設定
            flyingCountTime = 2.0;
            
            //フライングスタートのフラグをNOにする
            flyingStartFlag = NO;
            

        }
        
        //時間の差分を取得
        NSDate *now = [NSDate date];
        float currentTime = [now timeIntervalSinceDate:flyingStartDate];
        
        //フライング時間のカウントアップと、条件に応じた処理を行う
        if(flyingCountTime <= currentTime){
            
            
            //2秒に一回ペンギンを出す
                if(flyingCountTime % 2 == 0){
                    
                    
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
                    
                    //フライングポイントのラベルの削除
                    SKSpriteNode *point = flyPoints[flyPoints.count - 1];
                    [point removeFromParent];
                    [flyPoints removeObjectAtIndex:flyPoints.count - 1];
                    
                    //フライングポイントのカウントダウン
                    [Player countDownFlyPoint];
                    
                }
            
            //２秒後にスタートラベルを削除する
            if(flyingCountTime == 2){
                [startFlyingLabel removeFromParent];
            }
            
            //5秒以降はカウントダウン
            if(flyingCountTime >= 5){
                
                //飛行時間表示のノードを下から出現させる
                SKAction *flyingNodeAction = [SKAction moveToY:CGRectGetMidY(self.frame)/6 duration:1];
                [flyingNode runAction:flyingNodeAction];
                                                  
                //飛行時間の表示
                flyingLabel.text = [NSString stringWithFormat:@"%d",( 10 - flyingCountTime)];
                flyingLabel.position = CGPointMake(0,35);
                
            }
            
            
            //フライング時間のフラグをカウントアップ
            flyingCountTime++;

            
            if(flyingCountTime == 11){
                SKAction *flyingNodeAction = [SKAction moveToY:-(flyingNode.size.height/2) duration:1];
                [flyingNode runAction:flyingNodeAction];
                [flyingLabel removeFromParent];
                if (flyingNode.position.y ==  -(flyingNode.size.height/2)) {
                    [flyingNode removeFromParent];
                }

            }
            
        }
        
        
    }

    
//プレイヤーが画面外に落ちた時にゲームオーバーとする処理
    if([self convertPoint:[Player getPlayerPosition] toNode:self].y < -(self.size.height) ||[self convertPoint:[Player getPlayerPosition] toNode:self].x < (-(self.size.width)/9)){

        //ゲームスタートのフラグをオフにする
        gameStart = NO;
        
        //ゲームオーバー
        
        endNode = [SKSpriteNode spriteNodeWithImageNamed:@"gameOver.png"];
        endNode.size = CGSizeMake(endNode.size.width/2, endNode.size.height/2);
        endNode.position = CGPointMake(CGRectGetMidX(self.frame), -(endNode.size.height/2));
        endNode.zPosition = 50;
        endNode.name = @"kEndNode";
        
        [self addChild:endNode];
        
        SKAction *endAction = [SKAction moveToY:CGRectGetMidY(self.frame)/2 duration:2];
        [endNode runAction:endAction];
        
        SKLabelNode *endLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        endLabel.text = @"GAME OVER";
        endLabel.fontSize = 30;
        endLabel.fontColor = [SKColor blackColor];
        endLabel.name = @"kGameOver";
        endLabel.position = CGPointMake(5,165);
        
        //ラベル追加
        [endNode addChild:endLabel];
        
        //キャラクターの削除
        [[Player getPlayer] removeFromParent];
        
        
        //アクションを削除
        [[Ground getNextGround] removeAllActions];
        [[Wall getWall] removeAllActions];
        [[Island getIslands] removeAllActions];
        
        //スコアの削除
        [scoreNode removeFromParent];
        
        //フライングモードをカウントするノードがあった場合、削除する
        if (flyingNode) {
            [flyingNode removeFromParent];
        }
        
        
        //BGMの停止
        [self.musicPlayer1 stop];
        
        //ゲームオーバー用のBGM
        NSError *error;
        NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"gameover" withExtension:@"mp3"];
        self.musicPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:url2 error:&error];
        self.musicPlayer2.numberOfLoops = -1;
        [_musicPlayer2 prepareToPlay];
        [self.musicPlayer2 play];
        
        //フライングポイントの削除
        for (int count = 0 ; count < flyPoints.count ;){
            SKSpriteNode *flyPoint = flyPoints[count];
            [flyPoint removeFromParent];
            [flyPoints removeObjectAtIndex:0];
        }
        //配列の初期化(念のため)
        flyPoints = nil;
        
        
    //ハイスコア登録処理
        //ハイスコア読込
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //スコアの比較
        if(score > [userDefaults floatForKey:@"score"]){
            //ハイスコアの場合userDefaultに設定
            [userDefaults setFloat:score forKey:@"score"];
            
            //ハイスコアの場合、新記録と表示する
            SKLabelNode *newRecord = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
            newRecord.text = @"New record!!";
            newRecord.fontSize = 18;
            newRecord.fontColor = [SKColor redColor];
            newRecord.position = CGPointMake(0, 125);
            [endNode addChild:newRecord];
            
            NSArray *tenmetu = @[[SKAction fadeAlphaTo:0.0 duration:1], [SKAction fadeAlphaTo:1.0 duration:0.75]];
            SKAction *action = [SKAction repeatActionForever:[SKAction sequence:tenmetu]];
            [newRecord runAction:action];
            
            //ハイスコアをゲームセンターに送信
            //[self sendScore:score];

        }
        
        
        /**
         *  デバッグ中
         *  selfの子ノードの子ノードについては、
         *  定数でポジショニングしても大丈夫
         *  =selfの子ノードをポジショニングする際は、selfのサイズから相対的に位置を決定する必要あり
         */
        
        //リトライボタンの追加
        SKLabelNode *retryLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        retryLabel.text = @"RETRY";
        retryLabel.fontSize = 20;
        retryLabel.fontColor = [SKColor blackColor];
        retryLabel.name = @"kRetryLabel";
        //位置調整がうまくいかず。。。。
        retryLabel.position = CGPointMake(-85,57);
        retryLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        retryLabel.zPosition = 100;
        
        [endNode addChild:retryLabel];
        
        
        
        
        //トップ画面の追加
        SKLabelNode *topLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        topLabel.text = @"TOP";
        topLabel.fontSize = 20;
        topLabel.fontColor = [SKColor blackColor];
        topLabel.name = @"kTopLabel";
        //位置調整がうまくいかず。。。。
        topLabel.position = CGPointMake(110,
                                        57);
        topLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        
        [endNode addChild:topLabel];
        
        //スコアの表示
        SKLabelNode *rastScore = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        rastScore.text = [NSString stringWithFormat:@"Score... %.1f pt",score];
        rastScore.fontSize = 30;
        rastScore.fontColor = [SKColor blackColor];
        rastScore.position = CGPointMake(0,125);
        rastScore.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        
        [endNode addChild:rastScore];
        
        //灯籠流し
        SKSpriteNode *penguin = [SKSpriteNode spriteNodeWithImageNamed:@"pengin6"];
        penguin.size = CGSizeMake(penguin.size.width/2, penguin.size.height*2/3);
        penguin.position = CGPointMake(CGRectGetMaxX(self.frame) + penguin.size.width*4, CGRectGetMidY(self.frame)*2/3);
        penguin.zPosition = 0;
        
        [self addChild:penguin];
        
        [penguin runAction:[SKAction sequence:@[[SKAction moveToX: -200 duration:30],[SKAction removeFromParent]]]];
        
        //広告取得開始
        iconLoader.refreshInterval = 10;
        [iconLoader startLoadWithMediaCode:@"ast01828uclvqv3b6osf"];

        
        //アスタの表示
        [self.view addSubview:iconCell1];
        [self.view addSubview:iconCell2];
        [self.view addSubview:iconCell3];
        [self.view addSubview:iconCell4];
        
        
        
        
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
    
    if ([Sea removeSea] == YES) {
        //背景画像の更新
        [Sea setSeaFrame:self.frame];
        [self addChild:[Sea getSeas]];
        [Sea moveSea];
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


/**
 *  Game Center用メソッド
 */
/*
-(void)sendScore:(float)highScore{
    
    if ([GKLocalPlayer localPlayer].isAuthenticated) {
        GKScore* sendScore = [[GKScore alloc] initWithLeaderboardIdentifier:@"FirstPenguin_test"];
        sendScore.value = highScore * 10;
        [GKScore reportScores:@[sendScore] withCompletionHandler:^(NSError *error) {
            if (error) {*/
                // エラーの場合
                /**
                 *  何もせず終了
                 */
                /*NSLog(@"失敗");
            }
            NSLog(@"成功してるはず");
        }];
    }
}
*/
/**
 *  nend デリゲートメソッド
 */
//広告受信成功後、viewに追加
-(void)nadViewDidFinishLoad:(NADView *)adView{
    //デバッグ用、後で消す
    NSLog(@"成功");
    [self.view addSubview:adView];
}

//広告受信失敗(あとで消す)
-(void)nadViewDidFailToReceiveAd:(NADView *)adView{
    NSLog(@"失敗！");
}



@end