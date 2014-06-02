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
    
//ゲームスタートのフラグ
BOOL gameStart;

//ゲームスタートの時間を記録する変数
    NSDate *startTime;
    
//スタートのラベル
SKLabelNode *startLabel;
    
//スコアのラベル
SKLabelNode *scoreLabel;
    
//パーティクル（炎）
SKEmitterNode *_particleFire;
//パーティクル（スパーク）
SKEmitterNode *_particleSpark;
//パーティクル（ボム）
SKEmitterNode *_particleBom;
//パーティクル（スモーク）
SKEmitterNode *_particleSmoke;
    
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
        
        //スコアラベル
        scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        scoreLabel.text = @"SCORE = 0";
        scoreLabel.fontSize = 20;
        scoreLabel.name = @"kScoreLabel";
        scoreLabel.position = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame)-(CGRectGetMaxY(self.frame)/10));
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        
        //海
        SKSpriteNode *umi = [SKSpriteNode spriteNodeWithImageNamed:@"umi.png"];
        umi.position = CGPointMake(CGRectGetMidX(self.frame),umi.frame.size.height/2);
        
        [self addChild:umi];
        [self addChild:scoreLabel];
        [self addChild:startLabel];
        
        
        //透明のオブジェクトを生成(センサー)
        [Sensor setSensoFrame:self.frame];
        [self addChild:[Sensor getSensor]];
        
        //地面の設定
        [Ground setGroundSizeX:self.frame.size.width sizeY:24];
        [self addChild:[Ground getGround]];
        
        
        //プレイキャラの設定
        [Player setPlayerPositionX:CGRectGetMidX(self.frame)/2 positionY:100];
        [self addChild:[Player getPlayer]];

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

            //スタートラベルの削除
            [startLabel removeFromParent];
            
            //ゲームスタートフラグをYESに
            gameStart = YES;
            
            
            
           //プレイヤー歩行開始
            [Player walkAction];
            
            //秒数を記録
            startTime = [NSDate date];
        
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
                }
            }
           
           if ([[self childNodeWithName:@"kTopLabel"] containsPoint:location]) {
               //ゲームシーン画面に飛ぶ
               if ([_delegate respondsToSelector:@selector(sceneEscape:identifier:)]) {
                [_delegate sceneEscape:self identifier:@"top"];
               }
           }
        return;
    }

    
    

    //ジャンプ or スマッシュ
    [Player jumpOrSmashAction];
    
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
        if( contact.contactPoint.y + 2 >= (ground.position.y) + ([ground calculateAccumulatedFrame].size.height/2) ){
            
            //player歩行動作
                [Player walkAction];
                
                return;
        }
        
    }
    
	/**********プレイヤーと地面の衝突を検知終了**********/

    

    /**********地面と飛行キャラクターの衝突を検知**********/
    if([ObjectBitMask flyingPlayerAndGround:contact]){
        
        //地面を格納する変数
        SKNode *ground = [ObjectBitMask getGroundFromContact:contact];
        
        //接触位置 + 2 >= 地面の上面
        if(contact.contactPoint.y + 2 >= (ground.position.y) + ([ground calculateAccumulatedFrame].size.height/2) ){
            
            //player歩行動作
            [Player walkAction];
            
            return;
        }
        
    }
    
    /**********地面と飛行キャラクターの衝突を検知終了**********/

    
    /**********プレイヤーと壁の衝突を検知**********/
       if([ObjectBitMask playerAndWall:contact]){
           
           //壁の消滅
            [[ObjectBitMask getWallFromContact:contact] removeFromParent];
           //パーティクルの発生
            [self makeSparkParticle:contact.contactPoint];


           //player歩行動作
           [Player walkAction];
           
           return;

           
       }
    
    /**********プレイヤーと壁の衝突を検知終了**********/
    
}


//オブジェクト同士が離れた際の処理
- (void)didEndContact:(SKPhysicsContact *)contact
{
    
    /**********プレイヤーと地面が離れるのを検知**********/
    if([ObjectBitMask playerAndGround:contact]){
        [Player setJumpFlagOff];
    }
    /**********プレイヤーと地面が離れるのを検知終了**********/

    
    /**********センサーと地面が離れるのを検知**********/
    if([ObjectBitMask sensorAndGround:contact]){
        
        //nextGroundの生成
        [Ground setNextGroundPositionX:self.frame.size.width];
        [self addChild:[Ground getNextGround]];
        
        //nextGroundを基に壁を生成
        [Wall setWallFromNextGround:[Ground getNextGround]];
        [self addChild:[Wall getWall]];
        
        //nextGroundの動作
        [Ground moveNextGroundDuration:4.0];
        //wallの動作
        [Wall moveWallGroundDuration:4.0];
        

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
    scoreLabel.text = [NSString stringWithFormat:@"SCORE = %.1fm",(float)[[NSDate date] timeIntervalSinceDate:startTime] * 2];
 
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
        
        //SCOREを記録する処理を追記すること
        
        return;
        
        
        
        
        
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