package main

import (
	"github.com/go-flutter-desktop/go-flutter"
	"github.com/go-flutter-desktop/plugins/path_provider"
	"github.com/go-flutter-desktop/plugins/image_picker"
	"github.com/go-flutter-desktop/plugins/shared_preferences"
)

var options = []flutter.Option{
	flutter.WindowInitialDimensions(800, 1280),
	flutter.AddPlugin(&path_provider.PathProviderPlugin{
    	VendorName:      "selfish.systems",
    	ApplicationName: "kaminari-wallet",
    }),
    flutter.AddPlugin(&shared_preferences.SharedPreferencesPlugin{
    	VendorName:      "selfish.systems",
    	ApplicationName: "kaminari-wallet",
    }),
    flutter.AddPlugin(&image_picker.ImagePickerPlugin{}),
}
