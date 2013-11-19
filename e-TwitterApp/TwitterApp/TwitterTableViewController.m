#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kYouTubeMostPop [NSURL URLWithString:@"https://api.twitter.com/1/statuses/user_timeline.json?include_entities=true&include_rts=true&screen_name=Oprah&count=8"]

#import "TwitterTableViewController.h"
#import "Tweet.h"


@interface TwitterTableViewController (){

    NSMutableArray * tweetArray;
}

@end

@implementation TwitterTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tweetArray = [[NSMutableArray alloc]init];
       
    dispatch_async(kBgQueue, ^{
        
        NSData * data = [NSData dataWithContentsOfURL:kYouTubeMostPop];
        
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedData:(NSData *)responseData {
    
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    
    for (NSDictionary * twitter in json) {
        
        Tweet * tempTweet = [[Tweet alloc]init];
        
        // Print all twitter items
        for (NSString * item in twitter) {
            NSLog(@"item: %@", item);
        }
        
        NSDictionary * user =  [twitter objectForKey:@"user"];
         // Print all user items
        for (NSString * userItem in user) {
            NSLog(@"user item: %@", userItem);
        }
    
        NSString * text = [twitter objectForKey:@"text"];
        NSString * userName = [user objectForKey:@"name"];
        NSString * iconFile = [user objectForKey:@"profile_image_url_https"];
        
        tempTweet.text = text;
        tempTweet.name = userName;
        tempTweet.iconFile = iconFile;
        
        // Push Tweet in to the array
        [tweetArray addObject:tempTweet];
    }
    
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
       
    NSLog(@"COUNT: %i", [tweetArray count]);
    
    return [tweetArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    // Configure the cell...
    if (cell == nil) {
        // Create a cell a give it a style UITableViewCellStyleDefault, UITableViewCellStyleSubtitle
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Tweet * tempTweet =  [tweetArray objectAtIndex:indexPath.row];
    
    // Configure the cell...
    cell.textLabel.text = tempTweet.name;
    cell.detailTextLabel.text = tempTweet.text;
    
    
    NSURL * imageURL = [NSURL URLWithString:tempTweet.iconFile];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage * image = [UIImage imageWithData:imageData];
    
    cell.imageView.image = image;

    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
