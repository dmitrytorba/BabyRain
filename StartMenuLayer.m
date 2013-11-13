//
//  StartMenuLayer.m
//  BabyTouch
//
//  Created by Jacob Torba on 1/18/13.
//
//

// Import the interfaces
#import "StartMenuLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "GameLayer.h"

#pragma mark - StartMenuLayer

// GameLayer implementation
@implementation StartMenuLayer

// Helper class method that creates a Scene with the StartMenuLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	StartMenuLayer *layer = [StartMenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
    
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
     self.isTouchEnabled = YES;                       
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
        CCDirector *director = [CCDirector sharedDirector];
        //Setup up a call to 'swipeGestureCaptured' on a swipe gesture
        swipeGesture = [[UISwipeGestureRecognizer alloc]
                        initWithTarget:self
                        action:@selector(swipeGestureCaptured:)];
        [director.view addGestureRecognizer:swipeGesture];
        [swipeGesture release];

	}
	return self;
}

-(void)onEnter
{
    // Set background color to magenta.
    CCLayerColor* colorLayer = [CCLayerColor layerWithColor:ccc4(255, 0, 255, 255)];
    [self addChild:colorLayer];
    
    // create and initialize a Label
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Swipe to Play ->" fontName:@"Marker Felt" fontSize:64];
    
    // ask director for the window size
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    
    // position the label on the center of the screen
    label.position =  ccp( size.width/2 , size.height/2 );
    
    // add the label as a child to this Layer
    [self addChild: label];
}

//The response to a swipe
- (void)swipeGestureCaptured:(UISwipeGestureRecognizer *)gesture
{
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:swipeGesture];
    CCScene * changeTo = [GameLayer scene];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionMoveInL transitionWithDuration:0.3 scene:changeTo]];
    
    
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}


@end
