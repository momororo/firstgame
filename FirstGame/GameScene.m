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

//グラウンドID(属性の割り振りに使用するよう)
int groundID;
    
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
        SKSpriteNode *sensor = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(1,self.frame.size.height)];
        
        sensor.name = @"kSensor";
        sensor.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        sensor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(sensor.size.width,sensor.size.height )];
        
        sensor.physicsBody.affectedByGravity = NO;
        
        sensor.physicsBody.categoryBitMask = sensorCategory;
        sensor.physicsBody.collisionBitMask = 0;
        sensor.physicsBody.contactTestBitMask = groundCategory;
        

        
        [self addChild:sensor];
        
        //地面の設定
        SKSpriteNode *ground = [SKSpriteNode spriteNodeWithColor:[SKColor brownColor]
                                                            size:CGSizeMake(self.frame.size.width, 24)];
        ground.name = kGround;
        ground.position = CGPointMake(ground.size.width/2,ground.size.height/2);
        
        ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(ground.size.width, ground.size.height)];
        ground.physicsBody.affectedByGravity = NO;
        ground.physicsBody.restitution = 0;

        ground.physicsBody.categoryBitMask = groundCategory;
        ground.physicsBody.collisionBitMask = 0;
        ground.physicsBody.contactTestBitMask = 0;
    
        
        [self addChild:ground];
        
        
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
            gameStart = YES;
            SKNode *sprite2 = [self childNodeWithName:kGround];
            [sprite2 runAction:[SKAction repeatActionForever:
                                [SKAction sequence:@[[SKAction moveToX:-300 - (self.frame.size.width / 2) duration:3.0],
                                                     [SKAction removeFromParent]]]]];
            [startLabel removeFromParent];
            
            
            
            
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

    
	//プレイヤーと地面の衝突を検知
    if([ObjectBitMask playerAndGround:contact]){
        
        //プレイヤーを格納する変数
        SKPhysicsBody *player = [ObjectBitMask getPlayerFromContact:contact];

        //地面を格納する変数
        SKPhysicsBody *ground = [ObjectBitMask getGroundFromContact:contact];
        
        //プレイヤーのy座標-プレイヤーの高さ/2→プレイヤーの足元のy座標
        //道路のy座標+道路の高さ/2→道路の表面のy座標
        if((player.node.position.y) - ([player.node calculateAccumulatedFrame].size.height/2) + 2 >= (ground.node.position.y) + ([ground.node calculateAccumulatedFrame].size.height/2) ){
            
            
            //player歩行動作
                [Player walkAction];
                
                return;
        }
        
    }
    
    //地面とプレイヤーの条件分岐終わり

    //地面と飛行キャラクターとの条件分岐
	//プレイヤーと地面の衝突を検知
    if((flyingPlayerCategory == contact.bodyA.categoryBitMask || flyingPlayerCategory == contact.bodyB.categoryBitMask) && (groundCategory == contact.bodyA.categoryBitMask || groundCategory == contact.bodyB.categoryBitMask)){
        
        //地面を格納する変数
        SKPhysicsBody *ground;
        //プレイヤーを格納する変数
        SKPhysicsBody *player;

        if(flyingPlayerCategory == contact.bodyA.categoryBitMask){
            player = contact.bodyA;
            ground = contact.bodyB;
        }else{
            player = contact.bodyB;
            ground = contact.bodyA;
            
        }
        
        //プレイヤーのy座標-プレイヤーの高さ/2→プレイヤーの足元のy座標
        //道路のy座標+道路の高さ/2→道路の表面のy座標
        if((player.node.position.y) - ([player.node calculateAccumulatedFrame].size.height/2) + 2 >= (ground.node.position.y) + ([ground.node calculateAccumulatedFrame].size.height/2) ){

            //player歩行動作
            [Player walkAction];
            
            return;
            }
        }
    
    //地面と飛行プレイヤーの条件分岐終わり

    
    //壁とプレイヤーの条件分岐
       if((flyingPlayerCategory == contact.bodyA.categoryBitMask || flyingPlayerCategory == contact.bodyB.categoryBitMask) && (wallCategory == contact.bodyA.categoryBitMask || wallCategory == contact.bodyB.categoryBitMask)){
           
           //壁の消滅
           if(wallCategory == contact.bodyA.categoryBitMask){
               [contact.bodyA.node removeFromParent];
               [self makeSparkParticle:contact.contactPoint];
           }else{
               [contact.bodyB.node removeFromParent];
               [self makeSparkParticle:contact.contactPoint];
           }


           //player歩行動作
           [Player walkAction];
           
           return;

           
       }
    
}


//オブジェクト同士が離れた際の処理
- (void)didEndContact:(SKPhysicsContact *)contact
{

    
    
    //地面とセンサーが離れるのを検知
    if((sensorCategory == contact.bodyA.categoryBitMask || sensorCategory == contact.bodyB.categoryBitMask) && (groundCategory == contact.bodyA.categoryBitMask || groundCategory == contact.bodyB.categoryBitMask)){
        
            SKAction *makeGround = [SKAction sequence: @[[SKAction performSelector:@selector(nextGround) onTarget:self]]];
            [self runAction:makeGround];
        
        
        
    }

    
}

