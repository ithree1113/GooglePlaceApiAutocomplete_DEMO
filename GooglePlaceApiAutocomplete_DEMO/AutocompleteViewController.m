//
//  AutocompleteViewController.m
//  GooglePlaceApiAutocomplete_DEMO
//
//  Created by 鄭宇翔 on 2016/9/26.
//  Copyright © 2016年 鄭宇翔. All rights reserved.
//

#import "AutocompleteViewController.h"
@import GoogleMaps;
@import GooglePlaces;

@interface AutocompleteViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSArray *searchResult;
    GMSPlacesClient *placesClient;
    GMSMapView *googleMap;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *mapView;

@end

@implementation AutocompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchBar.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView setHidden:YES];
    self.tableView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];

    googleMap = [[GMSMapView alloc]initWithFrame:self.mapView.bounds];
    googleMap.myLocationEnabled = YES;
    googleMap.accessibilityElementsHidden = NO;
    [self.mapView addSubview:googleMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return searchResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultCell" forIndexPath:indexPath];

    GMSAutocompletePrediction *place = searchResult[indexPath.row];
    
    cell.textLabel.text = place.attributedPrimaryText.string;
    cell.detailTextLabel.text = place.attributedSecondaryText.string;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GMSAutocompletePrediction *place = searchResult[indexPath.row];
    
    [placesClient lookUpPlaceID:place.placeID callback:^(GMSPlace * _Nullable result, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Place Details error %@", [error localizedDescription]);
            return;
        }
        
        if (result != nil) {
            [self.tableView setHidden:YES];
            GMSCameraUpdate *cameraUpdate = [GMSCameraUpdate setTarget:result.coordinate zoom:16];
            [googleMap animateWithCameraUpdate:cameraUpdate];
            
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = result.coordinate;
            marker.title = result.name;
            marker.map = googleMap;
            
            [self.searchBar resignFirstResponder];
        } else {
            NSLog(@"No place details for %@", result.placeID);
        }
    }];
}


#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length > 0) {
        placesClient = [[GMSPlacesClient alloc] init];
        GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
        filter.type = kGMSPlacesAutocompleteTypeFilterNoFilter;
        
        [placesClient autocompleteQuery:searchText
                                 bounds:nil
                                 filter:filter
                               callback:^(NSArray *results, NSError *error) {
                                   if (error != nil) {
                                       NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                       return;
                                   }
                                   [self.tableView setHidden:NO];
                                   searchResult = results;
                                   [self.tableView reloadData];
                               }];
    } else {
        [self.tableView setHidden:YES];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [self.tableView setHidden:YES];
}


@end
