//
//  HelloWorldLayer.h
//  BabyTouch
//
//  Created by Dmitry Torba on 12/26/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import <GameKit/GameKit.h>
#import <CoreFoundation/CFDictionary.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface GameLayer : CCLayer
{
    CFMutableDictionaryRef          activeEmitters_;
    NSMutableArray                  *grassBlocks_;
    NSMutableArray                  *activeSounds_;
    NSMutableArray                  *inactiveEmitters_;
	CCSprite                        *background;
    UITapGestureRecognizer          *tapGesture;
}

@property (readwrite) CFMutableDictionaryRef    activeEmitters;
@property (readwrite, retain) NSMutableArray    *activeSounds;
@property (readwrite, retain) NSMutableArray    *grassBlocks;
@property (readwrite,retain) NSMutableArray     *inactiveEmitters;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
