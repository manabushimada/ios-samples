//
//  ViewController.m
//  ShakeDelay
//
//  Created by manabu shimada on 19/01/2016.
//  Copyright © 2016 Asio Ltd. All rights reserved.
//

#import "ViewController.h"

@import AVFoundation;

@interface ViewController ()
{
    AVAudioPlayer *audioPlayer;
}



@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*----------------------------------------------------------------------------*
     * Load a mp3 sound
     *----------------------------------------------------------------------------*/
    NSString* path = [[NSBundle mainBundle] pathForResource:@"no4" ofType:@"mp3"];
    NSURL* file = [NSURL fileURLWithPath:path];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:file error:nil];
    [audioPlayer prepareToPlay];
}


- (IBAction)playButtonPressed:(id)sender
{
    if ([audioPlayer isPlaying]) {
        [audioPlayer pause];
    } else {
        [audioPlayer play];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
