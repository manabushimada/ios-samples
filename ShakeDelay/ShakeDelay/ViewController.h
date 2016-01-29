//
//  ViewController.h
//  ShakeDelay
//
//  Created by manabu shimada on 19/01/2016.
//  Copyright © 2016 Asio Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <EZAudio.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet EZAudioPlot *audioPlot;

@property (nonatomic, strong) EZAudioFile *audioFile;
@property (nonatomic, strong) EZAudioPlayer *player;

@end

