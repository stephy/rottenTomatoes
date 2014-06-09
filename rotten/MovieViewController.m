//
//  MovieViewController.m
//  rotten
//
//  Created by Stephani Alves on 6/8/14.
//  Copyright (c) 2014 stephanimoroni. All rights reserved.
//

#import "MovieViewController.h"
#import <AFNetworking/UIKit+AFNetworking.h>

@interface MovieViewController ()

@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterBg;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation MovieViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSDictionary *current = self.currentMovie;
    
    self.synopsisLabel.numberOfLines = 0;
    self.movieTitleLabel.text = [current objectForKey:@"title"];
    self.synopsisLabel.text = [current objectForKey:@"synopsis"];
    
    [self.synopsisLabel sizeToFit];
    
    NSString *posterUrlThumbnail = [current objectForKey:@"posters"][@"original"];
    
    //Asynchronously load the image
    [self.posterBg setImageWithURL:[NSURL URLWithString:posterUrlThumbnail]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
