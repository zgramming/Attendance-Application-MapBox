<p align="center">
  <img src="http://www.zimprov.id/absensi_online/readme/absensi_online/mapbox/banner_github.png"  height="300" width="600" style="">
</p>

# Attendance Application [Mapbox Version]

Attendance Tracking Application , implementation using flutter_map and Geolocator packages for tracking user location. Backend used is Codeigniter 3.

## Adding your Mapbox into project

1. If you already have mapbox account you can follow this <a href="https://account.mapbox.com/auth/signin/"> Link </a> or you can sign-up if you don't have account.
2. After that , go to <a href="https://studio.mapbox.com/">studio.mapbox.com</a> to create your map style. 
3. Then click **New Style** and choose a template , recommended you can choose **streets / basic** style. After choose the template you can click **Customize**

<img src="https://i.stack.imgur.com/8cwe2.png" height="500">

4.Next , You will be redirect to page for edit your map. If you have finished edit your map, click **Share** in tab production ,scroll until you find **Developer Resource**. Then select **Third Party** tab. Click dropdown and select **Carto**. After that you can copy **Integration URL** this is your style mapbox.

<img src="https://i.stack.imgur.com/O6dub.jpg" height="500">

5. If you success follow all instruction above , you will see API mapbox style something like this `https://api.mapbox.com/styles/v1/zeffryy/ckbpz3hxh4hdq1in027gqrem5/tiles/256/{z}/{x}/{y}@2x?access_token=xxx` , this url which will be used as **urlTemplate** in flutter project.

6. Then you can change **urlTemplate** in FlutterMap widget with the style that you have made. 

```
 TileLayerOptions(
                  urlTemplate:
                      'https://api.mapbox.com/styles/v1/zeffryy/ckbm42cwb124f1ipgndrdcz8p/tiles/256/{z}/{x}/{y}@2x?access_token=${AppConfig.mapBoxApiKey}',
                  subdomains: ['a', 'b', 'c'],
                ),
```

<img src="https://i.stack.imgur.com/gtnJY.png" height="500">

Reference : <a href="https://stackoverflow.com/a/58125136/7360353"> Stackoverflow </a>

## Configuration Project

Change Mapbox API Key with your in `global_template/lib/variable/config/app_config.dart`. It will be used for autocompleted Search Address

```
  static const mapBoxApiKey ='YOUR API KEY';
```


## Installing

1. Git clone **https://github.com/zgramming/Attendance-Application-MapBox**
2. cd `Attendance-Application-MapBox`
3. in terminal `flutter packages get`. After that `flutter run`


## Feature

- [x] Tracking user location
- [x] Autocomplete Search Absen Destination
- [x] Absent only at certain radius [radius color will be green if user inside radius otherwise radius color will be purple]
- [x] Detecting mockup location
- [x] Add destination based on user choose in maps
- [x] Pick Destination [this will be used as your absence location]
- [x] Recap user absence monthly, has 2 view [Card & Table look]
- [x] Recap user performance monthly
- [x] User Profil
- [x] Drawer Menu
- [ ] Unimaginable Improvements 

## Download

|app-arm64-v8a|app-armeabi-v7a|app-x86_64|
|:-----------:|:-------------:|:--------:|
|[<img src="https://upload.wikimedia.org/wikipedia/commons/a/a0/APK_format_icon.png" width="50px">](http://www.zimprov.id/absensi_online/apk/absensi_online/mapbox/app-arm64-v8a-release.apk)|[<img src="https://upload.wikimedia.org/wikipedia/commons/a/a0/APK_format_icon.png" width="50px">](http://www.zimprov.id/absensi_online/apk/absensi_online/mapbox/app-armeabi-v7a-release.apk)|[<img src="https://upload.wikimedia.org/wikipedia/commons/a/a0/APK_format_icon.png" width="50px">](http://www.zimprov.id/absensi_online/apk/absensi_online/mapbox/app-x86_64-release.apk)|
|7,8 MB|7,4 MB|8 MB|

## API

If you interested with the API in this application and want custom the API with yours , you can follow this <a href="https://github.com/zgramming/API.Absensi-Online"><b>Link<b/></a>

## Issues

Please file any issues, bugs or feature request as an issue on <a href="https://github.com/zgramming/Attendance-Application-Google-Map/issues"><b> Github </b></a>

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
