//
//  ViewController.m
//  CityWeatherLibrary
//
//
//  MARK: - City Weather & Library Info App
//  Task 2.1 + Variant 7: Display temperature (with color) + library image + address
//  Localization: Russian, English, Belarusian
//

#import "ViewController.h"

// MARK: - Interface Extension
@interface ViewController ()

// MARK: - IBOutlets
@property (weak, nonatomic) IBOutlet UISegmentedControl *countrySegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *citySegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *libraryImageView;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;

// MARK: - Data Properties
@property (strong, nonatomic) NSDictionary *citiesData;
@property (strong, nonatomic) NSDictionary *countryCitiesMap;
@property (strong, nonatomic) NSArray *countries;

@end

// MARK: - Implementation
@implementation ViewController

// MARK: - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupData];
    [self setupInitialUI];
    [self updateCitySegmentsForCountry:self.countrySegmentedControl.selectedSegmentIndex];
    [self updateDisplay];
}

// MARK: - Data Setup
- (void)setupData {
    // MARK: City Database
    // Structure: city name -> @{@"country":, @"temp":, @"libraryImage":, @"address":}
    self.citiesData = @{
        // Belarus (Беларусь)
        @"Минск": @{
            @"country": @"Беларусь",
            @"country_en": @"Belarus",
            @"country_be": @"Беларусь",
            @"temp": @(5),
            @"libraryImage": @"lib_minsk",
            @"address": @"ул. Независимости, 116",
            @"address_en": @"116 Nezavisimosti Ave",
            @"address_be": @"вул. Незалежнасці, 116"
        },
        @"Гродно": @{
            @"country": @"Беларусь",
            @"country_en": @"Belarus",
            @"country_be": @"Беларусь",
            @"temp": @(3),
            @"libraryImage": @"lib_grodno",
            @"address": @"ул. Карла Маркса, 23",
            @"address_en": @"23 Karl Marx St",
            @"address_be": @"вул. Карла Маркса, 23"
        },
        
        // Lithuania (Литва)
        @"Вильнюс": @{
            @"country": @"Литва",
            @"country_en": @"Lithuania",
            @"country_be": @"Літва",
            @"temp": @(6),
            @"libraryImage": @"lib_vilnius",
            @"address": @"Gedimino pr. 51",
            @"address_en": @"51 Gediminas Ave",
            @"address_be": @"праспект Гедзіміна, 51"
        },
        @"Каунас": @{
            @"country": @"Литва",
            @"country_en": @"Lithuania",
            @"country_be": @"Літва",
            @"temp": @(4),
            @"libraryImage": @"lib_kaunas",
            @"address": @"Laisvės al. 55",
            @"address_en": @"55 Freedom Ave",
            @"address_be": @"праспект Свабоды, 55"
        }
    };
    
    // MARK: Country to cities mapping
    self.countryCitiesMap = @{
        @"Беларусь": @[@"Минск", @"Гродно"],
        @"Литва": @[@"Вильнюс", @"Каунас"]
    };
    
    self.countries = @[@"Беларусь", @"Литва"];
}

