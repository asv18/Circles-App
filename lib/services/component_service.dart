class ComponentService {
  /**
   * proMaxWidth = 430.0
   * proMaxHeight = 932.0
   */

  //desired sizes based on iPhone 14 Pro Max size

  static double convertWidth(double mdWidth, double desiredWidth) {
    double conversion = 430.0 / desiredWidth;

    return mdWidth / conversion;
  }

  static double convertHeight(double mdHeight, double desiredHeight) {
    double conversion = 932.0 / desiredHeight;

    return mdHeight / conversion;
  }
}
