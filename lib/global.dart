class GlobalData {
  static final GlobalData _instance = GlobalData._internal();

  factory GlobalData() {
    return _instance;
  }

  GlobalData._internal();

  int OverLoad = 800;
  int underload = 300;
}
