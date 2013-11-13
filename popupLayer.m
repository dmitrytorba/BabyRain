//
//  MyCocos2DClass.m
//  physBall
//
//  Created by Jacob Torba on 1/28/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "popupLayer.h"

@implementation popupLayer

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	popupLayer *layer = [popupLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(void)onEnter {
    [super onEnter];
    CCNode * menuBoard = [CCNode node];
    
    CGSize size = [CCDirector sharedDirector].winSize;
    
    bg = [CCSprite spriteWithFile:@"menu.png"];
    
    CCLabelTTF *gj = [CCLabelTTF labelWithString:@"Disable Multitasking Gestures"fontName:@"Arial-BoldMT" fontSize:50];
    CCLabelTTF *gj2 = [CCLabelTTF labelWithString:@"for Best Experience"fontName:@"Arial-BoldMT" fontSize:50];
    gj.position =  ccp( 0 , 100);
    gj2.position =  ccp( 0 , 40);
    
    
    int height = size.height + [bg boundingBox].size.height;
    
    menuBoard.position = ccp( size.width/2 , height );
    
    //Menu
    CCMenuItemFont *closeItem = [CCMenuItemFont itemWithString:@"Close" target:self selector:@selector(close:)];
    closeItem.fontName = @"Arial-BoldMT";
    closeItem.fontSize = 50;
    closeItem.position = ccp(300, 0);
    
    CCMenuItemFont *finalCloseItem = [CCMenuItemFont itemWithString:@"Do Not Show Again" target:self selector:@selector(finalClose:)];
    finalCloseItem.fontName = @"Arial-BoldMT";
    finalCloseItem.fontSize = 50;
    finalCloseItem.position = ccp(-150, 0);
    
    CCMenu * menuButtons = [CCMenu menuWithItems:closeItem, finalCloseItem, nil];
    menuButtons.position = ccp(0,-200);
    
    
    [menuBoard addChild:bg];
    [menuBoard addChild:gj];
    [menuBoard addChild:gj2];
    [menuBoard addChild:menuButtons];
    [self addChild:menuBoard];
    
    
    CCMoveTo *move1 = [CCMoveTo actionWithDuration:1 position:ccp(size.width/2, size.height/2)];
    CCEaseBounceOut *ease = [CCEaseBounceOut actionWithAction:move1];
    
    [menuBoard runAction:[CCSequence actions:ease, nil]];
    


}

-(void)close: (CCMenuItem *)menuItem {
    [self removeAllChildrenWithCleanup:YES];
}

-(void)finalClose: (CCMenuItem *)menuItem {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"closePopup"];
    
    [self removeAllChildrenWithCleanup:YES];
}

@end
