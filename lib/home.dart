import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/Service/api_service.dart';
import 'package:weatherapp/Service/location_service.dart';
import 'package:weatherapp/weekly/weekly.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:weatherapp/Provider/weather_animations.dart';
import 'package:lottie/lottie.dart';
import 'Theme/theme_toggle_button.dart';

class WeatherAppHomeScreen extends StatefulWidget {
  final Function(String) onWeatherConditionChanged;
  final VoidCallback onToggleTheme;

  const WeatherAppHomeScreen({
    super.key,
    required this.onWeatherConditionChanged,
    required this.onToggleTheme,
  });

  @override
  State<WeatherAppHomeScreen> createState() => _WeatherAppHomeScreenState();
}

class _WeatherAppHomeScreenState extends State<WeatherAppHomeScreen> {
  final weatherService = WeatherApiService();
  final TextEditingController searchController = TextEditingController();
  late stt.SpeechToText speech;

  String city = "Lahore";
  String country = '';
  Map<String, dynamic> currentValue = {};
  List<dynamic> hourly = [];
  List<dynamic> pastWeek = [];
  List<dynamic> next7days = [];
  bool isLoading = false;
  bool isListening = false;

  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();
    searchController.text = "";
    fetchWeather();
  }

  @override
  void dispose() {
    searchController.dispose();
    speech.stop();
    super.dispose();
  }

  Future<void> startListening() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Microphone permission denied")),
      );
      return;
    }

    bool available = await speech.initialize(
      onStatus: (status) => print('Speech status: $status'),
      onError: (error) => print('Speech error: $error'),
    );

    if (available) {
      setState(() 
      {
        
         isListening = true;
      }
      );
      speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            String spokenCity = result.recognizedWords;
            setState(() {
              city = spokenCity;
              searchController.text = spokenCity;
            });
            fetchWeather();
          }
        },
      );
    }
    
     else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Speech recognition not available.")),
      );
    }
  }

