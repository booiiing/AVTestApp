//
//  FirstViewController.m
//  AVTestApp
//
//  Created by Christoph Wendt on 14.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecordAudioViewController.h"

@implementation RecordAudioViewController

@synthesize audioRecorder;
@synthesize audioPlayer;
@synthesize playButton;
@synthesize stopButton;
@synthesize recordButton;
@synthesize stateLabel;

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.playButton.enabled = NO;
    self.stopButton.enabled = NO;
    self.stateLabel.text = @"Stopped";
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"sound.caf"];
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    NSDictionary *recordSettings = [NSDictionary 
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin], 
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt: 1], 
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:16000.0], 
                                    AVSampleRateKey,
                                    [NSNumber numberWithInt:kAudioFormatAppleIMA4],
                                    AVFormatIDKey,
                                    nil];
    
    NSError *error = nil;
    
    self.audioRecorder = [[AVAudioRecorder alloc]
                     initWithURL:soundFileURL
                     settings:recordSettings
                     error:&error];
    
    if (error){
        
        NSLog(@"error: %@", [error localizedDescription]);
    } else {
        
        [self.audioRecorder prepareToRecord];
    }
}

- (void)dealloc{
    [audioPlayer release];
    [audioRecorder release];
    [stopButton release];
    [playButton release];
    [recordButton release];
    [stateLabel release];
    [super dealloc];
}

#pragma mark - User Interface Action handling

-(IBAction)recordAudio:(id)sender{
    
    self.stateLabel.text = @"Recording";
    if(!self.audioRecorder.recording){
        
        self.playButton.enabled = NO;
        self.stopButton.enabled = YES;
        [self.audioRecorder record];
    }
}
-(IBAction)stop:(id)sender{
    
    self.stateLabel.text = @"Stopped";
    self.stopButton.enabled = NO;
    self.playButton.enabled = YES;
    self.recordButton.enabled = YES;
    
    if(audioRecorder.recording){
        
        [self.audioRecorder stop];
    }else if (audioPlayer.playing) {
        
        [audioPlayer stop];
    }
}

-(IBAction)playAudio:(id)sender{
    
    self.stateLabel.text = @"Playing";
    if (!self.audioRecorder.recording){
        
        self.stopButton.enabled = YES;
        self.recordButton.enabled = NO;
        
        if (self.audioPlayer){
            
            [self.audioPlayer release];
        }
        
        NSData *audioData=[NSData dataWithContentsOfURL:self.audioRecorder.url];
        
        NSError *error;
        self.audioPlayer = [[AVAudioPlayer alloc] 
                       initWithData:audioData error:&error];
        
        self.audioPlayer.delegate = self;
        
        if (error)
            NSLog(@"Error: %@", 
                  [error localizedDescription]);
        else
            [self.audioPlayer play];
    }
}

#pragma mark - AVAudioPlayer Delegate

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    self.stateLabel.text = @"Stopped";
    self.recordButton.enabled = YES;
    self.stopButton.enabled = NO;
}

/**
 Test test test
 @param <#parameter#>
 @returns <#retval#>
 @exception <#throws#>
 */
-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    
    NSLog(@"Decode Error occurred");
}

#pragma mark - AVAudioRecorder Delegate

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{

}

-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error{
    
    NSLog(@"Encode Error occurred");
}

@end
