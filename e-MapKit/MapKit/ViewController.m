#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	

}

- (void)viewWillAppear:(BOOL)animated {
    
    // 1
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.longitude = -74.0064;
    zoomLocation.latitude = 40.7142;
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 12000, 12000);
    // 3
    MKCoordinateRegion adjustedRegion = [_mapKit regionThatFits:viewRegion];
    // 4
    [_mapKit setRegion:adjustedRegion animated:YES];

}


- (IBAction)goHome:(id)sender {
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.longitude = -71.0064;
    zoomLocation.latitude = 43.7142;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 2000,2000);
    MKCoordinateRegion adjustedRegion = [_mapKit regionThatFits:viewRegion];
    
    
    [_mapKit setRegion:adjustedRegion animated:YES];

}

- (IBAction)goWork:(id)sender {
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.longitude = -74.0264;
    zoomLocation.latitude = 40.7342;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 22200, 22200);
    MKCoordinateRegion adjustedRegion = [_mapKit regionThatFits:viewRegion];
    
    
    [_mapKit setRegion:adjustedRegion animated:YES];

}

- (IBAction)goFamily:(id)sender {
    
    // 1
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.longitude = -74.0064;
    zoomLocation.latitude = 40.7142;
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 500, 500);
    // 3
    MKCoordinateRegion adjustedRegion = [_mapKit regionThatFits:viewRegion];
    // 4
    [_mapKit setRegion:adjustedRegion animated:YES];
}
@end
