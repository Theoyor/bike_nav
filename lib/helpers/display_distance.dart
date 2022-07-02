String displayDistance(num meters){
  return meters >= 1000 ? "${(meters/ 1000).toStringAsFixed(1)} km" : "$meters m";
}