// MARK: - UI Setup
- (void)setupInitialUI {
    // Setup country segmented control
    [self.countrySegmentedControl removeAllSegments];
    for (NSInteger i = 0; i < self.countries.count; i++) {
        [self.countrySegmentedControl insertSegmentWithTitle:[self localizedCountryName:self.countries[i]] atIndex:i animated:NO];
    }
    self.countrySegmentedControl.selectedSegmentIndex = 0;
    
    // Add target for country change
    [self.countrySegmentedControl addTarget:self action:@selector(countryChanged:) forControlEvents:UIControlEventValueChanged];
    [self.citySegmentedControl addTarget:self action:@selector(cityChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)updateCitySegmentsForCountry:(NSInteger)countryIndex {
    NSString *country = self.countries[countryIndex];
    NSArray *cities = self.countryCitiesMap[country];
    
    [self.citySegmentedControl removeAllSegments];
    for (NSInteger i = 0; i < cities.count; i++) {
        [self.citySegmentedControl insertSegmentWithTitle:cities[i] atIndex:i animated:NO];
    }
    self.citySegmentedControl.selectedSegmentIndex = 0;
}

// MARK: - Localization Helpers
- (NSString *)localizedCountryName:(NSString *)country {
    if ([country isEqualToString:@"Беларусь"]) {
        return NSLocalizedString(@"belarus", @"Belarus");
    } else if ([country isEqualToString:@"Литва"]) {
        return NSLocalizedString(@"lithuania", @"Lithuania");
    }
    return country;
}

- (NSString *)getLocalizedAddressForCity:(NSString *)city {
    NSDictionary *cityInfo = self.citiesData[city];
    NSString *currentLanguage = [[NSLocale preferredLanguages] firstObject];
    
    if ([currentLanguage hasPrefix:@"ru"]) {
        return cityInfo[@"address"];
    } else if ([currentLanguage hasPrefix:@"be"]) {
        return cityInfo[@"address_be"];
    } else {
        return cityInfo[@"address_en"];
    }
}

- (NSString *)getLocalizedCountryForCity:(NSString *)city {
    NSDictionary *cityInfo = self.citiesData[city];
    NSString *currentLanguage = [[NSLocale preferredLanguages] firstObject];
    
    if ([currentLanguage hasPrefix:@"ru"]) {
        return cityInfo[@"country"];
    } else if ([currentLanguage hasPrefix:@"be"]) {
        return cityInfo[@"country_be"];
    } else {
        return cityInfo[@"country_en"];
    }
}

// MARK: - Temperature Color Logic
- (UIColor *)colorForTemperature:(NSInteger)temperature {
    // MARK: Color mapping based on temperature
    if (temperature <= -10) {
        return [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0]; // Deep blue
    } else if (temperature <= 0) {
        return [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0]; // Light blue
    } else if (temperature <= 5) {
        return [UIColor colorWithRed:0.0 green:0.8 blue:0.0 alpha:1.0]; // Cold green
    } else if (temperature <= 10) {
        return [UIColor colorWithRed:0.5 green:0.8 blue:0.0 alpha:1.0]; // Yellow-green
    } else if (temperature <= 15) {
        return [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0]; // Yellow
    } else if (temperature <= 20) {
        return [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0]; // Orange
    } else if (temperature <= 25) {
        return [UIColor colorWithRed:1.0 green:0.2 blue:0.0 alpha:1.0]; // Orange-red
    } else if (temperature <= 30) {
        return [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]; // Red
    } else if (temperature <= 35) {
        return [UIColor colorWithRed:0.8 green:0.0 blue:0.0 alpha:1.0]; // Dark red
    } else {
        return [UIColor colorWithRed:0.5 green:0.0 blue:0.0 alpha:1.0]; // Maroon
    }
}

// MARK: - Display Update
- (void)updateDisplay {
    // Get current selections
    NSString *country = self.countries[self.countrySegmentedControl.selectedSegmentIndex];
    NSArray *cities = self.countryCitiesMap[country];
    NSString *selectedCity = cities[self.citySegmentedControl.selectedSegmentIndex];
    
    NSDictionary *cityInfo = self.citiesData[selectedCity];
    
    // MARK: Update temperature with color
    NSInteger temp = [cityInfo[@"temp"] integerValue];
    self.temperatureLabel.text = [NSString stringWithFormat:@"%ld°C", (long)temp];
    self.temperatureLabel.textColor = [self colorForTemperature:temp];
    
    // MARK: Update other info
    self.cityNameLabel.text = selectedCity;
    self.countryLabel.text = [NSString stringWithFormat:@"%@: %@",
                              NSLocalizedString(@"country_label", @"Country:"),
                              [self getLocalizedCountryForCity:selectedCity]];
    
    self.addressLabel.text = [NSString stringWithFormat:@"%@: %@",
                              NSLocalizedString(@"address_label", @"Address:"),
                              [self getLocalizedAddressForCity:selectedCity]];
    
    // MARK: Update library image
    NSString *imageName = cityInfo[@"libraryImage"];
    self.libraryImageView.image = [UIImage imageNamed:imageName];
    
    // FIXME: Add placeholder image if library image is missing
    if (!self.libraryImageView.image) {
        self.libraryImageView.image = [UIImage imageNamed:@"placeholder"];
    }
}

// MARK: - IBActions
- (void)countryChanged:(UISegmentedControl *)sender {
    [self updateCitySegmentsForCountry:sender.selectedSegmentIndex];
    [self updateDisplay];
}

- (void)cityChanged:(UISegmentedControl *)sender {
    [self updateDisplay];
}

// MARK: - Refresh Button Action
- (IBAction)refreshTapped:(id)sender {
    [self updateDisplay];
}

@end
