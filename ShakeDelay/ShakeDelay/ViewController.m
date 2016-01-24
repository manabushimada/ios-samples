//
//  ViewController.m
//  ShakeDelay
//
//  Created by manabu shimada on 19/01/2016.
//  Copyright © 2016 Asio Ltd. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <EZAudioPlayerDelegate, EZOutputDataSource>


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    /*----------------------------------------------------------------------------*
     * Setup the AVAudioSession. EZMicrophone will not work properly on iOS
     *----------------------------------------------------------------------------*/
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session category: %@", error.localizedDescription);
    }
    [session setActive:YES error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session active: %@", error.localizedDescription);
    }
    
    
    //
    // Customizing the audio plot's look
    //
    self.audioPlot.backgroundColor = [UIColor colorWithRed: 0.816 green: 0.349 blue: 0.255 alpha: 1];
    self.audioPlot.color           = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    self.audioPlot.plotType        = EZPlotTypeBuffer;
    self.audioPlot.shouldFill      = YES;
    self.audioPlot.shouldMirror    = YES;
    
    NSLog(@"outputs: %@", [EZAudioDevice outputDevices]);
    
    //
    // Create the audio player
    //
    self.player = [EZAudioPlayer audioPlayerWithDelegate:self];
    self.player.shouldLoop = YES;
    
    // Override the output to the speaker
    [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
    if (error)
    {
        NSLog(@"Error overriding output to the speaker: %@", error.localizedDescription);
    }
    
    //
    // Customize UI components
    //
    //self.rollingHistorySlider.value = (float)[self.audioPlot rollingHistoryLength];
    
    //
    // Listen for EZAudioPlayer notifications
    //
    [self setupNotifications];
    
    /*
     Try opening the sample file
     */
    /*----------------------------------------------------------------------------*
     * Load a mp3 sound
     *----------------------------------------------------------------------------*/
    NSString* path = [[NSBundle mainBundle] pathForResource:@"no4" ofType:@"mp3"];
    //NSURL* file = [NSURL fileURLWithPath:path];
    [self openFileWithFilePathURL:[NSURL fileURLWithPath:path]];


}

- (void)openFileWithFilePathURL:(NSURL *)filePathURL
{
    //
    // Create the EZAudioPlayer
    //
    self.audioFile = [EZAudioFile audioFileWithURL:filePathURL];
    
    //
    // Update the UI
    //
//    self.filePathLabel.text = filePathURL.lastPathComponent;
//    self.positionSlider.maximumValue = (float)self.audioFile.totalFrames;
//    self.volumeSlider.value = [self.player volume];
    
    //
    // Plot the whole waveform
    //
    self.audioPlot.plotType = EZPlotTypeBuffer;
    self.audioPlot.shouldFill = YES;
    self.audioPlot.shouldMirror = YES;
    __weak typeof (self) weakSelf = self;
    [self.audioFile getWaveformDataWithCompletionBlock:^(float **waveformData,
                                                         int length)
     {
         [weakSelf.audioPlot updateBuffer:waveformData[0]
                           withBufferSize:length];
     }];
    
    //
    // Play the audio file
    //
    [self.player setAudioFile:self.audioFile];
}

- (IBAction)playButtonPressed:(id)sender
{
    if ([self.player isPlaying])
    {
        [self.player pause];
    }
    else
    {
        if (self.audioPlot.shouldMirror && (self.audioPlot.plotType == EZPlotTypeBuffer))
        {
            self.audioPlot.shouldMirror = NO;
            self.audioPlot.shouldFill = NO;
        }
        [self.player play];
    }
}

#pragma mark - EZAudioPlayerDelegate

- (void)  audioPlayer:(EZAudioPlayer *)audioPlayer
          playedAudio:(float **)buffer
       withBufferSize:(UInt32)bufferSize
 withNumberOfChannels:(UInt32)numberOfChannels
          inAudioFile:(EZAudioFile *)audioFile
{
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.audioPlot updateBuffer:buffer[0]
                          withBufferSize:bufferSize];
    });
}

- (void)audioPlayer:(EZAudioPlayer *)audioPlayer
    updatedPosition:(SInt64)framePosition
        inAudioFile:(EZAudioFile *)audioFile
{
//    __weak typeof (self) weakSelf = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (!weakSelf.positionSlider.touchInside)
//        {
//            weakSelf.positionSlider.value = (float)framePosition;
//        }
//    });
}



#pragma mark - Notifications

- (void)setupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioPlayerDidChangeAudioFile:)
                                                 name:EZAudioPlayerDidChangeAudioFileNotification
                                               object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioPlayerDidChangeOutputDevice:)
                                                 name:EZAudioPlayerDidChangeOutputDeviceNotification
                                               object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioPlayerDidChangePlayState:)
                                                 name:EZAudioPlayerDidChangePlayStateNotification
                                               object:self.player];
}

- (void)audioPlayerDidChangeAudioFile:(NSNotification *)notification
{
    EZAudioPlayer *player = [notification object];
    NSLog(@"Player changed audio file: %@", [player audioFile]);
}

- (void)audioPlayerDidChangeOutputDevice:(NSNotification *)notification
{
    EZAudioPlayer *player = [notification object];
    NSLog(@"Player changed output device: %@", [player device]);
}

- (void)audioPlayerDidChangePlayState:(NSNotification *)notification
{
    EZAudioPlayer *player = [notification object];
    NSLog(@"Player change play state, isPlaying: %i", [player isPlaying]);
}

//------------------------------------------------------------------------------
#pragma mark - Utility
//------------------------------------------------------------------------------

- (void)drawBufferPlot
{
    self.audioPlot.plotType = EZPlotTypeBuffer;
    self.audioPlot.shouldMirror = NO;
    self.audioPlot.shouldFill = NO;
}

- (void)drawRollingPlot
{
    self.audioPlot.plotType = EZPlotTypeRolling;
    self.audioPlot.shouldFill = YES;
    self.audioPlot.shouldMirror = YES;
}

#pragma mark - Dealloc

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
