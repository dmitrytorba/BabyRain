//
//  MenuLayer.h
//  


#import <GameKit/GameKit.h>
#import <CoreFoundation/CFDictionary.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// MenuLayer
@interface MenuLayer : CCLayer
{
	CCSprite                *background;
}

// returns a CCScene that contains the MenuLayer as the only child
+(CCScene *) scene;

@end
