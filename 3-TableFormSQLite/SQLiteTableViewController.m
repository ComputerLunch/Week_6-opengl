#import "SQLiteTableViewController.h"
// IMPORT SQLite
#import "sqlite3.h"


@interface SQLiteTableViewController (){
    
    NSMutableArray * names;   
}

@end

@implementation SQLiteTableViewController

//-----------------------------------
// SQLite functions
// Get the array of names back and places them in our names array
//-----------------------------------
static int MyCallback(void * context, int count, char **values, char ** columns)
{    
    NSMutableArray * pointerToNames = (__bridge NSMutableArray * ) context;
    for(int i=0; i < count; i++){
        
        const char *nameCString = values[i];
        [pointerToNames addObject:[NSString stringWithUTF8String:nameCString]];
        NSLog(@"NAME: %@", [NSString stringWithUTF8String:nameCString]);
    }
    return SQLITE_OK;
}

-(void)loadNamesFromDatabase{
    NSString * file = [[NSBundle mainBundle]pathForResource:@"names" ofType:@"db"];
    sqlite3 * database = NULL;
    
    // open database check if returns ok
    if(sqlite3_open([file UTF8String], &database)==SQLITE_OK){
        // execute SQL call on database return array of names
        sqlite3_exec(database, "SELECT name FROM person", MyCallback, (__bridge void * )names, NULL);
    }
    // Close database
    sqlite3_close(database);
}


//-----------------------------------
// END SQLite functions
//-----------------------------------
- (void)viewDidLoad
{
    // init array
    names = [[NSMutableArray alloc]init];
    
    // call the database and populate names array
    [self loadNamesFromDatabase];
    
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [names count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = [names objectAtIndex:indexPath.row];
    
    return cell;
}

@end
