//
//  GameLayer.m
//

#import "SimpleAudioEngine.h"
#import "CocosDenshion.h"
#import "CDAudioManager.h"

// Import the interfaces
#import "GameLayer.h"
#import "MenuLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#define TARGET_WIDTH

#pragma mark - GameLayer

// GameLayer implementation
@implementation GameLayer

// Helper class method that creates a Scene with the GameLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

@synthesize activeEmitters=activeEmitters_;
@synthesize activeSounds=activeSounds_;
@synthesize grassBlocks=grassBlocks_;
@synthesize inactiveEmitters=inactiveEmitters_;

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		self.isTouchEnabled = YES;
        
        //only CFDictionary supports UITouch as key
        NSMutableDictionary *original = [[NSMutableDictionary alloc] init];
        self.activeEmitters = (CFMutableDictionaryRef)original;

        self.activeSounds = [[ NSMutableArray alloc] init];

        self.grassBlocks = [[ NSMutableArray alloc] init];
        
        self.inactiveEmitters = [[ NSMutableArray alloc] init];
        
        SimpleAudioEngine *sae = [SimpleAudioEngine sharedEngine];
        if (sae != nil) {
            [sae preloadBackgroundMusic:@"rain.mp3"];
            if (sae.willPlayBackgroundMusic) {
                sae.backgroundMusicVolume = 0.5f;
            }
        }
        
        [self schedule:@selector(gameLogic:) interval:3.0];

    }
	return self;
}

- (void)addStars {
    CCSprite * bg = [CCSprite spriteWithFile:@"stars.png" rect:CGRectMake(0, 0, 2048, 2048)];
    [bg setPosition:ccp(0, 0)];
    ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_REPEAT};
    [bg.texture setTexParameters:&params];
    [self addChild:bg z:0];
}

-(void)onEnterTransitionDidFinish
{
    [self schedule:@selector(gameLogic:) interval:3.0];
    [self addStars];
    [self addCloud];
    [self addGrass];
    [self addLeaf];
}

-(void)spriteMoveFinished:(id)sender {
    CCSprite *sprite = (CCSprite *)sender;
    [self removeChild:sprite cleanup:YES];
}

-(void)gameLogic:(ccTime)dt {
    [self addCloud];
}

-(void)addLeaf {
    CCSprite *target = [CCSprite spriteWithFile:@"leaf.png"];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];

    CGFloat targetWidth = target.contentSize.width;
    CGFloat targetHeight = target.contentSize.height;

    if (winSize.height < 786) {
        target.scale = 0.75;
        targetWidth *= 0.75;
        targetHeight *= 0.75;
    }

    CGFloat X = winSize.width - (targetWidth/2);
    CGFloat Y = targetHeight/2;
    
    target.position = ccp(X, Y);
    [self addChild:target];
}

-(void)addGrass {

    CGSize winSize = [[CCDirector sharedDirector] winSize];

    // IMPORTANT:
    // The sprite frames will be cached AND RETAINED, and they won't be released unless you call
    //     [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    //NOTE:
    //The name of your .png and .plist must be the same name
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"grass_sprite.plist"];

    CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:@"grass_sprite.png"];

    CCSprite *target = NULL;
    int i = 0;
    while (target == NULL || ((i - 1) * target.contentSize.width) < winSize.width) {

            //TODO: save all targets in an array
            target = [CCSprite spriteWithSpriteFrameName:@"grass_sprite00.png"];
            CGFloat X = target.contentSize.width * i;
            CGFloat Y = target.contentSize.height * 0.3;
            target.position = ccp(X, Y);

            [batchNode addChild:target];
            [self.grassBlocks addObject:target];
            i++;
    }
    [self addChild:batchNode];

}

-(void)animateGrass:(int)index {
    CCSprite *target =  [self.grassBlocks objectAtIndex:index];
    NSMutableArray *animFrames = [NSMutableArray array];
    for(int i = 1; i < 12; i++) {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"grass_sprite%02d.png",i]];
        [animFrames addObject:frame];
    }
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.05f];
    [target runAction:[CCSequence actions:
            [CCDelayTime actionWithDuration:1],[CCAnimate actionWithAnimation:animation], nil]];
}

