//
//  PlayerBarButton.h
//  StreamingAudio
//
//  Created by NguyenThanhLuan on 19/12/2016.
//  Copyright © 2016 Olala. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum State: NSUInteger {
    kUnknowState,
    kPlayState,
    kPauseState,
}State;

@protocol PlayerButtonDelegate <NSObject>

-(void)play;
-(void)pause;

@end

@interface PlayerBarButton : UIButton{
    
}

@property id<PlayerButtonDelegate>     playDelegate;
@property State     playState;

@end
