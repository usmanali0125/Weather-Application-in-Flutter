import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherapp/Provider/weather_animations.dart';

class WeeklyForecast extends StatefulWidget {
  final Map<String, dynamic> currentValue;
  final String city;
  final List<dynamic> pastWeek;
  final List<dynamic> next7days;

  const WeeklyForecast({
    super.key,
    required this.city,
    required this.currentValue,
    required this.pastWeek,
    required this.next7days,
  });

  @override
  State<WeeklyForecast> createState() => _WeeklyForecastState();
}

class _WeeklyForecastState extends State<WeeklyForecast> {
  String formatApiData(String dataString) {
    DateTime date = DateTime.parse(dataString);
    return DateFormat('d MMMM, EEEE').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); 

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, 
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
      Center(
        child: Column(
          children: [
           Row(
              mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 IconButton(
                          icon: Icon(Icons.arrow_back_ios, color: theme.colorScheme.onSurface), 
                    onPressed: () {
                      
                      Navigator.pop(context);
                    } 
                        ),
                      ],
                    ),
                    Text(
                      widget.city,
                style: TextStyle(
                  fontSize: 30,
                    color: theme.colorScheme.secondary, 
                  fontWeight: FontWeight.w400,
                      ),
                    ),
               Text(
                      '${widget.currentValue['temp_c']}°C',
                  
                      style: TextStyle(
                   fontSize: 50,
                        color: theme.colorScheme.secondary, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.currentValue['condition']['text'],
                      style: TextStyle(
                  fontSize: 20,
                  color: theme.colorScheme.secondary, 
                    fontWeight: FontWeight.w400,
                      ),
                    ),
                    Lottie.asset(
                      getLottieAnimation(widget.currentValue['condition']?['text'] ?? ''),
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
        Text(
                "Next 7 Days Forecast",
          style: TextStyle(
          fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.secondary, 
                ),
              ),

    const SizedBox(height: 10),
              ...widget.next7days.map((day) {
                final data = day['date'] ?? '';
                final condition = day['day']?['condition']?['text'] ?? '';
                final icon = day['day']?['condition']?['icon'] ?? '';
                final maxTemp = day['day']?['maxtemp_c'] ?? '';
                final minTemp = day['day']?['mintemp_c'] ?? '';

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.onSurface.withAlpha(128), width: 1.5), 
                    borderRadius: BorderRadius.circular(12),
                    color: theme.colorScheme.surface.withAlpha(204), 
                  ),
                  child: ListTile(
                    leading: Image.network('https:$icon', width: 40),
                    title: Text(
                      formatApiData(data),
                      style: TextStyle(color: theme.colorScheme.onSurface), 
                    ),

                    subtitle: Text(
                      "$condition \n $minTemp°C - $maxTemp°C",
                      style: TextStyle(color: theme.colorScheme.onSurface), 
                    ),
                  ),
                );
              }),


              const SizedBox(height: 20),
              Text(
                "Previous 7 Days Forecast",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.secondary, 
                ),
              ),


              const SizedBox(height: 10),
              ...widget.pastWeek.map((day) 
              {
                final forecastDay = day['forecast']?['forecastday'];
                if (forecastDay == null || forecastDay.isEmpty) {
                  return const SizedBox.shrink();
                }
                final forecast = forecastDay[0];
                final data = forecast['date'] ?? '';
                final condition = forecast['day']?['condition']?['text'] ?? '';
                final icon = forecast['day']?['condition']?['icon'] ?? '';
                final maxTemp = forecast['day']?['maxtemp_c'] ?? '';
                final minTemp = forecast['day']?['mintemp_c'] ?? '';


                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withAlpha(204), 
                    border: Border.all(color: theme.colorScheme.onSurface.withAlpha(128), width: 1.5), 
                    borderRadius: BorderRadius.circular(12),
                  ),


                  child: ListTile(
                    leading: Image.network('https:$icon', width: 40),
                    title: Text(
                      formatApiData(data),
                      style: TextStyle(color: theme.colorScheme.onSurface), 
                    ),

                    subtitle: Text(
                   "$condition \n $minTemp°C - $maxTemp°C",
                     style: TextStyle(color: theme.colorScheme.onSurface), 
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
