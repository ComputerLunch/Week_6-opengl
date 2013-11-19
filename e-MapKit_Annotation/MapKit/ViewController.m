#import "ViewController.h"
#import "OurAnnotation.h"

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
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 12000, 12000);
    MKCoordinateRegion adjustedRegion = [_mapKit regionThatFits:viewRegion];
    [_mapKit setRegion:adjustedRegion animated:YES];
    
    // Add annotation
    OurAnnotation *newAnnotation = [[OurAnnotation alloc] initWithTitle:@"New York Baby!" andCoordinate:zoomLocation];
    newAnnotation.subtitle = @"subTitle item";
  

    [_mapKit addAnnotation:newAnnotation];
    
    
    // Add Another annotation
    
    CLLocationCoordinate2D zoomLocation2;
    zoomLocation2.longitude = -74.0065;
    zoomLocation2.latitude = 40.7143;
    
    OurAnnotation *newAnnotation2 = [[OurAnnotation alloc] initWithTitle:@"Another One" andCoordinate:zoomLocation2];
    newAnnotation2.subtitle = @"Some bar down the street";
    
    [_mapKit addAnnotation:newAnnotation2];
    
}

@end