-(void)addCloud {
    
    CCSprite *target = [CCSprite spriteWithFile:@"cartoon-clouds.png"];
    
    // Determine where to spawn the target along the Y axis
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    //Scale clouds
    float cloudSize = (arc4random() % 6) * 0.1 + 0.5;
    if (winSize.height < 786) {
        cloudSize *= 0.75;
    }
    target.scale = cloudSize;

    CGFloat targetHeight = target.contentSize.height * cloudSize;
    CGFloat targetWidth = target.contentSize.width * cloudSize;
    
    int minY = targetHeight/2 + winSize.height * 0.75;
    int maxY = winSize.height - targetHeight/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    
    // Create the cloud slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    target.position = ccp(winSize.width + (targetWidth/2), actualY);
    [self addChild:target];
    
    // Determine speed of the cloud
    int minDuration = 15.0;
    int maxDuration = 25.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    id actionMove = [CCMoveTo actionWithDuration:actualDuration
                                        position:ccp(-targetWidth/2, actualY)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self
                                             selector:@selector(spriteMoveFinished:)];
    [target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
}

- (void) dealloc
{
	[self.inactiveEmitters dealloc];
    [self.activeSounds dealloc];
    [self.grassBlocks dealloc];
    [tapGesture dealloc];
	[super dealloc];
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {    
    for ( UITouch *touch in touches) {
        CCParticleSystem *emitter = [self getEmitterForTouch:touch];
        [self moveEmitterToTouch:touch emitter:emitter];
        [self animateGrassAtTouch:touch];
        [emitter resetSystem];
        [self playSound];
    }

}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for ( UITouch *touch in touches) {
        CCParticleSystem *emitter = [self getEmitterForTouch:touch];
        [self moveEmitterToTouch:touch emitter:emitter];
        [self animateGrassAtTouch:touch];
    }

}
-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for ( UITouch *touch in touches) {
        CCParticleSystem *emitter = [self getEmitterForTouch:touch];
        [emitter stopSystem];
        [self stopSound];
        [self recycleEmitter:emitter forTouch:touch];
    }
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for ( UITouch *touch in touches) {
        CCParticleSystem *emitter = [self getEmitterForTouch:touch];
        [emitter stopSystem];
        [self stopSound];
        [self recycleEmitter:emitter forTouch:touch];
    }
}

- (void)animateGrassAtTouch:(UITouch *)touch
{
    CGPoint location = [touch locationInView: [touch view]];
    int index = location.x/211;
    [self animateGrass:index];
}

- (void)moveEmitterToTouch:(UITouch*)touch emitter:(CCParticleSystem*) emitter
{
    CGPoint location = [touch locationInView: [touch view]];
    
	CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
    
	CGPoint pos = CGPointZero;
    
    emitter.position = ccpSub(convertedLocation, pos);
}

- (CCParticleSystem*) getEmitterForTouch:(UITouch*)touch
{
    CCParticleSystem* emitter = CFDictionaryGetValue(self.activeEmitters, touch);
    
    if(emitter == nil) {
        emitter = [self getNewEmitter];
        CFDictionarySetValue(self.activeEmitters, touch, emitter);
    }
    
    return emitter;
}

- (void) playSound
{
    ALuint sound = [[SimpleAudioEngine sharedEngine] playEffect:@"rain.mp3"];
    [self.activeSounds addObject:[NSNumber numberWithInt:sound]];
}

// TODO: fade out?
- (void) stopSound
{
    if([self.activeSounds count] > 0) {
        ALuint sound = [[self.activeSounds objectAtIndex:0] intValue];
        [[SimpleAudioEngine sharedEngine] stopEffect:sound];
        [self.activeSounds removeObjectAtIndex:0];
    }
}

- (CCParticleSystem*) getNewEmitter
{
    CCParticleSystem* emitter;
    if([self.inactiveEmitters count] > 0) {
        emitter = [self.inactiveEmitters objectAtIndex:0];
        [self.inactiveEmitters removeObjectAtIndex:0];
    }
    else {
        emitter = [CCParticleSystemQuad particleWithFile:@"BurstPipe.plist"];
        [emitter stopSystem];
        [self addChild:emitter z:10];
    }
    return emitter;
}

- (void) recycleEmitter:(CCParticleSystem*) emitter forTouch:(UITouch*) touch {
    CFDictionaryRemoveValue(self.activeEmitters, touch);
    [self.inactiveEmitters addObject:emitter];
}

@end