Future<void> fetchWeather() async {
  setState(() {
    isLoading = true;
  });

    try {
      var locationStatus = await Permission.locationWhenInUse.request();

      if (city.trim().isEmpty || city == "Lahore") {
        if (locationStatus == PermissionStatus.granted)
         {
          String? currentCity = await LocationService.getCityFromLocation();
          if (currentCity != null && currentCity.isNotEmpty) {
            city = currentCity;
          }
           else {
            city = "Lahore";
          }
        } 
        else {
          city = "Lahore";
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Location denied.....")),
          );
        }
      }

      final forecast = await weatherService.getHourlyForecast(city);
      final past = await weatherService.getPastSevenDaysWeather(city);

      if (!mounted) return;

      setState(() {
        currentValue = forecast['current'] ?? {};
        
        widget.onWeatherConditionChanged(currentValue['condition']?['text'] ?? 'Clear');
        hourly = forecast['forecast']?['forecastday']?[0]?['hour'] ?? [];
        next7days = forecast['forecast']?['forecastday'] ?? [];
        pastWeek = past;
        city = forecast['location']?['name'] ?? city;
        country = forecast['location']?['country'] ?? '';
        isLoading = false;
      });
    }
     catch (e)
      {
      setState(() {
        currentValue = {};
        hourly = [];
        pastWeek = [];
        next7days = [];
        isLoading = false;
      }
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch weather.")),
      );
    }
  }

  String formatTime(String timeString) {
    DateTime time = DateTime.parse(timeString);
    return DateFormat.j().format(time);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget weatherImage = currentValue['condition'] != null &&
            currentValue['condition']['text'] != null
        ? Lottie.asset(
            getLottieAnimation(currentValue['condition']['text']),
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          )  : const SizedBox(height: 200);

    String maxTemp = '';
    if (hourly.isNotEmpty) {
      maxTemp = hourly
          .map((h) => (h['temp_c'] as num).toDouble())
          .reduce((a, b) => a > b ? a : b)
          .toString();
    }

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 126, 187, 218),
        actions: [
          const SizedBox(width: 30),
          SizedBox(
            width: 270,
            height: 50,
            child: TextField(
              controller: searchController,
              style: TextStyle(color: theme.colorScheme.onPrimary),
              onSubmitted: (value) {
                if (value.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter a city name")),
                  );
                  return;
                }
               setState(() {
                     city = value.trim();
                            });

                         fetchWeather();

              },
              decoration: InputDecoration(
                labelText: "Search City",
                labelStyle: TextStyle(color: theme.colorScheme.onPrimary),
                prefixIcon: Icon(Icons.search, color: theme.colorScheme.onPrimary),
                suffixIcon: IconButton(
                  icon: Icon(
                    isListening ? Icons.mic_none : Icons.mic,
                    color: theme.colorScheme.onPrimary,
                  ),
                  onPressed: startListening,
                ),


                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: theme.colorScheme.onPrimary),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: theme.colorScheme.onPrimary),
                ),
              ),
            ),
          ),
          const Spacer(),
         
          ThemeToggleButton(
            onToggleTheme: widget.onToggleTheme,
            currentBrightness: theme.brightness,
            iconColor: theme.colorScheme.onPrimary,
          ),
          const SizedBox(width: 25),
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.blue))
            : currentValue.isEmpty
                ? const Center(child: Text("No data found"))
                : SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          '$city${country.isNotEmpty ? ', $country' : ''}',
                          style: TextStyle(
                            fontSize: 25,
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${currentValue['temp_c']}°C',
                          style: TextStyle(
                            fontSize: 50,
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          currentValue['condition']['text'],
                          style: TextStyle(
                            fontSize: 20,
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        weatherImage,
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.primary,
                                 
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                buildInfoColumn(context, "https://cdn-icons-png.flaticon.com/512/4148/4148460.png", "${currentValue['humidity']}%", "Humidity"),
                                buildInfoColumn(context, "https://cdn-icons-png.flaticon.com/512/5918/5918654.png", "${currentValue['wind_kph']} kph", "Wind"),
                                buildInfoColumn(context, "https://cdn-icons-png.flaticon.com/512/6281/6281340.png", maxTemp, "Max Temp"),
                              ],
                            ),
                          ),
                        ),
                        
                        Container(
                          height: 250,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: theme.colorScheme.secondary),
                            ),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                          ),

                          
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Today Forecast", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.secondary)),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => WeeklyForecast(
                                              city: city,
                                              currentValue: currentValue,
                                              pastWeek: pastWeek,
                                              next7days: next7days,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text("Weekly Forecast", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.secondary)),
                                    ),
                                  ],


                                ),
                              ),
                              SizedBox(
                                height: 150,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: hourly.length,
                                  itemBuilder: (context, index) {
                                    final hour = hourly[index];
                                    final now = DateTime.now();
                                    final hourTime = DateTime.parse(hour['time']);
                                    final isCurrentHour = now.hour == hourTime.hour && now.day == hourTime.day;


                                    return Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: isCurrentHour
                                          ? const Color.fromARGB(255, 249, 170, 66)
                                          : const Color.fromARGB(221, 126, 126, 126),
                                          borderRadius: BorderRadius.circular(40),
                                        ),

                                        child: Column(
                                          children: [
                                            Text(isCurrentHour ? "Now" : formatTime(hour['time']),
                                                style: TextStyle(
                                                  color: theme.colorScheme.secondary,
                                                  fontWeight: FontWeight.w500,
                                                )),
                                            const SizedBox(height: 10),
                                            Image.network(
                                              "https:${hour['condition']['icon']}",
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                                            ),

                                            const SizedBox(height: 10),
                                            Text("${hour['temp_c']}°C",
                                                style: TextStyle(
                                                  color: theme.colorScheme.secondary,
                                                  fontWeight: FontWeight.w500,
                                                )),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget buildInfoColumn(BuildContext context,
      String iconUrl,
      String value,
      String label) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Image.network(iconUrl, width: 60, height: 40),
        Text(value,
            style: TextStyle(color: theme.colorScheme.secondary,
                fontWeight: FontWeight.bold)),
        Text(label,
            style: TextStyle(color: theme.colorScheme.secondary)),
      ],
    );
  }
}