//1フレーム毎に動作するメソッド
-(void)didSimulatePhysics{
    
    
//SCOREの更新
    if(gameStart == YES){
    scoreLabel.text = [NSString stringWithFormat:@"SCORE = %.1fm",(float)[[NSDate date] timeIntervalSinceDate:startTime] * 2];
 
    }

    
//プレイヤーが画面外に落ちた時にゲームオーバーとする処理
	[self enumerateChildNodesWithName:kPlayer usingBlock:^(SKNode *node, BOOL *stop) {
		CGPoint pt = [self convertPoint:node.position toNode:self];
        CGFloat	h = self.size.height;
        CGFloat	w = self.size.width;
       
        //画面外か判定
		if(pt.y < -(h) || pt.x < (-(w)/2)){
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
            [node removeFromParent];
            
            
            //地面のスクロールをストップ
            SKNode *sprite = [self childNodeWithName:kGround];
            //アクションを削除
            [sprite removeAllActions];
            
            
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
        
    }];
    
    
        


    
}

//地面を次々に呼ぶ
-(void)nextGround{
    if (gameStart == YES) {
        
        //NSArray *ground = @[@"ground1",@"ground2",@"groud3"];
        
        //groundID = arc4random()%2;
        SKSpriteNode *nextGround = [SKSpriteNode spriteNodeWithImageNamed:@"ground2"];
        
       // nextGround.userData = [@{@"tekito":@(skRand(400,800))}mutableCopy];
        
        //skRand(50,100));
        
        //床の長さ調整実験
        //nextGround.size = CGSizeMake(100 + arc4random_uniform(151),50+arc4random_uniform(101));
        nextGround.size = CGSizeMake(300 + arc4random_uniform(551),50+arc4random_uniform(101));


        nextGround.position = CGPointMake((self.frame.size.width + (nextGround.size.width/2) ),0);
        
        [self addChild:nextGround];
 
        nextGround.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(nextGround.size.width, nextGround.size.height)];
        nextGround.physicsBody.restitution = 0;
        //nextGround.physicsBody.restitution = skRandBound();
        nextGround.physicsBody.affectedByGravity = NO;
        
        
        
        //[nextGround runAction:[SKAction sequence:@[[SKAction moveToX: -300 + (nextGround.size.width/2)duration:3.0],[SKAction removeFromParent]]]];
        [nextGround runAction:[SKAction sequence:@[[SKAction moveToX: -800 + (nextGround.size.width/2)duration:4.0],[SKAction removeFromParent]]]];
        
        
        
        
        //接触設定
        //カテゴリー
        nextGround.physicsBody.categoryBitMask = groundCategory;
        //接触できるオブジェクト
        nextGround.physicsBody.collisionBitMask =  0;
        //ヒットテストするオブジェクト
        nextGround.physicsBody.contactTestBitMask = 0;
        
        
        /****************************************************/
        SKSpriteNode *wall = [SKSpriteNode spriteNodeWithImageNamed:@"hyouzan"];
        wall.size = CGSizeMake(wall.frame.size.width/2,wall.frame.size.height/2);
        
        int tmp;
     //   if(arc4random_uniform(2) == 0){
        tmp = arc4random_uniform(nextGround.size.width/2);
       // }else{
       // tmp = -(arc4random_uniform(nextGround.size.width/2));
       // }
        
        wall.position = CGPointMake((self.frame.size.width + nextGround.size.width/2) -(tmp), ((nextGround.size.height/2) + (wall.size.height/2)));
        [self addChild:wall];
        
        wall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(wall.size.width/3.5, wall.size.height)];
        wall.physicsBody.restitution = 0;
       // [wall runAction:[SKAction sequence:@[[SKAction moveToX: -300 + (nextGround.size.width/2) - (tmp)duration:3.0],[SKAction removeFromParent]]]];
        
        [wall runAction:[SKAction sequence:@[[SKAction moveToX: -800 + (nextGround.size.width/2) - (tmp)duration:4.0],[SKAction removeFromParent]]]];
        
        
        wall.physicsBody.categoryBitMask = wallCategory;
        wall.physicsBody.collisionBitMask = groundCategory;// | playerCategory;
        wall.physicsBody.contactTestBitMask = 0;
        
        
        
        
        
        
        
        
        
        
        
        /****************************************************/
        
        
        
        
        
        
        
        
        
        
        
    }
}

/*使用していないためコメント化（最終的に消します）
static inline CGFloat skRand(CGFloat low,CGFloat high){
    CGFloat res = skRandf() * ((high - low) + low);
    return  res;
}
*/


/*使用していないためコメント化（最終的に消します）
static inline CGFloat skRandf(){
    return rand() / (CGFloat) RAND_MAX;
}
*/

/*
static inline CGFloat skRandBound()
{
    
    CGFloat rand = (CGFloat)arc4random_uniform(51)/100;
    return rand;
}
*/


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