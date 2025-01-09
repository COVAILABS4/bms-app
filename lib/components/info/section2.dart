import 'package:flutter/material.dart';

Widget section2(Map values, BuildContext context) {
  final Map<String, String> icons = {
    "total_volt": "assets/images/total_volt_icon.png",
    "current": "assets/images/current_icon.png",
    "power": "assets/images/power_icon.png",
    "vol_high": "assets/images/vol_high_icon.png",
    "vol_low": "assets/images/vol_low_icon.png",
    "vol_diff": "assets/images/vol_diff_icon.png",
    "ave_vol": "assets/images/ave_vol_icon.png",
    "cycle_index": "assets/images/cycle_index_icon.png",
  };

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: GridView.builder(
      physics: NeverScrollableScrollPhysics(), // Prevent scrolling inside grid
      shrinkWrap: true, // Allow GridView to shrink inside its parent
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 120, // Max width of each item
        childAspectRatio: 1.2, // Aspect ratio for width and height
        crossAxisSpacing: 8, // Horizontal spacing between items
        mainAxisSpacing: 8, // Vertical spacing between items
      ),
      itemCount: values.keys.length,
      itemBuilder: (context, index) {
        String key = values.keys.elementAt(index);
        dynamic value = values[key];
        String imageUrl = icons[key] ?? "";

        return Container(
          padding: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Row(
            children: [
              // Left: Image/Icon
              Image.asset(
                imageUrl,
                width: 30,
                height: 30,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.image_not_supported, size: 30),
              ),
              SizedBox(width: 6), // Space between image and text
              // Right: Column with Value and Key
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Value
                    Text(
                      value.toString(),
                      style: TextStyle(
                        color: Color(0xFF00BFFF),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    // Key
                    Text(
                      key.replaceAll('_', ' ').toUpperCase(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
