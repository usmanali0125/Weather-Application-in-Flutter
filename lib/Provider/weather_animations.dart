String getLottieAnimation(String condition) {
  condition = condition.toLowerCase();
  if (condition.contains('sun')) return 'assets/sun.json';
  if (condition.contains('cloud')) return 'assets/cloud.json';
  if (condition.contains('rain')) return 'assets/rain.json';
  if (condition.contains('snow')) return 'assets/snow.json';
  if (condition.contains('thunder')) return 'assets/thunder.json';
  if (condition.contains('fog') || condition.contains('mist')) return 'assets/fog.json';
  return 'assets/sun.json'; 
}