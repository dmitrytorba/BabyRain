//
//  StartMenuLayer.h
//  BabyTouch
//
//  Created by Jacob Torba on 1/18/13.
//
//

#import <GameKit/GameKit.h>
#import <CoreFoundation/CFDictionary.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// Start menu layer
@interface StartMenuLayer : CCLayer
{
	UISwipeGestureRecognizer *swipeGesture;
}

// returns a CCScene that contains the MenuLayer as the only child
+(CCScene *) scene;

@end