//
//  MovieTableViewCell.m
//  rotten
//
//  Created by Stephani Alves on 6/8/14.
//  Copyright (c) 2014 stephanimoroni. All rights reserved.
//

#import "MovieCell.h"

@implementation MovieCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    if(selected){
        [self setBackgroundColor:[UIColor colorWithRed:0.914 green:0.192 blue:0.278 alpha:1]]; /*#e93147*/
        self.movieTitleLabel.textColor = [UIColor whiteColor];
        self.synopsisLabel.textColor = [UIColor whiteColor];
    } else {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.movieTitleLabel.textColor = [UIColor blackColor];
        self.synopsisLabel.textColor = [UIColor blackColor];
        
    }
    
}



@end
