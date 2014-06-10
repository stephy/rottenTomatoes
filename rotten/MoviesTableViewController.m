//
//  MoviesTableViewController.m
//  rotten
//
//  Created by Stephani Alves on 6/8/14.
//  Copyright (c) 2014 stephanimoroni. All rights reserved.
//

#import "MoviesTableViewController.h"
#import <AFNetworking/UIKit+AFNetworking.h>
#import "MBProgressHUD.h"
#import "Reachability.h"

@interface MoviesTableViewController () {
    BOOL canRefresh;
}

//my array of movies
@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UIView *networkErrorView;

@end

@implementation MoviesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //hide network error banner
    [self hideNetworkErrorView:YES];
    //load data
    [self loadData];
    
    // setup refreshControl for iOS 6
	if([self respondsToSelector:@selector(refreshControl)]) {
        self.refreshControl = [[UIRefreshControl alloc] init];
		[self.refreshControl addTarget:self action:@selector(refreshInvoked:forState:) forControlEvents:UIControlEventValueChanged];
		canRefresh = YES;
	}
    
    //load personalized cell
    //registration process
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    
    //set row height
    self.tableView.rowHeight = 120;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return the number of rows you want in this table view
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    cell.movieTitleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"synopsis"];
    
    NSString *posterUrlThumbnail = movie[@"posters"][@"thumbnail"];
    
    //Asynchronously load the image
    [cell.posterView setImageWithURL:[NSURL URLWithString:posterUrlThumbnail]];
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //UITableViewCell *selectedCell = (UITableViewCell *)sender;
    MovieViewController *mvc = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    Movie *movie = self.movies[indexPath.row];
    
    mvc.currentMovie = movie;

}


#pragma mark - Support for reload getstures

// iOS 6 adds UIRefreshControl (see viewDidLoad: above)
-(void) refreshInvoked:(id)sender forState:(UIControlState)state {
    [self loadData];
    [self.refreshControl endRefreshing];
}

-(BOOL)canBecomeFirstResponder
{
    return !canRefresh;
}

-(void)viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

-(void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        [self loadData];
    }
}

-(void)loadData {

    BOOL internet = [self checkInternet];
    
    //only load data if there's internet
    if (internet) {
        
        //add loader
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            //load data from rotten tomattoes
            //set up network call
            NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            
            //callback
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                //NSLog(@"%@", object);
                
                self.movies = object[@"movies"];
                
                //without this table loads empty
                [self.tableView reloadData];
                
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
        
    }//end of if

}

#pragma mark - Support for network error

- (BOOL) connectedToNetwork {
    Reachability *r = [Reachability reachabilityWithHostName:@"rottentomatoes.com"];
    
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	BOOL internet;

	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) {
		internet = NO;
	} else {
		internet = YES;
	}
	return internet;
}

-(BOOL) checkInternet {
	//Make sure we have internet connectivity
	if([self connectedToNetwork] != YES) {
        [self hideNetworkErrorView:NO];
		return NO;
	} else {
        [self hideNetworkErrorView:YES];
		return YES;
	}
}


-(void)hideNetworkErrorView: (BOOL)status {
    if (status) {
        //resize to 0,0
        self.networkErrorView.hidden = YES;
        CGRect newFrame = self.networkErrorView.frame;
        
        newFrame.size.height = 0;
        [self.networkErrorView setFrame:newFrame];
        
    }else{
        //resize to 0, 50
        self.networkErrorView.hidden = NO;
        CGRect newFrame = self.networkErrorView.frame;
        
        newFrame.size.height = 45;
        [self.networkErrorView setFrame:newFrame];
    }
}


@end
